from graphviz import Digraph
import json
import os
import get_connections
import logging

def gen_graph(explore, explore_name, join_list, view_source_payload, dir_path):
    dot = Digraph(f'{explore_name}')
    dot.node(explore_name, explore_name)

    view_list = join_list

    for view in view_list:
    
        join_node = f'view_{view}'
        dot.node(join_node, join_node)
        dot.edge(explore_name, join_node)

        with open(f'{dir_path}/../maps/view-{view}-{view}.json', 'r') as f:
            payload = json.load(f)
            if payload['view_type'] != 'extension':
                base_node = payload['source_table']
            else:
                base_node = view_source_payload[payload['view_name']]['base_view_name']
            
            dot.node(base_node, base_node)
            dot.edge(join_node, base_node)
            
    dot.render(f'{dir_path}/../graphs/{explore_name}.gv', view=True)
    return logging.info(f'Successfully generated dependency graph for Explore {explore_name}.')


def explore_view_dependency(join_list, dir_path):
    
    explore = dict()
    for join in join_list:
        explore_view_list = []
        for file in os.listdir(f'{dir_path}/../maps'):
                if file.startswith('view') and file.split('-')[1] == join:
                    with open(f'{dir_path}/../maps/{file}') as f:
                        view_dict = json.load(f)

                    explore_view_list.append(view_dict['view_name'])

        explore[join] = explore_view_list

    return explore


def view_source_dependency(source_file, dir_path):
    with open(f'{dir_path}/../maps/{source_file}', 'r') as f:
        view_source = json.load(f)
    
    return view_source

def main(dir_path):

    with open(f'{dir_path}/../maps/explore-salesforce-sf__accounts.json', 'r') as f:
        map_accounts_explore = json.load(f)

    explore = explore_view_dependency(join_list = map_accounts_explore['explore_joins'], dir_path=dir_path)

    view_source = view_source_dependency('explore_sf__accounts-source.json', dir_path=dir_path)

    gen_graph(explore=explore, explore_name='sf__accounts', join_list=map_accounts_explore['explore_joins'], \
                view_source_payload=view_source, dir_path=dir_path)


if __name__ == '__main__':
    dir_path = os.path.dirname(os.path.realpath(__file__))

    main(dir_path)
