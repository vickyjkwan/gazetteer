import pytest
import re
import json
import os
import logging
from src import graphing_explore, sourcing_explore


@pytest.fixture
def generate_explore():
    model_name = 'sample_model'
    explore_path = '../maps/sample_model/explore-sf__accounts_leads_engagio.json'
    dir_path = os.path.dirname(os.path.realpath(__file__))

    sourcing_explore.get_explore_source(model_name, explore_path, dir_path)


def test_view_source_dependency():

    source_file = 'sample_model/map-model-sample_model-explore-sf__accounts-source.json'
    dir_path = os.path.dirname(os.path.realpath(__file__))
    source = graphing_explore.view_source_dependency(source_file, dir_path)

    assert source == {'sf__cases': {'view_name': 'sfbase__cases', \
                        'base_view_name': 'Redshift.salesforce.cases'}, \
                        'sf__accounts': {'view_name': 'sfbase__accounts', \
                        'base_view_name': 'Redshift.salesforce.accounts'}, \
                        'sf__contacts': {'view_name': 'sfbase__contacts', \
                        'base_view_name': 'Redshift.salesforce.contacts'}, \
                        'sf__users': {'view_name': 'sfbase__users', \
                        'base_view_name': 'Redshift.salesforce.users'}}


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


def test_main(generate_explore):
    
    # generate the sf__accounts_leads_engagio explore
    generate_explore

    dir_path = os.path.dirname(os.path.realpath(__file__))
    graphing_explore.main(dir_path)

    assert 'sf__accounts_leads_engagio.gv' in os.listdir(f'{dir_path}/../graphs')
    assert 'sf__accounts.gv' in os.listdir(f'{dir_path}/../graphs')
