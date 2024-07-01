import csv

def readCsv(filePath):
    with open(filePath) as csvFile:
        csvReader = csv.reader(csvFile, delimiter=',')
        # next(csvReader) # Skip header
        for row in csvReader:
            yield(row)
