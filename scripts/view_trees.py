import re
import json
import os
import logging


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
        

def sourcing_table(view_path):
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


def parse_views(dir_path):
    # dir_path = os.path.dirname(os.path.abspath(__file__))
    os.system(f'rm {dir_path}/.DS_Store {dir_path}/../views/.DS_Store' )

    for view_folder in next(os.walk(f'{dir_path}/../views'))[1]:    
        logging.info(f'Processing view file {view_folder}') 
 
        for view in os.listdir(f'{dir_path}/../views/{view_folder}'):

            logging.info(f'Starting to parse View {view}...')
            view_path = f'{dir_path}/../views/{view_folder}/' + view
            result = sourcing_table(view_path)
            result_json = json.dumps(result)

            f = open(f'{dir_path}/../maps/view-{view_folder}-{view}', "w")
            f.write(result_json)
            f.close()
