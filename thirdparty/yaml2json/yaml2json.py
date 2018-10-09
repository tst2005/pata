#!/usr/bin/env python2

import yaml, sys, json

#from yaml import load, dump
#try:
#    from yaml import CLoader as Loader, CDumper as Dumper
#except ImportError:
#    from yaml import Loader, Dumper

def yaml2json_array():
        data = yaml.load(sys.stdin)
	sys.stdout.write(json.dumps(
		data,
	#	skipkeys=True,
		ensure_ascii=False,
		check_circular=False,
	#	allow_nan=True,
		cls=None,
		indent=None,
		separators=(',', ':'),
		encoding="utf-8",
		default=None,
		sort_keys=False
	))
        sys.stdout.write("\n")

def all_yaml2json_array():
	for data in yaml.load_all(sys.stdin):
		sys.stdout.write(json.dumps(
			data,
		#	skipkeys=True,
			ensure_ascii=False,
			check_circular=False,
		#	allow_nan=True,
			cls=None,
			indent=None,
			separators=(',', ':'),
			encoding="utf-8",
			default=None,
			sort_keys=False
		))
        sys.stdout.write("\n")

all_yaml2json_array()

