import re
import csv
import sys

quarters = {
    "T1": "-03-31",
    "T2": "-06-30",
    "T3": "-09-30",
    "T4": "-12-31",
}

segments = ['PHD', 'FI', 'IF', 'CT']

data = {}

files = sys.argv[1:]
filePattern = re.compile(".*(20\d\d)_(T\d)_ZAPM")

for file in files:
    match = filePattern.match(file)
    if not match:
        raise Exception("Invalid file name")

    groups = match.groups()
    key = groups[0] + quarters[groups[1]]
    data[key] = [["0", "0", "0"]] * len(segments)

    with open(file, 'r') as csvfile:
        reader = csv.reader(csvfile)
        reader.next()
        for row in reader:
            subkey = segments.index(row[0])
            data[key][subkey] = row[1:]

for line in sorted(data):
    print(line + "\t" + ("\t".join([group for group in ["\t".join(item) for item in data[line]]])))
