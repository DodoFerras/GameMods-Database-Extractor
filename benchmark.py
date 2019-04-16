from __future__ import print_function

import os
import sys
import time
from pysort import place_data

"""
Author Github:   https://github.com/g666gle      
Author Twitter:  https://twitter.com/g666gle1
Date:            1/29/2019
Description:     This file is used by run.sh to calculate the amount of time it will take the current hardware to process
                 the user specified amount of lines. This is important because each user has different hardware. Import
                 mainly relies on the type of CPU and how many cores it has. On an Intel i7-7700 processor and 16GB of
                 RAM you can expect results of around 18000 lines per second while your laptop is plugged in and 12000
                 lines per second while your laptop is not plugged in.
                  
Usage:           python3 folderPrimer.py <path to file> <number of lines>
Usage:           python3 folderPrimer.py file.txt 1000000
Version:	     1.5.0
Python Version:  3.7.1
"""

if __name__ == '__main__':
    #  the arguments passed in
    args = sys.argv
    path = os.getcwd()
    written_lines = 0
    # The amount of lines written in 1 Second
    total_lines = 0
    RED = '\033[0;31m'
    GREEN = '\033[0;32m'
    YELLOW = '\033[1;33m'
    NC = '\033[0m'  # No Color
    start_time = time.time()

    #  Check to see if the arguments are correct
    if len(args) == 3 and args[1] != "" and args[2] != "":
        #  Grab the users imputed amount of lines
        amt_lines = args[2]
        #  Directory guaranteed to exist from previous check in Import.sh
        with open(path + "/PutYourDataBasesHere/" + args[1], 'r') as fp:
            try:
                for line in fp:
                    #  go through as many lines as you can in 2 second
                    if (time.time() - start_time) <= 2:
                        written_lines += place_data(line.strip(), path)
                        total_lines += 1
                    else:
                        break
            except Exception as e:
                print(RED + "Exception: " + str(e) + NC)

        #  The seconds is ( ( 2 * ( user imputed lines ) ) / ( amount of lines processed in 2 seconds ) )
        secs = (2 * int(amt_lines)) / int(total_lines)
        mins = secs / 60
        hours = mins / 60
        days = hours / 24
        years = days / 364
        os.system('cls' if os.name == 'nt' else 'clear')
        print(YELLOW + "[!]" + NC + " Your computer can process " + RED + str(total_lines / 2) + NC + " lines per second!")
        print(YELLOW + "[!] For the best results make sure your laptop is pluged into a power source!" + NC)
        print()
        print(GREEN + "[+]" + NC + " To import " + GREEN + amt_lines + NC + " lines")
        print(GREEN + "[+]" + NC + " You can expect an import time of around " + GREEN + "{}".format('%.2f' % secs) + NC + " seconds which is...")
        print("                                            " + GREEN + "{}".format('%.2f' % mins) + NC + " minutes which is...")
        print("                                            " + GREEN + "{}".format('%.2f' % hours) + NC + " hours which is...")
        print("                                            " + GREEN + "{}".format('%.2f' % days) + NC + " days which is...")
        print("                                            " + GREEN + "{}".format('%.2f' % years) + NC + " years")


    else:
        print(YELLOW + "[!]" + NC + " Invalid arguments provided")
