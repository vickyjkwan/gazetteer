import os
import logging
import time
from parser import split_explores, parse_explores, split_views, parse_views


def main():

    dir_path = os.path.dirname(os.path.realpath(__file__))

    start = time.process_time()

    split_explores(dir_path)
    logging.info("Split up Model files to Explore paylods.")

    parse_explores(dir_path)
    logging.info("Completed parsing explores and retrieving explore metadata.")

    split_views(dir_path)
    logging.info("Split up View files to base views.")

    parse_views(dir_path)
    logging.info("Completed parsing base views and retrieving view metadata.")

    end = time.process_time()
    logging.info(f'Completed process in {end-start} seconds.')    

if __name__ == '__main__':
    main()
