import re
import json
import os
import logging


def split_up_file(file_path, new_file_folder, file_type):
    """
    This function separates one model file into explore files in json format, so that each file contains one and only one explore, with connection name and explore name explicitly specified. 

    :param file_path: the path of the model.lkml

    :type file_path: string

    :param new_file_folder: the path of the newly created folder, that all explore files will be created under

    :type new_file_folder: string

    :return: None. Generates explore json files.
    """
    # read model file into a list
    line_file = [line.rstrip('\n') for line in open(file_path)]

    if file_type == 'explore':
        upper_folder = 'explores'
    elif file_type == 'view':
        upper_folder = 'views'

    # get the line number of each explore or view
    loc_file = []
    for num, line in enumerate(line_file):
        if f'{file_type}:' == line.split(' ')[0]:
            loc_file.append(num)
        elif 'connection:' == line.split(' ')[0]:
            conn = line.split(' ')[1]
    loc_file.append(len(line_file)+1)

    # collect dictionary for each explore, with connection name, explore name explicitly set
    # write to separate json files
    for i in range(len(loc_file)-1):
        file_dict = {}

        if file_type == 'explore':
            file_dict['conn'] = conn.lstrip('"').rstrip('"')
            file_dict[f'{file_type}'] = line_file[loc_file[i]:loc_file[i+1]]
            file_dict[f'{file_type}_name'] = file_dict[f'{file_type}'][0].split(' ')[1].strip('{')
            file_json = json.dumps(file_dict)

            if new_file_folder not in os.listdir(f'../{file_type}s'):
                os.mkdir(f'../{upper_folder}/{new_file_folder}')

            f = open(f"../{upper_folder}/{new_file_folder}/{file_dict[f'{file_type}_name']}.json","w")
            f.write(file_json)
            f.close()
            
        else:

            file_dict[f'{file_type}'] = line_file[loc_file[i]:loc_file[i+1]]
            file_dict[f'{file_type}_name'] = file_dict[f'{file_type}'][0].split(' ')[1].strip('{')
            file_json = json.dumps(file_dict)

            f = open(f"../{upper_folder}/{file_dict[f'{file_type}_name']}.json","w")
            f.write(file_json)
            f.close()
        

def split_explores():

    logging.basicConfig()
    logging.getLogger().setLevel(logging.INFO)

    # breaks down model files into separate explore files

    for model in os.listdir(f'../models'):
        if not model.startswith('.'):
            model_folder = model.split('.')[0]
            split_up_file(f'../models/{model}', f"{model_folder}", file_type='explore')
            logging.info(f'Completed splitting model {model_folder} into explores.')


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


def parsing_explore_lines(explore_list, loc_list):
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
    joins = set()
    for clause in grouped_explore:
        joins.add(trace_base(clause))

    return joins


def parse_explores():
    
    for model_name in os.listdir(f'../explores'):
        if not model_name.startswith('.'):

            if f'{model_name}' not in os.listdir(f'../maps'):
                os.mkdir(f"../maps/{model_name}")
            
            for explore in os.listdir(f'../explores/{model_name}'):
                # read json file
                with open(f'../explores/{model_name}/{explore}', 'r') as f:
                    model = json.load(f)

                explore_name = list(filter(None, model['explore'][0].split(' ')))[1]
                explore_list = model['explore']
                logging.info(f'Starting to parse Explore {explore_name}...')
            
                # find the divider of explore level and join level clauses
                loc_list = divider(explore_list)

                if len(loc_list) > 1:
                    # parse the raw list, generate a nested and well grouped list representing the explore and join structure
                    grouped_explore = parsing_explore_lines(explore_list, loc_list)
                    # generate a list of all joined base view names
                    explore_joins = trace_joins(grouped_explore)
                else: 
                    explore_joins = trace_joins([explore_list])

                explore_dict = dict()
                explore_dict['explore_name'] = explore_name
                explore_dict['explore_joins'] = list(explore_joins)
                explore_dict['conn'] = model['conn']

                explore_json = json.dumps(explore_dict)
            
                f = open(f"../maps/{model_name}/explore-{explore_name}.json","w")
                f.write(explore_json)
                f.close()


def split_views():

    logging.basicConfig()
    logging.getLogger().setLevel(logging.INFO)

    # breaks down view file into separate view files based on `view` structures
    for view_folder in next(os.walk(f'../views'))[1]:
        if not view_folder.startswith('.'):
            logging.info(f'Splitting views under folder {view_folder}...')

            for view in next(os.walk(f'../views/{view_folder}'))[2]:
                if not view.startswith('.'):
                    split_up_file(f'../views/{view_folder}/{view}', f"", file_type='view')


def get_derived_table(view_list):
    """
    This function extracts the derived table clause from a view file, if it exists.

    :param view_list: view file broken down list

    :type view_list: list

    :return: a list of the derived table clause for a view file
    """
    derived_list = []
    for line in view_list:

        line_list = list(filter(None, line.split(' ')))
        derived_list.append(line_list)
        end_of_derived_table = sum([bool(re.search('dimension', s) or re.search('parameter', s) or re.search('measure', s)) for s in line_list])

        if end_of_derived_table > 0:
            break
            
    return derived_list[1:-1]
        

def source_table(view_path):
    """
    This function extracts the source view/table from the `sql_table_name` parameter, or from the `extends` parameter.

    :param view_path: the path of the view file

    :type view_path: string
    
    :return: json payload of view name and the source table.
    """

    with open(view_path, 'r') as f:    
        view = json.load(f)

    view_source = {'view_name': view['view_name']}
    line_dict = {}
    
    for line in view['view']:
        line_list = list(filter(None, line.split(' ')))
        if len(line_list) > 0 and (bool(re.search('extends', line_list[0])) \
                                   or bool(re.search('sql_table_name', line_list[0]))):
            line_dict[line_list[0]] = line_list[1]
        elif len(line_list) > 0 and bool(re.search('derived_table', line_list[0])):
            view_source['view_type'] = 'derived_table'

    override_key_list = [bool(re.search('sql_table_name', x)) for x in line_dict.keys()]

    if len(override_key_list) >= 1 and sum(override_key_list) >= 1:
        view_source['source_table'] = line_dict['sql_table_name:']
        view_source['view_type'] = 'sql_table_name'
    elif len(override_key_list) == 1 and sum(override_key_list) == 0:
        view_source['source_table'] = line_dict['extends:'][1:-1]
        view_source['view_type'] = 'extension'

    if view_source['view_type'] == 'derived_table':
        derived_list = get_derived_table(view['view'])
        view_source['derived_table'] = derived_list
    
    return view_source


def has_child_folder(path):

    if next(os.walk(path))[1] == []:
        return False
    else:
        return True


def clean_defolderize(path):

    for thing in next(os.walk(path))[1]:
        if not has_child_folder(f'{path}/{thing}'):
            for file in os.listdir(f'{path}/{thing}'):
                if not file.startswith('.'):
                    os.system(f'cp {path}/{thing}/{file} {path}/{thing}-{file}')
        else:
            new_path = f'{path}/{thing}'
            clean_defolderize(new_path)
    

def parse_views():

    for view in next(os.walk(f'../views'))[2]:  
        if not view.startswith('.'):
            logging.info(f'Starting to parse view {view}...')
    
            view_path = f'../views/{view}'
            result = source_table(view_path)
            result_json = json.dumps(result)

            f = open(f'../maps/view-{view}', "w")
            f.write(result_json)
            f.close()

          