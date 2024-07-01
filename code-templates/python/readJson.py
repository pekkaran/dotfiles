import json

def readJson(filePath):
    with open(filePath) as f:
        return json.load(f)
