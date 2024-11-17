import os
import pathlib

def walkFiles(path: pathlib.Path):
    if not path.exists():
        raise Exception(f"No such path `{str(path)}`.")
    if path.is_file():
        yield path.name
    for (folderPath, folderNames, fileNames) in os.walk(path):
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
