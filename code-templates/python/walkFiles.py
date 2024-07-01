def walkFiles(folderPath):
    for (folderPath, folderNames, fileNames) in os.walk(folderPath):
        fileNames.sort()
        for fileName in fileNames:
            yield fileName
        break # Only the top level.
