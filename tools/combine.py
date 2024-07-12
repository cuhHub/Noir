# // ---------------------------------------------------------------------
# // ------- [Noir]  Combiner Tool
# // ---------------------------------------------------------------------

# -----------------------------------------
# // ---- Imports
# -----------------------------------------
import os
import argparse
import json

# -----------------------------------------
# // ---- Variables
# -----------------------------------------
parser = argparse.ArgumentParser(
    description = "Combines all files in a directory into one. Uses the __order.json file to determine which files to combine and in what order. If no __order.json file is found, all files will be combined.",
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
    
    if not os.path.exists(directory) and directory != "":
        os.makedirs(directory, exist_ok = True)
    
    with open(path, mode) as f:
        return f.write(content)
    
# // Check if path is in list
def pathInList(path: str, paths: list):
    for currentPath in paths:
        if os.path.exists(currentPath) and os.path.samefile(path, currentPath):
            return True
        
    return False

# // Get contents of all files in a path
def recursiveRead(targetDir: str, allowedFileExtensions: list[str], pathExceptions: list[str]) -> dict[str, str]:
    # check if theres a __order.json file
    orderJson = os.path.join(targetDir, "__order.json")
    
    if os.path.exists(orderJson):
        toCombine = quickRead(orderJson, "r")
        
        try:
            toCombine = json.loads(toCombine)
            files = toCombine["order"]
        except:
            print(f"{orderJson} is not in the correct format. Ignoring...")
            files = os.listdir(targetDir)
    else:
        files = os.listdir(targetDir)
    
    # list files
    contents = {}
    
    # iterate through them
    for file in files:
        # get file-related variables
        _, extension = os.path.splitext(file)
        path = os.path.join(targetDir, file)
        
        # check if exists
        if not os.path.exists(path):
            print(f"{path} does not exist. Ignoring...")
            continue
        
        # file is folder, but is an exception
        if pathInList(path, pathExceptions):
            continue
        
        # file extension check
        if extension == "":
            # file is folder, so read it too
            contents = {**contents, **recursiveRead(path, allowedFileExtensions, pathExceptions)}
            
        # file extension check
        if extension not in allowedFileExtensions and len(allowedFileExtensions) > 0:
            continue
        
        # get file content
        content = quickRead(path, "r")
        
        # append file content to contents
        contents[path] = content
        
    return contents

# -----------------------------------------
# // ---- Main
# -----------------------------------------
# // Setup
# setup parser args
parser.add_argument("-d", "-p", "--directory", "--path", type = str, help = "The directory containing files to combine.", required = True)
parser.add_argument("-de", "--destination", type = str, help = "The file which should have the content of all files combined. Created automatically if it doesn't exist.", required = True)
parser.add_argument("-afe", "--allow_file_extension", type = str, nargs = "*", help = "The file extensions to allow.", default = [])
parser.add_argument("-ip", "--ignore_path", type = str, nargs = "*", help = "The paths to ignore when combining.", default = [])

args = parser.parse_args()

# // Main
# get content of all files
result = recursiveRead(
    args.directory.replace("/", "\\"),
    args.allow_file_extension,
    [*args.ignore_path, *[args.destination, os.path.relpath(__file__)]]
)

# print message
print("Combined the following files:\n- " + "\n- ".join([*result.keys()]))

# format result
for path, content in result.items():
    newContent = [
        "----------------------------------------------",
        f"-- // [File] {path}",
        "----------------------------------------------",
        content
    ]
    
    result[path] = "\n".join(newContent)

# dump it into output file
try:
    quickWrite(args.destination, "\n\n".join(result.values()), "w")
except Exception as error:
    print(f"Failed to output. Error: {error}")