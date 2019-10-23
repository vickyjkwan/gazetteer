import os
import logging
import time
import explore_trees
import file_separator
import view_separator
import view_trees

def main():

    dir_path = os.path.dirname(os.path.realpath(__file__))

    start = time.process_time()

    file_separator.split_explores(dir_path)
    logging.info("Split up Model files to Explore paylods.")

    explore_trees.parse_explores(dir_path)
    logging.info("Completed parsing explores and retrieving explore metadata.")

    view_separator.split_views(dir_path)
    logging.info("Split up View files to base views.")

    view_trees.parse_views(dir_path)
    logging.info("Completed parsing base views and retrieving view metadata.")

    end = time.process_time()
    logging.info(f'Completed process in {end-start} seconds.')    

if __name__ == '__main__':
    main()
