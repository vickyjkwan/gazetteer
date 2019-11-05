import pytest
import re
import json
import os
import logging
from src import sourcing_explore


@pytest.fixture
def get_looker_conn(scope='session', autouse=True):
    looker_connections = sourcing_explore.get_connections(domain='https://docker.looker.com:19999', url='/api/3.1/connections')
    return looker_connections


@pytest.fixture
def get_view_payload(scope='session', autouse=True):

    view_content = dict()
    view_map = dict()
    view = '../maps/view-sf__accounts.json'
    view_map[view.split('-')[1].split('.')[0]] = view

    with open(view,'r') as f:
        payload = json.load(f)
        view_content[payload['view_name']] = payload
    
    return view_content


@pytest.fixture
def get_view_map(scope='session', autouse=True):

    view_map = dict()
    for view in next(os.walk('../maps'))[2]:
        if view.startswith('view'):
            view_map[view.split('-')[1].split('.')[0]] = view
           
    return view_map


@pytest.fixture
def get_view_content(get_view_map, scope='session', autouse=True):

    view_content = dict()
    view_map = get_view_map
    for view in next(os.walk(f'../maps'))[2]:
        if view.startswith('view'):
            logging.info(f'Getting source tables for view {view}...')
            view_map[view.split('-')[1].split('.')[0]] = view
            with open(f'../maps/{view}','r') as f:
                payload = json.load(f)
                view_content[payload['view_name']] = payload
    
    return view_content
