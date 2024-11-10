import os

def walkFiles(folderPath):
    for (folderPath, folderNames, fileNames) in os.walk(folderPath):
        fileNames.sort()
        for fileName in fileNames:
            yield fileName
        break # Only the top level.

def walkFolders(folderPath):
    for (folderPath, folderNames, fileNames) in os.walk(folderPath):
        folderNames.sort()
        for folderName in folderNames:
            yield folderName
        break # Only the top level.
