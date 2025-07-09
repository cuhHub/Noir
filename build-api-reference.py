"""
This script is used to automatically generate the API reference in the documentation.
This script is also terrible and extremely rushed.
"""

from __future__ import annotations
import re
import os
import textwrap
from dataclasses import dataclass

@dataclass
class NoirValue:
    name: str
    type: str
    description: str
    point: int
    params: list[Param]
    returns: list[ReturnValue]
    deprecated: bool
    path: str
    
@dataclass
class Param:
    name: str
    type: str
    description: str|None
    
@dataclass
class ReturnValue:
    name: str
    type: str
    description: str|None

class Parser():
    def __init__(self, path: str):
        if not os.path.exists(path):
            raise Exception("Path does not exist")
        
        self.path = path
        self.content = None
        
        self.customTypes = {
            "Noir.Libraries.Events:Create()" : "NoirEvent",
            "Noir.Class" : "NoirClass",
            "Noir.Services:CreateService" : "NoirService",
            "Noir.Libraries:Create" : "NoirLibrary",
        }
        
    def updateContent(self):
        with open(self.path, "r") as f:
            self.content = f.read()
        
    def getType(self, value: str) -> str:
        if value.find("---@type ") != -1:
            return value.split("---@type ")[1]
        
        if value.startswith("\"") and value.endswith("\""):
            return "string"
        
        if value == "true" or value == "false":
            return "boolean"
        
        if value.isdigit():
            return "number"
        
        if value.isnumeric():
            return "number"
        
        if value.startswith("function"):
            return "function"
        
        if value.startswith(r"{"):
            return "table"
        
        for custom, valueType in self.customTypes.items():
            if value.find(custom) != -1:
                return valueType
        
        return "unknown"
    
    def getDescription(self, point: int) -> str:
        description = ""
        lines: list[str] = []
        
        # go backwards til start of command
        for line in reversed(self.content[:point].split("\n")):
            if line.find("--[[") != -1:
                break
            
            if line.find("]]") != -1:
                continue
            
            if line.find("---") != -1:
                continue
            
            lines.append(line)
            
        # make description
        lines = [line for line in reversed(lines)]
            
        # remove code
        newLines = []

        for line in lines:
            if line != "":
                newLines.append(line.replace("<br>", "\n\n"))
            else:
                break
        
        # join lines
        description = "".join(newLines)
        
        # deindent
        description = self.deindent(description)
          
        # return
        return description
    
    def getParameters(self, point: int) -> list[Param]:
        # search backwards for ---@param
        params: list[Param] = []
        found = False
        
        for line in reversed(self.content[:point].split("\n")):
            line = self.deindent(line)
            
            if line.find("]]") != -1:
                if found:
                    break
                else:
                    return []

            if line.find("---@param") != -1:
                found = True
                
                param = line.split("---@param ")[1]
                split = param.split(" ")
                
                if len(split) >= 2 and split[1].endswith(","): # table<integer*,* etc> annotation
                    name = split[0]
                    type = (split[1] + " " + split[2]) if len(split) >= 3 else None
                    description = " ".join(split[3:])
                else:
                    name = split[0]
                    type = split[1]
                    description = " ".join(split[2:])
                
                description = description if description != "" else None
                
                params.append(Param(
                    name = name,
                    type = type,
                    description = description
                ))
                
        # return
        return [*reversed(params)]
        
    def getReturns(self, point: int) -> list[ReturnValue]:
        # search backwards for ---@return
        returns = []

        for line in reversed(self.content[:point].split("\n")):
            line = self.deindent(line)

            if line.find("]]") != -1:
                break
            
            if line == "":
                continue
            
            if line.find("---@return") != -1:
                returnValue = line.split("---@return ")[1]
                split = returnValue.split(" ")

                if len(split) >= 2 and split[0].startswith("table<"): # table<integer*,* etc> annotation
                    type = split[0] + " " + split[1]
                    name = split[2] if len(split) >= 3 else None
                    description = " ".join(split[3:])
                else:
                    type = split[0]
                    name = split[1] if len(split) >= 2 else None
                    description = " ".join(split[2:]) if len(split) >= 3 else None
                
                description = description if description != "" else None
                
                returns.append(ReturnValue(
                    name = name,
                    type = type,
                    description = description
                ))
            else:
                break
                
        # return
        return [*reversed(returns)]
    
    def getIsDeprecated(self, point: int) -> bool:
        line = self.getLine(point)
        
        for line in reversed(self.content[:point].split("\n")):
            if line.find("]]") != -1:
                break
            
            if line.find("---@deprecated") != -1:
                return True
            
        return False
    
    def getNameAndValue(self, point: int) -> tuple[str, str]:
        line = self.getLine(point)
        
        if not line.startswith("function"):
            split = line.split(" = ")
            return split[0], split[1]
        else:
            return line[len("function") + 1:], "function"
        
    def getLine(self, point: int) -> str:
        return self.content[point:].split("\n")[0]
    
    def isInComment(self, point: int) -> bool:
        # setup what to find
        commentStart = "--[["
        commentEnd = "]]"
        
        # go backwards, looking for start of comment
        for line in reversed(self.content[:point].split("\n")):
            if line.find(commentStart) != -1:
                return True
            
            if line.find(commentEnd) != -1:
                return False
            
        # go forwards, looking for end of comment
        for line in self.content[point:].split("\n"):
            if line.find(commentStart) != -1:
                return False
            
            if line.find(commentEnd) != -1:
                return True
            
        # no comment found
        return False
    
    def isInFunction(self, point: int) -> bool:
        line = self.getLine(point)
        return line.startswith(" ")
    
    def isService(self, point: int) -> bool:
        line = self.getLine(point)
        
        if line.find("ServiceInit") != -1:
            return True
        
        if line.find("ServiceStart") != -1:
            return True
        
        if line.find("InitPriority") != -1:
            return True
        
        if line.find("StartPriority") != -1:
            return True
        
        return False
    
    def deindent(self, string: str) -> str:
        return textwrap.dedent(string)
        
    def parse(self) -> list[NoirValue]:
        # get content
        if not self.content:
            self.updateContent()
        
        # for later
        attributePoints = []
        
        # find attributes
        for line in self.content.split("\n"):
            # check if should ignore
            if line.endswith("---@ar_ignore"):
                continue
            
            # check if starts with Noir
            if line.find("Noir.") == -1:
                continue
            
            # check if contains = (sign of declaration of attribute)
            if line.find(" = ") == -1:
                continue
            
            # get the point
            point = self.content.find(line)

            # check if in function
            if self.isInFunction(point):
                continue
            
            # check if service attribute
            if self.isService(point):
                continue
            
            # add point
            attributePoints.append(point)
            
        # find functions
        functionPoints = []
        methods = [match.start() for match in re.finditer(r"function Noir\.", self.content)]
        functions = [match.start() for match in re.finditer(r"function Noir:", self.content)]

        for point in [*methods, *functions]:
            # validation
            if self.getLine(point).endswith("---@ar_ignore"):
                continue
            
            if self.isInComment(point):
                continue
            
            if self.isInFunction(point):
                continue
                
            if self.isService(point):
                continue
            
            # add
            functionPoints.append(point)
                
        # combine
        points = [*attributePoints, *functionPoints]
        
        # convert to dataclass
        values = []
        
        for point in points:
            line = self.getLine(point)
            
            name, value = self.getNameAndValue(point)

            values.append(NoirValue(
                name = name,
                type = self.getType(value),
                description = self.getDescription(point),
                point = point,
                params = self.getParameters(point) if value == "function" else [],
                returns = self.getReturns(point) if value == "function" else [],
                deprecated = self.getIsDeprecated(point),
                path = os.path.abspath(self.path)
            ))
            
        # return
        return values
    
    @staticmethod
    def parseAll(dir: str) -> list[NoirValue]:
        values = []
        
        for file in os.listdir(dir):
            path = os.path.join(dir, file)
            
            if os.path.isdir(path):
                values.extend(Parser.parseAll(path))
            else:
                parser = Parser(path)
                values.extend(parser.parse())
                
        return values
        
values = Parser.parseAll("src/Noir")
valuesForFiles: dict[str, list[str]] = {}

# format into markdown
for value in values:
    # get value stuffs
    markdown = ""
    name = value.name
    valueType = value.type
    description = value.description or "N/A"
    deprecated = value.deprecated
    deprecatedFormatted = "**⚠️ | Deprecated. Do not use.**\n\n" if deprecated else ""
    
    # show value name, type, and description
    markdown += f"```lua\n{name}\n```" if valueType == "function" else f"**{name}**: `{valueType}`\n"
    markdown += f"\n{deprecatedFormatted}{description}" + ("\n" if len(value.params) > 0 or len(value.returns) > 0 else "")
    
    # if function, show params and returns
    if valueType == "function":
        if len(value.params) > 0:
            markdown += "\n### Parameters\n"
            params = []
        
            for param in value.params:
                paramDescription = f" - {param.description}" if param.description else ""
                params.append(f"- `{param.name}`: {param.type}{paramDescription}")
                
            markdown += "\n".join(params)
         
        if len(value.returns) > 0:
            markdown += "\n### Returns\n"
            returns = []
        
            for returnValue in value.returns:
                returnName = f": {returnValue.name}" if returnValue.name else ""
                returnDescription = f" - {returnValue.description}" if returnValue.description else ""
                returns.append(f"- `{returnValue.type}`{returnName}{returnDescription}")
                
            markdown += "\n".join(returns)
    
    # save
    if not valuesForFiles.get(value.path):
        valuesForFiles[value.path] = []
        
    valuesForFiles[value.path].append(markdown)
    
# write
for path, markdown in valuesForFiles.items():
    directory = os.path.relpath(os.path.dirname(path), "src/noir")
    name = os.path.splitext(os.path.basename(path))[0]
    
    writePath = os.path.join("docs", "api-reference", "noir", directory, name).lower() + ".md"

    os.makedirs(os.path.dirname(writePath), exist_ok = True)
    
    with open(f"{writePath}", "w", encoding="utf-8") as file:
        file.write(f"# {name}\n\n" + "\n\n---\n\n".join(markdown))
        
# update summary.md
with open("docs/SUMMARY.md", "r") as f:
    summary = f.read()
    
    start = "* [☄️ API Reference](api-reference/README.md)"
    startPoint = summary.find(start) + len(start)
    
summary = summary[:startPoint]

def recursiveSummaryUpdate(path: str, level: int = 1) -> str:
    text = ""
    
    for name in os.listdir(path):
        full = os.path.join(path, name)
        forSummary = os.path.dirname(os.path.relpath(full, "src")).replace("\\", "/").lower()

        if os.path.isdir(full):
            text += ("  " * level) + f"* [{name}](api-reference/{forSummary}/{name.lower()}/README.md)\n"
            text += recursiveSummaryUpdate(full, level + 1)
        else:
            if not name.endswith(".lua") or name == "init.lua" or name == "Definition.lua":
                continue
            
            name = os.path.splitext(name)[0]
            text += ("  " * level) + f"* [{name}](api-reference/{forSummary}/{name.lower()}.md)\n"
            
    return text

summary += "\n" + recursiveSummaryUpdate("src/Noir", 1)

with open("docs/SUMMARY.md", "w") as f:
    f.write(summary)