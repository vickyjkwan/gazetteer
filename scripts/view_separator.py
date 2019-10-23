import re
import json
import os
from file_separator import split_up_file, logging


def split_views(dir_path):
    # dir_path = os.path.dirname(os.path.realpath(__file__))
    os.system('rm ../models/.DS_Store ../explores/.DS_Store ../views/.DS_Store')

    logging.basicConfig()
    logging.getLogger().setLevel(logging.INFO)


    # breaks down view file into separate view files based on `view` structures

    for view in set(os.listdir(f'{dir_path}/../views')) - set(next(os.walk(f'{dir_path}/../views'))[1]):
        
        view_folder = view.split('.')[0]
        split_up_file(dir_path, f'../views/{view}', f"{view_folder}", file_type='view')
    