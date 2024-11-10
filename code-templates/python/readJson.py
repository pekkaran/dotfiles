import json

def readJson(filePath):
    with open(filePath) as f:
        return json.load(f)

def readJsonl(filePath):
    with open(filePath) as f:
        for l in f: yield(json.loads(l))
