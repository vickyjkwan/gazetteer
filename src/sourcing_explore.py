import json
import os
import re
import logging
import time
import requests


def get_connections(domain, url, dir_path=None):

    conn_dict = dict()
    
    dir_path = os.path.dirname(os.path.abspath(__file__))

    with open(f'{dir_path}/../.secrets/looker_secrets.json') as f:
        j = json.load(f)

    data = {
        'client_id': j['client_id'],
        'client_secret': j['client_secret']
    }

    response = requests.post(f'{domain}/login', data=data)

    access_token = response.json()['access_token']

    headers = {
        'Authorization': f'token {access_token}'
    }

    response = requests.get(domain+url, headers=headers)

    for r in response.json():
        conn_dict[r['name']] = {'database': r['database'], 'type': r['dialect']['label']}

    return conn_dict


def look_up_target_view(source_view_name, view_map):
    target_view_payload = view_map[source_view_name]
    return target_view_payload


def is_true_source(source):
    return bool(len(source.split('.')) == 3)


def get_conn_db(explore, connection_map):
    conn = explore['conn']
    database = connection_map[conn]['database']
    provider = connection_map[conn]['type'].split(' ')
    if len(provider) > 1:
        provider = provider[1]
    else:
        provider = provider[0]
        
    return provider, database

####### need to add NDT, and derived table ################
def get_true_source(dir_path, view_payload, explore, connection_map, view_map):
    
    if isinstance(view_payload, dict):

        if view_payload['view_type'] == 'extension': 

            new_view_name = look_up_target_view(view_payload['source_table'], view_map=view_map)
            with open(f'{dir_path}/../maps/{new_view_name}', 'r') as f:
                new_view_payload = json.load(f)
            return get_true_source(dir_path, new_view_payload, explore, connection_map, view_map)
            
        elif view_payload['view_type'] == 'sql_table_name': 

            source = view_payload['source_table']

            if is_true_source(source):
                true_source = view_payload['source_table']

            else: 
                if len(source.split('.')) == 4:
                    true_source = source
                
                else:
                    provider, database = get_conn_db(explore=explore, connection_map=connection_map)
                    if len(source.split('.')) == 3:
                        true_source = f'{provider}.{database}.{source}'
                    elif len(source.split('.')) == 2:
                        true_source = f'{provider}.{database}.{source}'

        elif view_payload['view_type'] == 'derived_table':
            true_source = 'derived table'

    else:
        true_source = view_payload

    return view_payload['view_name'], true_source


def get_view_source(dir_path):

    view_content = dict()
    view_map = dict()
    for view in next(os.walk(f'{dir_path}/../maps'))[2]:
        if view.startswith('view'):
            logging.info(f'Getting source tables for view {view}...')
            view_map[view.split('-')[1].split('.')[0]] = view
            with open(f'{dir_path}/../maps/{view}','r') as f:
                payload = json.load(f)
                view_content[payload['view_name']] = payload

    return view_map, view_content

def get_explore_source(model_name, explore_path, dir_path, view_content, view_map, connection_map):
    start = time.process_time()
    
    logging.basicConfig()
    logging.getLogger().setLevel(logging.INFO)

    with open(explore_path, 'r') as f:
        explore = json.load(f)

    source_payload = dict()
    for view_name,view_payload in view_content.items():
        logging.info(f"Processing View source {view_payload['view_name']}...")
        if view_name in explore['explore_joins']:
            base_view_name, source_table = get_true_source(f'{dir_path}', view_payload, explore=explore, connection_map=connection_map, view_map=view_map)
            logging.info(f"view name: {view_name} , base view name: {base_view_name}, source: {source_table}")
            source_payload[view_name] = dict()
            source_payload[view_name]['view_name'] = base_view_name
            source_payload[view_name]['base_view_name'] = source_table  

    with open(f"{dir_path}/../maps/{model_name}/map-model-{model_name}-explore-{explore['explore_name']}-source.json", 'w') as f:
        json.dump(source_payload, f)

    end = time.process_time()

    logging.info(f'Completed process in {end-start} seconds.')   


if __name__ == "__main__":
     
    dir_path = os.path.dirname(os.path.realpath(__file__))
    connection_map = get_connections(domain='https://docker.looker.com:19999', url='/api/3.1/connections')
    view_map, view_content = get_view_source(dir_path)

    # for model_folder in next(os.walk(f'{dir_path}/../maps'))[1]:
    model_folder = 'snowflake_salesforce'

    for explore_file in os.listdir(f'{dir_path}/../maps/{model_folder}'):
        if explore_file.startswith('explore-'):
            print(f'Starting to get source tables for model {model_folder} explore {explore_file}...')
            get_explore_source(model_folder, f'{dir_path}/../maps/{model_folder}/{explore_file}', dir_path=dir_path, view_map=view_map, view_content=view_content, connection_map=connection_map)
