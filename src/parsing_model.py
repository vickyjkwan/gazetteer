import os
import logging
import time
from parser import split_explores, parse_explores, split_views, parse_views


def main():

    start = time.process_time()

    split_explores()
    logging.info("Split up Model files to Explore paylods.")

    parse_explores()
    logging.info("Completed parsing explores and retrieving explore metadata.")

    split_views()
    logging.info("Split up View files to base views.")

    parse_views()
    logging.info("Completed parsing base views and retrieving view metadata.")

    end = time.process_time()
    logging.info(f'Completed process in {end-start} seconds.')    

if __name__ == '__main__':
    main()
