import re
import json
import os
import logging


def split_up_file(dir_path, file_path, new_file_folder, file_type):
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
        else:
            pass

        file_dict[f'{file_type}'] = line_file[loc_file[i]:loc_file[i+1]]
        file_dict[f'{file_type}_name'] = file_dict[f'{file_type}'][0].split(' ')[1].strip('{')
        file_json = json.dumps(file_dict)
        
        if new_file_folder not in os.listdir(f'{dir_path}/../{file_type}s'):
            os.mkdir(f'{dir_path}/../{upper_folder}/{new_file_folder}')

        f = open(f"{dir_path}/../{upper_folder}/{new_file_folder}/{file_dict[f'{file_type}_name']}.json","w")
        f.write(file_json)
        f.close()


def split_explores(dir_path):

    os.system('rm models/.DS_Store explores/.DS_Store')
    # dir_path = os.path.dirname(os.path.realpath(__file__))

    logging.basicConfig()
    logging.getLogger().setLevel(logging.INFO)

    # breaks down model files into separate explore files

    for model in os.listdir(f'{dir_path}/../models'):
        model_folder = model.split('.')[0]
        split_up_file(dir_path, f'../models/{model}', f"{model_folder}", file_type='explore')
        logging.info(f'Completed splitting model {model_folder} into explores.')
