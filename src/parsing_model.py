import os
import logging
import time
from parser import split_explores, parse_explores, split_views, parse_views, clean_defolderize, has_child_folder


def main():

    start = time.process_time()

    split_explores()
    logging.info("Split up Model files to Explore paylods.")

    parse_explores()
    logging.info("Completed parsing explores and retrieving explore metadata.")

    for sub_folder in next(os.walk('../views'))[1]:
        if has_child_folder(f'../views/{sub_folder}'):
            logging.info(f"Extracting views from sub folder {sub_folder}...")
            clean_defolderize(f'../views/{sub_folder}')

    split_views()
    logging.info("Split up View files to base views.")

    parse_views()
    logging.info("Completed parsing base views and retrieving view metadata.")

    end = time.process_time()
    logging.info(f'Completed process in {end-start} seconds.')    

if __name__ == '__main__':
    main()
