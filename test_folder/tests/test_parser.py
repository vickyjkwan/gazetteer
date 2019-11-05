import re
import json
import os
import logging
import pytest
from src import parser


@pytest.fixture
def get_explore():

    with open('../explores/sample_model/sf__accounts_leads_engagio.json', 'r') as f:
        explore = json.load(f)

    explore_list = explore['explore']

    # find the divider of explore level and join level clauses
    loc_list = parser.divider(explore_list)

    return explore_list, loc_list

def test_split_up_file():

    explore_path = '../models/sample_model.model.lkml'
    new_explore_folder = 'sample_model'
    explore_type = 'explore'

    parser.split_up_file(explore_path, new_explore_folder, explore_type)

    with open('../explores/sample_model/sf__accounts.json', 'r') as f:
        explore_json = json.load(f) 
    
    view_path = '../views/salesforce/sf__leads.view.lkml'
    new_view_folder = ""
    view_type = 'view'
    parser.split_up_file(view_path, new_view_folder, view_type)

    with open('../views/sf__leads.json', 'r') as f:
        view_json = json.load(f)

    assert len(explore_json) > 0 
    assert len(view_json) > 0


# should I???
# def test_split_explores():

#     parser.split_explores()
#     assert True
    

def test_divider(get_explore):

    _, loc_list = get_explore

    assert loc_list == [14]


def test_parsing_explore_lines(get_explore):

    explore_list, loc_list = get_explore
    parsed_explore = parser.parsing_explore_lines(explore_list, loc_list)

    assert len(explore_list) == sum([len(e) for e in parsed_explore])


def test_trace_joins(get_explore):

    explore_list, loc_list = get_explore
    parsed_explore = parser.parsing_explore_lines(explore_list, loc_list)

    base_views = parser.trace_joins(parsed_explore)

    assert base_views == {'sf__accounts', 'sf__leads'}


def test_trace_base(get_explore):
    statement = ['  join: sf__leads {', \
        '    view_label: "Leads"', \
        '    sql_on: ${sf__accounts_leads_engagio.id} = ${sf__leads.engagio_matched_account} ;;', \
        '    # One account will have many leads,', \
        "    # and a lead (from engagio's perspective) belongs to a single account", \
        '    relationship: one_to_many', \
        '  }', \
        '}']

    assert parser.trace_base(statement) == 'sf__leads'


def test_parse_explores():

    parser.parse_explores()

    with open('../maps/sample_model/explore-sf__accounts_leads_engagio.json', 'r') as f:
        payload = json.load(f)

    assert set(payload.keys()) == {'explore_name', 'explore_joins', 'conn'}


def test_split_views():
    
    parser.split_views()

    with open('../views/sf__leads.json', 'r') as f:
        view_json = json.load(f)

    assert isinstance(view_json, dict) == True
    

# this is NDT and derived tables
# def test_get_derived_table():
#     assert False


def test_source_table():

    view_path = '../views/total_active_node_count.json'
    payload = parser.source_table(view_path)
    assert len(set(payload.keys())) == 3
    assert 'view_name' in set(payload.keys()) 
    assert 'view_type' in set(payload.keys())


def test_parse_views():

    parser.parse_views()

    with open('../maps/view-sf__accounts.json', 'r') as f:
        payload = json.load(f)

    assert isinstance(payload, dict) == True
    assert set(payload.keys()) == {'view_name', 'view_type', 'source_table'}

    
def test_has_child_folder():

    assert parser.has_child_folder(f'../views/salesforce2') == True
 

