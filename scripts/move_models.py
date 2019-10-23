import os
import re

for file_name in os.listdir('.'):
    if file_name.endswith('.model.lkml'):
        os.system(f'cp {file_name} ../playground/models/{file_name}')
    elif file_name.endswith('.view.lkml'):
        os.system(f'cp {file_name} ../playgroun/views/{file_name}')
        