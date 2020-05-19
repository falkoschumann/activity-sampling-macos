#!/usr/local/bin/python3

# Columns: timestamp,period,tags,activity

import csv
import re

with open('activity-log.csv', newline='', encoding='utf-8') as infile:
    with open('activity-log.converted.csv', 'w', newline='', encoding='utf-8') as outfile:
        writer = csv.DictWriter(outfile,
                                ['timestamp', 'period', 'tags', 'activity'])
        writer.writeheader()

        activity_regex = re.compile(r'\[(.+)\](.+)')
        reader = csv.DictReader(infile)
        for row in reader:
            mo = activity_regex.search(row['activity'])
            tags = mo.group(1)
            if not tags is None:
                tags = tags.strip()
            activity = mo.group(2)
            activity = activity.strip()
            writer.writerow({
                'timestamp': row['timestamp'],
                'period': row['period'],
                'tags': tags,
                'activity': activity
            })
