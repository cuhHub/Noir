# // ---------------------------------------------------------------------
# // ------- [cuhHub] Tools - Sync
# // ---------------------------------------------------------------------

# -----------------------------------------
# // ---- Imports
# -----------------------------------------
import os
import argparse

# -----------------------------------------
# // ---- Variables
# -----------------------------------------
# sync variables
syncFolder = "."
destinations = []

# argument parser
parser = argparse.ArgumentParser(
    description = "Syncs files from one folder to multiple folders.",
)

# -----------------------------------------
# // ---- Functions
# -----------------------------------------
# // Read a file
def quickRead(path: str, mode: str = "r"):
    with open(path, mode) as f:
        return f.read()
    
# // Write to a file
def quickWrite(path: str, content: str, mode: str = "w"):
    directory = os.path.dirname(path)
    
    if not os.path.exists(directory):
        os.makedirs(directory, exist_ok = True)
    
    with open(path, mode) as f:
        return f.write(content)
    
# // Check if a path is in list
def pathInList(path: str, paths: list):
    for currentPath in paths:
        if os.path.samefile(path, currentPath):
            return True
        
    return False

# // Format a list into a string bullet list
def listToBulletList(targetList: list[str], symbol: str = "-"):
    return f"{symbol} " + f"\n{symbol} ".join(targetList)

# // Copy files from one place to another
def copyFiles(src: str, destination: str, exceptions: list[str]):
    # get all files in src directory    
    srcFiles = os.listdir(src)
    
    # iterate through them
    for srcFile in srcFiles:
        # get required paths n stuff
        pathToSrcFile = os.path.join(src, srcFile)
        pathToDestinationFile = os.path.join(destination, srcFile)
        _, extension = os.path.splitext(srcFile)
        
        # check if in exception
        if pathInList(pathToSrcFile, exceptions):
            continue
        
        # copy file to destination
        if extension == "":
            # folder
            os.makedirs(pathToDestinationFile, exist_ok = True)
            copyFiles(pathToSrcFile, pathToDestinationFile, exceptions)
        else:
            # create folder in destination if it doesnt exist
            os.makedirs(os.path.dirname(pathToDestinationFile), exist_ok = True)
            
            # file, so get content
            content = quickRead(pathToSrcFile, "rb")
                
            # write to destination
            quickWrite(pathToDestinationFile, content, "wb")

# -----------------------------------------
# // ---- Main
# -----------------------------------------
# // Setup
# setup parser args
parser.add_argument("-sf", "--syncFolder", type = str, help = "The folder to sync from.", required = True)
parser.add_argument("-d", "--destination", type = str, nargs = "+", help = "The folders to sync to.", required = True)
parser.add_argument("-i", "--ignore", type = str, nargs = "*", help = "The files to ignore when syncing.", default = [])

CLIArgs = {argName : arg for argName, arg in parser.parse_args()._get_kwargs()}

# convert cli args to variables
syncFolder: str = CLIArgs["syncFolder"]
destinations: list[str] = CLIArgs["destination"]
exceptions: list[str] = CLIArgs["ignore"]

# validate args
if not os.path.exists(syncFolder):
    parser.error("Sync folder directory doesn't exist")

if False in [os.path.exists(exception) for exception in exceptions]:
    parser.error("One or more of the specified files to ignore don't exist")

# // Combine
# for later
message = f"Synced '{os.path.abspath(syncFolder)}' to:\n{listToBulletList([os.path.abspath(destination) for destination in destinations])}"

# sync files
for destination in destinations:
    try:
        copyFiles(
            syncFolder,
            destination,
            exceptions
        )
    except Exception as error:
        message = f"Failed to sync, error: \"{error}\""
        break

# print message
print(message, end = "\n\n")