import pytest
import re
import json
import os
import logging
from scripts import graphing_explore

# errrrrrgh this function isn't being called anywhere
# def test_explore_view_dependency():

#     with open(f'../maps/sample_model/explore-sf__accounts.json', 'r') as f:
#         map_explore = json.load(f)
    
#     dir_path = os.path.dirname(os.path.realpath(__file__))
#     join_list = map_explore['explore_joins']
#     source = graphing_explore.explore_view_dependency(join_list, dir_path)
    
#     assert source == {'sf__contacts': ['sfbase__contacts'], \
#                         'sf__cases': ['sfbase__cases'], \
#                         'sf__users': ['sfbase__users'], \
#                         'sf__accounts': ['sfbase__accounts']}


def test_view_source_dependency():

    source_file = 'sample_model/map-model-sample_model-explore-sf__accounts-source.json'
    dir_path = os.path.dirname(os.path.realpath(__file__))
    source = graphing_explore.view_source_dependency(source_file, dir_path)

    assert source == {'sf__accounts': {'view_name': 'sfbase__accounts', 'base_view_name': 'Redshift.salesforce.accounts'}}


def test_gen_graph():

    dir_path = os.path.dirname(os.path.realpath(__file__))
    with open(f'{dir_path}/../maps/sample_model/explore-sf__accounts.json', 'r') as f:
        map_explore = json.load(f)
    explore_name=map_explore['explore_name']
    join_list=map_explore['explore_joins']

    model_folder = 'sample_model'
    map_path = 'explore-sf__accounts.json'.split('.')[0]

    with open(f'{dir_path}/../maps/{model_folder}/map-model-{model_folder}-{map_path}-source.json', 'r') as f:
        view_source = json.load(f)

    graphing_explore.gen_graph(explore_name, join_list, view_source, dir_path)

    assert f'{explore_name}.gv' in os.listdir(f'{dir_path}/../graphs')