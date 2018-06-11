#! /usr/bin/python

# Original version from https://www.idiotinside.com/2015/09/18/csv-json-pretty-print-python/

import sys, getopt, csv, json

#Get Command Line Arguments
def csv2json(argv):
	input_file = ''
	output_file = ''
	format = ''
	try:
		opts, args = getopt.getopt(argv,"hi:o:f:",["format="])
	except getopt.GetoptError:
		print 'csv_json.py -i <path to inputfile> -o <path to outputfile> [-f pretty]'
		sys.exit(2)

	for opt, arg in opts:
		if opt == '-h':
			print 'csv_json.py -i <path to inputfile> -o <path to outputfile> [-f pretty]'
			sys.exit()
		elif opt in ("-i", "--ifile"):
			input_file = arg
		elif opt in ("-o", "--ofile"):
			output_file = arg
		elif opt in ("-f", "--format"):
			format = arg

	if input_file == '':
		input_file = sys.stdin
	else:
		input_file = open(input_file,"r")

	if output_file == '':
		output_file = sys.stdout
	else:
		output_file = open(output_file,"w")

	# Read CSV File
	csv_rows = []
	with input_file as csvfile:
		reader = csv.DictReader(csvfile)
		title = reader.fieldnames
		for row in reader:
			csv_rows.extend([{title[i]:row[title[i]] for i in range(len(title))}])

		# Convert csv data into json and write it
		data = csv_rows
		with output_file as f:
			if format == "pretty":
				f.write(json.dumps(data, sort_keys=False, indent=4, separators=(',', ': '),encoding="utf-8",ensure_ascii=False))
			else:
				f.write(json.dumps(data))

if __name__ == "__main__":
	csv2json(sys.argv[1:])


