import re
import os
import json
import logging


def divider(explore_list):
    """
    This function returns a list of location number that points to the joins in the explore list.

    :param explore_list: the list of explore, each element is a line from the explore, with possible joins.

    :type explore_list: list

    :return: a list of integers
    """
    num0 = 0
    counter = num0+1
    counter_list = []
    while counter < len(explore_list): 
        num0 = counter
        counter = num0 + 1
        num1 = next((num for num, line in enumerate(explore_list[counter:]) if bool(re.search('join:', line))), len(explore_list))

        if num1 != len(explore_list):
            counter += num1
            counter_list.append(counter)
        else:
            counter = len(explore_list)

    return counter_list


def parser(explore_list, loc_list):
    """
    This function parses a list of explore lines into a grouped structure of explore lines.

    :param explore_list: the list representing raw explore file.

    :type explore_list: list

    :param loc_list: the list of dividers, each divider is the number of join in the explore list

    :type loc_list: list

    :return: a grouped and nested list representing the explore structure with joins.
    """
    grouped_explore = []
    grouped_explore.append(explore_list[:loc_list[0]])
    for r in range(len(loc_list)-1):
        grouped_explore.append(explore_list[loc_list[r]: loc_list[r+1]])
    grouped_explore.append(explore_list[loc_list[-1]:])
    return grouped_explore


def trace_base(clause):
    """
    This function traces down a join or explore clause back to the base view name.

    :param clause: a list of one Lookml clause, that is either an explore level or join level.

    :type clause: list

    :return: the base view name. string type
    """
    if len(clause) > 1:
        for line in clause[1:]:
            base = list(filter(None, clause[0].split(' ')))[1]
            if bool(re.search('from:', line)):
                base = list(filter(None, line.split(' ')))[1]
                break
    else:
        base = list(filter(None, clause[0].split(' ')))[1]
    return base    


def trace_joins(grouped_explore):
    """
    This function generates a dictionary of the explore tree.

    :param grouped_explore: a list representing one explore, with each element being either the explore base view details, or the joined view details.

    :type grouped_explore: list

    :return: a list representing all the joined base view names.
    """
    joins = []
    for clause in grouped_explore:
        joins.append(trace_base(clause))

    return joins


def parse_explores(dir_path):
    
    # dir_path = os.path.dirname(os.path.realpath(__file__))

    os.system(f'rm {dir_path}/.DS_Store {dir_path}/../explores/.DS_Store')
    
    for model_name in os.listdir(f'{dir_path}/../explores'):
        
        for explore in os.listdir(f'{dir_path}/../explores/{model_name}'):
            # read json file
            with open(f'{dir_path}/../explores/{model_name}/{explore}', 'r') as f:
                model = json.load(f)

            explore_name = list(filter(None, model['explore'][0].split(' ')))[1]
            explore_list = model['explore']
            logging.info(f'Starting to parse Explore {explore_name}...')
        
            # find the divider of explore level and join level clauses
            loc_list = divider(explore_list)

            if len(loc_list) > 1:
                # parse the raw list, generate a nested and well grouped list representing the explore and join structure
                grouped_explore = parser(explore_list, loc_list)
                # generate a list of all joined base view names
                explore_joins = trace_joins(grouped_explore)
            else: 
                explore_joins = trace_joins([explore_list])

            explore_dict = dict()
            explore_dict['explore_name'] = explore_name
            explore_dict['explore_joins'] = explore_joins
            explore_dict['conn'] = model['conn']

            explore_json = json.dumps(explore_dict)
        
            f = open(f"{dir_path}/../maps/explore-{model_name}-{explore_name}.json","w")
            f.write(explore_json)
            f.close()
