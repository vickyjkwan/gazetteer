import pytest
import re
import json
import os
import logging
from scripts import sourcing_explore


@pytest.fixture
def get_looker_conn():
    connection_map = sourcing_explore.get_connections(domain='https://docker.looker.com:19999', url='/api/3.1/connections')
    return connection_map


@pytest.fixture
def get_view_payload():

    view_content = dict()
    view_map = dict()
    view = '../maps/view-sf__accounts.json'
    view_map[view.split('-')[1].split('.')[0]] = view

    with open(view,'r') as f:
        payload = json.load(f)
        view_content[payload['view_name']] = payload
    
    return view_content


def test_get_connections():
    looker_connections = sourcing_explore.get_connections(domain='https://docker.looker.com:19999', url='/api/3.1/connections')

    assert 'snowflake_segment' in looker_connections.keys()


# def test_get_true_source(get_looker_conn, get_view_payload):

#     view_content = get_view_payload

#     dir_path = os.path.dirname(os.path.realpath(__file__))

#     view_payload = view_content['sf__accounts']

#     explore = {"conn": "data_warehouse", \
#                 "explore": ["explore: sf__accounts {", "  persist_for: \"24 hours\"", "  label: \"Accounts\"", "  view_label: \"Accounts\"", "  sql_always_where: NOT ${sf__accounts.is_deleted} ;;", "", "  join: owner {", "    from: sf__users", "    sql_on: ${sf__accounts.owner_id} = ${owner.id} ;;", "    relationship: many_to_one", "  }", "", "  join: sf__contacts {", "    view_label: \"Contacts\"", "    sql_on: ${sf__accounts.id} = ${sf__contacts.account_id} ;;", "    relationship: one_to_many", "  }", "", "  join: sf__cases {", "    view_label: \"Cases\"", "    sql_on: ${sf__accounts.id} = ${sf__cases.account_id} ;;", "    relationship: one_to_many", "  }", "", "  join: tam {", "    view_label: \"TAM\"", "    from: sf__users", "    sql_on: ${sf__accounts.tam} = ${tam.id} ;;", "    relationship: many_to_one", "  }", "}", "", "#", "# Explore joins SFDC account and lead objects on an engagio determined custom field", "#"], \
#                 "explore_name": "sf__accounts"}

#     connection_map = get_looker_conn
    
#     view_map = {'sf__accounts': '../maps/view-sf__accounts.json'}

#     sourcing_explore.get_true_source(dir_path, view_payload, explore, connection_map, view_map)

#     print(sourcing_explore)
#     assert True
