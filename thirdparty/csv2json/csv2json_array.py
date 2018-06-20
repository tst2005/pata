#! /usr/bin/python

import csv, sys, json
def csv2json_array():
	#with sys.stdin as csvfile:
	reader = csv.reader(sys.stdin)
	for row in reader:
#		sys.stdout.write(json.dumps(row))
#		sys.stdout.write(json.dumps(row, indent=4, separators=(',', ': '),encoding="utf-8",ensure_ascii=False))
#		sys.stdout.write(json.dumps(row, sort_keys=False, indent=0, separators=(',', ':'), encoding="utf-8", ensure_ascii=False))
#		sys.stdout.write(json.dumps(row, skipkeys=False, ensure_ascii=False, check_circular=False, allow_nan=True, cls=None, indent=0, separators=(',', ':'), encoding="utf-8", default=None, sort_keys=False))
#		sys.stdout.write(json.dumps(row, skipkeys=False, ensure_ascii=False, check_circular=False, allow_nan=True, cls=None, indent=None, separators=(',', ':'), encoding="utf-8", default=None, sort_keys=False))
		sys.stdout.write(json.dumps(
				row,
				skipkeys=True,
				ensure_ascii=False,
				check_circular=False,
				allow_nan=True,
				cls=None,
				indent=None,
				separators=(',', ':'),
				encoding="utf-8",
				default=None,
				sort_keys=False
			)
		)
	sys.stdout.write("\n")

csv2json_array()
