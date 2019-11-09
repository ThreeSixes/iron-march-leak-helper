#!/usr/bin/env python
"""
A simple utility to convert Unix time stamps used in the database to human-readable timestapms.
"""

import argparse
from datetime import datetime

def convert(unix_ts):
    """
    Do the conversion to a date object.
    """

    return datetime.utcfromtimestamp(unix_ts).strftime('%Y-%m-%d %H:%M:%S UTC')

# Grab the timestamp from the command line.
parser = argparse.ArgumentParser(description='Convert a Unix timestamp to a human-readable UTC date.')
parser.add_argument('unix_ts', type=int, help='Unix timestamp')
args = parser.parse_args()

print(convert(args.unix_ts))
