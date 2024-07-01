def walkFolders(folderPath):
    for (folderPath, folderNames, fileNames) in os.walk(folderPath):
        folderNames.sort()
        for folderName in folderNames:
            yield folderName
        break # Only the top level.
