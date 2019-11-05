import pytest
import re
import json
import os
import logging
from src import sourcing_explore


def test_get_connections():
    looker_connections = sourcing_explore.get_connections(domain='https://docker.looker.com:19999', url='/api/3.1/connections', dir_path='../')

    assert 'snowflake_segment' in looker_connections.keys()


def test_get_true_source(get_looker_conn, get_view_payload, get_view_map):

    view_content = get_view_payload
    view_payload = view_content['sf__accounts']
    explore = {"conn": "data_warehouse", \
                "explore": ["explore: sf__accounts {", "  persist_for: \"24 hours\"", "  label: \"Accounts\"", "  view_label: \"Accounts\"", "  sql_always_where: NOT ${sf__accounts.is_deleted} ;;", "", "  join: owner {", "    from: sf__users", "    sql_on: ${sf__accounts.owner_id} = ${owner.id} ;;", "    relationship: many_to_one", "  }", "", "  join: sf__contacts {", "    view_label: \"Contacts\"", "    sql_on: ${sf__accounts.id} = ${sf__contacts.account_id} ;;", "    relationship: one_to_many", "  }", "", "  join: sf__cases {", "    view_label: \"Cases\"", "    sql_on: ${sf__accounts.id} = ${sf__cases.account_id} ;;", "    relationship: one_to_many", "  }", "", "  join: tam {", "    view_label: \"TAM\"", "    from: sf__users", "    sql_on: ${sf__accounts.tam} = ${tam.id} ;;", "    relationship: many_to_one", "  }", "}", "", "#", "# Explore joins SFDC account and lead objects on an engagio determined custom field", "#"], \
                "explore_name": "sf__accounts"}
    connection_map = get_looker_conn
    view_map = get_view_map

    source_payload = sourcing_explore.get_true_source(view_payload, explore, connection_map, view_map)

    assert source_payload == ('sfbase__accounts', 'Redshift.production.salesforce.accounts')


def test_look_up_target_view(get_view_payload, get_view_map):
    
    for _, v in get_view_payload.items():
        view_payload = v

    target_view_payload = sourcing_explore.look_up_target_view(source_view_name=view_payload['source_table'], view_map=get_view_map)

    assert target_view_payload == 'view-sfbase__accounts.json'
    

def test_is_true_source():
    view_content = dict()
    with open('../maps/view-snowflake_sf__accounts.json','r') as f:
        payload = json.load(f)
        view_content[payload['view_name']] = payload
    
    view_payload = view_content['snowflake_sf__accounts']
    source = view_payload['source_table']
    
    assert sourcing_explore.is_true_source(source) == True


def test_get_conn_db(get_looker_conn):
    explore = {'conn': 'data_warehouse', \
            'explore': ['explore: sf__accounts {', \
            '  persist_for: "24 hours"', \
            '  label: "Accounts"', \
            '  view_label: "Accounts"', \
            '  sql_always_where: NOT ${sf__accounts.is_deleted} ;;', \
            '', \
            '#'], \
            'explore_name': 'sf__accounts'}
    
    connection_map = get_looker_conn

    assert sourcing_explore.get_conn_db(explore=explore, connection_map=connection_map) == ('Redshift', 'production')


def test_get_view_source():

    view_map, _ = sourcing_explore.get_view_source() 

    assert view_map == {'sf__leads': 'view-sf__leads.json', \
                        'sf__cases': 'view-sf__cases.json', \
                        'sfbase__users': 'view-sfbase__users.json', \
                        'total_active_node_count': 'view-total_active_node_count.json', \
                        'sf__accounts': 'view-sf__accounts.json', \
                        'snowflake_sf__accounts': 'view-snowflake_sf__accounts.json', \
                        'sfbase__cases': 'view-sfbase__cases.json', \
                        'sf__contacts': 'view-sf__contacts.json', \
                        'sfbase__leads': 'view-sfbase__leads.json', \
                        'sfbase__contacts': 'view-sfbase__contacts.json', \
                        'sfbase__accounts': 'view-sfbase__accounts.json', \
                        'sf__users': 'view-sf__users.json'}


def test_get_explore_source(get_looker_conn, get_view_content, get_view_map):
    model_name = 'sample_model'
    explore_path = '../maps/sample_model/explore-sf__accounts.json'

    connection_map=get_looker_conn

    sourcing_explore.get_explore_source(model_name, explore_path, view_content=get_view_content, view_map=get_view_map, connection_map=connection_map)
    
    with open(f"../maps/{model_name}/map-model-{model_name}-explore-sf__accounts-source.json", 'r') as f:
        source_payload = json.load(f)

    assert source_payload == {'sf__cases': {'view_name': 'sfbase__cases',
                                'base_view_name': 'Redshift.production.salesforce.cases'},
                                'sf__accounts': {'view_name': 'sfbase__accounts',
                                'base_view_name': 'Redshift.production.salesforce.accounts'},
                                'sf__contacts': {'view_name': 'sfbase__contacts',
                                'base_view_name': 'Redshift.production.salesforce.contacts'},
                                'sf__users': {'view_name': 'sfbase__users',
                                'base_view_name': 'Redshift.production.salesforce.users'}}
