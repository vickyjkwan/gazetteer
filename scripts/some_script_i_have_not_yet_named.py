import json
import os
import re
import get_connections
import logging
# from multiprocessing import Pool
import time

# connection_map = {'hub': {'database': 'accounts', 'type': 'PostgreSQL'}}

# explore = {'explore_name': 'sf__accounts',
#     'explore_joins': ['sf__accounts',
#     'sf__users',
#     'sf__contacts',
#     'sf__cases',
#     'sf__users'],
#     'conn': 'data_warehouse'
#     }

# view_payload_1 = {'view_name': 'sf__contacts',
#     'source_table': 'sfbase__contacts',
#     'view_type': 'extension'
#     }

# view_map = {'sfbase__accounts': 'view-sf__accounts-sfbase__accounts.json',
#     'sf__accounts': 'view-sf__accounts-sf__accounts.json',
#     'snowflake_sf__accounts': 'view-sf__accounts-snowflake_sf__accounts.json',
#     'total_active_node_count': 'view-sf__accounts-total_active_node_count.json',
#     'sf__cases': 'view-sf__cases-sf__cases.json',
#     'sfbase__users': 'view-sf__users-sfbase__users.json',
#     'sf__contacts': 'view-sf__contacts-sf__contacts.json',
#     'sfbase__cases': 'view-sf__cases-sfbase__cases.json',
#     'sf__users': 'view-sf__users-sf__users.json',
#     'sfbase__contacts': 'view-sf__contacts-sfbase__contacts.json'
#     }


def look_up_target_view(source_view_name, view_map):
    target_view_payload = view_map[source_view_name]
    return target_view_payload


def is_true_source(source):
    return bool(len(source.split('.')) == 4)


def get_conn_db(explore, connection_map):
    conn = explore['conn']
    database = connection_map[conn]['database']
    provider = connection_map[conn]['type'].split(' ')[0]
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
                if len(source.split('.')) == 3:
                    true_source = source
                
                else:
                    provider, database = get_conn_db(explore=explore, connection_map=connection_map)
                    if len(source.split('.')) == 2:
                        true_source = f'{provider}.{source}'
                    elif len(source.split('.')) == 1:
                        true_source = f'{provider}.{database}.{source}'

        elif view_payload['view_type'] == 'derived_table':
            true_source = 'derived table'

    else:
        true_source = view_payload

    return view_payload['view_name'], true_source


# def view_source_mapping():
    # 0.11049900000000001 for 100 runs
    # for k,v in d.items():
    #     logging.info(f"Processing View {v['view_name']}...")
    #     view_name, source_table = get_true_source(v, explore=explore, connection_map=connection_map)
    #     print(f'view name: {view_name}, source: {source_table}')

    # 0.710763 for 100 runs
    # k,v = zip(*d.items())
    # args = []
    # for view in v:
    #     args.append((view, explore, connection_map))
    # with Pool(processes=2) as pool:
    #     source = pool.starmap(get_true_source, args)
    #     print(source)

    
def main():
    start = time.process_time()

    dir_path = os.path.dirname(os.path.realpath(__file__))
    logging.basicConfig()
    logging.getLogger().setLevel(logging.INFO)
    
    # connection_map = get_connections.main(domain='https://docker.looker.com:19999', url='/api/3.1/connections')
    connection_map = {  'hub': {'database': 'accounts', 'type': 'PostgreSQL'},
                        'data_warehouse': {'database': 'salesforce', 'type': 'Redshift'},
                        'snowflake_production': {'database': 'PRODUCTION', 'type': 'Snowflake'},
                        'snowflake_medium': {'database': 'SEGMENT', 'type': 'Snowflake'}}

    with open(f'{dir_path}/../maps/explore-salesforce-sf__accounts.json', 'r') as f:
        explore = json.load(f)

    view_content = dict()
    view_map = dict()
    for view in os.listdir(f'{dir_path}/../maps'):
        if view.startswith('view'):
            view_map[view.split('-')[2].split('.')[0]] = view
            with open(f'{dir_path}/../maps/{view}','r') as f:
                payload = json.load(f)
                view_content[payload['view_name']] = payload

    source_payload = dict()
    for view_name,view_payload in view_content.items():
        logging.info(f"Processing View source {view_payload['view_name']}...")
        if view_name in explore['explore_joins']:
            base_view_name, source_table = get_true_source(dir_path, view_payload, explore=explore, connection_map=connection_map, view_map=view_map)
            print(f"view name: {view_name} , base view name: {view_payload['view_name']}, source: {source_table}")
            source_payload[view_name] = dict()
            source_payload[view_name]['view_name'] = view_payload['view_name']
            source_payload[view_name]['base_view_name'] = source_table  

    with open(f"{dir_path}/../maps/explore_{explore['explore_name']}-source.json", 'w') as f:
        json.dump(source_payload, f)

    end = time.process_time()

    logging.info(f'Completed process in {end-start} seconds.')   


if __name__ == "__main__":
    main()
