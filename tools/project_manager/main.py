# // ---------------------------------------------------------------------
# // ------- [Noir] Project Manager Tool
# // ---------------------------------------------------------------------

"""
A tool for quickly setting up addons with Noir.
Repo: https://github.com/cuhHub/Noir

---

Copyright (C) 2025 Cuh4

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
"""

# ---- // Imports
import time
import requests
import subprocess
import os
import json
from textwrap import dedent
from pathlib import Path as _Path
from werkzeug.utils import secure_filename
import rich
from rich import print
from rich.panel import Panel
from rich.prompt import Prompt

# ---- // Functions
def multiline(string: str) -> str:
    """
    Dedents multi-line strings and removes the first new line.

    Args:
        string (str): The multi-line string.

    Returns:
        str: The new string.
    """
    
    return dedent(string).replace("\n", "", 1)

def XMLEscape(string: str) -> str:
    """
    Escapes XML characters.

    Args:
        string (str): The string to escape.

    Returns:
        str: The escaped string.
    """
    
    string = string.replace("&", "&amp;")
    string = string.replace("<", "&lt;")
    string = string.replace(">", "&gt;")
    string = string.replace("\"", "&quot;")
    string = string.replace("'", "&apos;")

    return string

def richError(exception: Exception):
    """
    Prints an error message in red.

    Args:
        exception (Exception): The exception to print.
    """
    
    rich.print(f"[bold red] Error: {exception}[/bold red]")
    
def errorWrapper(func: "function") -> "function":
    """
    Wraps a function in an error handler that prints any errors that come up.
    
    Args:
        func (function): The function to wrap.
    
    Returns:
        function: The wrapped function.
    """
    
    def wrapper(*args, **kwargs):
        try:
            return func(*args, **kwargs)
        except Exception as error:
            richError(error)
    
    return wrapper

# ---- // Classes
class Path(_Path):
    """
    Wrapper class for pathlib.Path.

    Args:
        _Path (Path): The pathlib.Path class.
    """    
    
    def expand(self):
        """
        Expands the path.

        Returns:
            Path: The expanded path.
        """
        
        return Path(os.path.expandvars(self)).expanduser().resolve()

class Project():
    """
    Represents an addon project.
    """
    
    script = multiline("""
    --[[
        This is your addon code. You can make another .lua file, but be sure to include it in the `__order.json` file!
        Note that the above step is unnecessary if a folder containing `.lua` files is in the `__order.json` file as the files will be included automatically.

        To reflect changes to your code into Stormworks, run `build.bat`. Otherwise, changes won't get synced to Stormworks.
        
        Head over to `https://cuhhub.gitbook.io/noir` for documentation.
    ]]
                       
    Noir.Started:Once(function()
        -- Code
    end)
    
    Noir:Start()""")
    
    playlist = multiline("""
    <?xml version="1.0" encoding="UTF-8"?>
    <playlist folder_path="data/missions/{escapedAddonName}" file_store="4" name="{addonName}">
        <locations/>
    </playlist>

    """)
    
    README = multiline("""
    # {addonName}
    
    This is your addon's README file. You can remove this if you would like.
    
    Your main addon code should go in `main.lua`. You can create more `.lua` files as long as you add them to `__order.json` too (after `Noir.lua`, and before `main.lua`).

    To reflect changes from your code into Stormworks, run `build.bat`. Otherwise, changes won't get synced to Stormworks.
    
    Head over to [here](https://cuhhub.gitbook.io/noir) for documentation.""")
    
    exampleLibrary = multiline("""
    --[[
        This is an example of a library. You can have as many libraries as needed for different things. Libraries should not interact with the game or services, only each other.
        Head over to `https://cuhhub.gitbook.io/noir` for documentation.
    ]]
    
    --[[
        An example library that does nothing meaningful. :-(
    ]]
    ---@class MyLibrary: NoirLibrary
    MyLibrary = Noir.Libraries:Create("MyLibrary")
    
    --[[
        Adds two numbers together.
    ]]
    ---@param num1 number
    ---@param num2 number
    ---@return number
    function MyLibrary:Add(num1, num2)
        return num1 + num2
    end
    """)
    
    exampleService = multiline("""
    --[[
        This is an example of a service. You can have as many services as needed for different things.
        Head over to `https://cuhhub.gitbook.io/noir` for documentation.
    ]]
    
    --[[
        An example service that essentially does nothing meaningful. :-(
    ]]
    ---@class MyService: NoirService
    ---@field Foo boolean
    MyService = Noir.Services:CreateService("MyService")
    
    --[[
        This is called when the service is initialized.
        This is where you can setup your service by adding attributes and such.
    ]]
    function MyService:ServiceInit()
        self.Foo = true
    end
    
    --[[
        This is called when the service is started.
        This is where you can safely interact with other services as they are guaranteed to be initialized. This is also where you can setup timers, start core logic, etc.
    ]]
    function MyService:ServiceStart()
        Noir.Services.MessageService:SendMessage(nil, "MyService", "Is Foo: %s", self.Foo)
        self:SayHi("This message originated from MyService!")
    end
    
    --[[
        A method that announces a greeting via a notification.
    ]]
    ---@param message string
    function MyService:SayHi(message)
        Noir.Services.NotificationService:Info("Greeting", "Hey all! %s", nil, message)
    end
    """)
    
    NoirDownloadURL = "https://github.com/cuhHub/Noir/releases/latest/download/Noir.lua"
    CombineDownloadURL = "https://github.com/cuhHub/Noir/releases/latest/download/combine.exe"
    IntellisenseDownloadURL = "https://raw.githubusercontent.com/Cuh4/StormworksAddonLuaDocumentation/main/docs/intellisense.lua"
    
    build = "combine.exe --directory \".\" --destination \"{romScriptPath}\" --allow_file_extension \".lua\""

    def __init__(self, name: str, addonPath: Path, SWAddonsPath: Path):
        """
        Initializes project class objects.

        Args:
            name (str): The name of the addon
            addonPath (Path): The path the addon should be placed in
            SWAddonsPath (Path): The path to the Stormworks addon folder
            
        Raises:
            NotADirectoryError: If the addon path is not a directory
        """
        
        if addonPath.exists() and not addonPath.is_dir():
            raise NotADirectoryError(f"Addon path '{addonPath}' is not a directory.")

        if not SWAddonsPath.expand().exists():
            raise NotADirectoryError(f"Stormworks addon path '{SWAddonsPath}' does not exist. If you are on Windows, '%appdata/Stormworks/data/missions' should work.")
        
        self.rawName = name
        self.name = XMLEscape(secure_filename(self.rawName))
        self.SWAddonsPath = SWAddonsPath.expand()

        self.addonPath = addonPath # The path the user will be writing code in
        self.romAddonPath = self.SWAddonsPath / self.name # The path where the Stormworks addon will be placed
        self.romPlaylistPath = self.romAddonPath / "playlist.xml"
        self.romScriptPath = self.romAddonPath / "script.lua"

        self.addonPath = addonPath # The path the user will be writing code in
        self.NoirPath = self.addonPath / "Noir.lua"
        self.orderPath = self.addonPath / "__order.json"
        self.combinePath = self.addonPath / "combine.exe"
        self.buildPath = self.addonPath / "build.bat"
        self.intellisensePath = self.addonPath / "intellisense.lua"
        self.READMEPath = self.addonPath / "README.md"
    
        self.srcPath = self.addonPath / "src"
        self.scriptPath = self.srcPath / "main.lua"
        self.librariesPath = self.srcPath / "libraries"
        self.exampleLibraryPath = self.librariesPath / "ExampleLib.lua"
        self.servicesPath = self.srcPath / "services"
        self.exampleServicePath = self.servicesPath / "ExampleService.lua"

    def create(self):
        """
        Creates the project.
        """
        
        if self.projectExists():
            raise Exception("Project already exists. If the project isn't fully created, delete all files and try again.")

        self._createDirectories()

        self._createNoir()
        self._createScript()
        self._createLibraryExample()
        self._createServiceExample()
        self._createOrder()
        self._createBuild()
        self._createIntellisense()
        self._createREADME()
        self._createCombine()
        
        self._createPlaylist()
        
    def update(self):
        """
        Updates the project's Noir.lua file.
        """
        
        if not self.projectExists():
            raise Exception("Project does not exist. Create the project first before updating it.")
        
        self._createNoir()
        self._createIntellisense()
        self._createCombine()
        
    def openAddon(self):
        """
        Opens the addon in VSCode (if possible), otherwise file explorer.
        """
        
        if not self.projectExists():
            raise Exception("Project does not exist. Create the project first before opening it.")
        
        success = self._openInVSCode(self.addonPath)
        
        if not success:
            os.startfile(self.addonPath)
        
    def _openInVSCode(self, path: Path) -> bool:
        """
        Opens the project in VSCode.
        
        Args:
            path (Path): The path to the project
        
        Returns:
            bool: Whether or not the project was opened in VSCode successfully
        """
        
        try:
            subprocess.run(["code", path], check = True, shell = True)
            return True
        except:
            return False
    
    def projectExists(self) -> bool:
        """
        Returns whether or not this project has been created already.

        Returns:
            bool: Whether or not the project exists
        """        
        
        return self.romAddonPath.exists() and self.addonPath.exists()
    
    def _createDirectories(self):
        """
        Creates the addon directories.
        """
        
        self.romAddonPath.mkdir(parents = True, exist_ok = True)
        self.addonPath.mkdir(parents = True, exist_ok = True)
        self.srcPath.mkdir(parents = True, exist_ok = True)
        self.librariesPath.mkdir(parents = True, exist_ok = True)
        self.servicesPath.mkdir(parents = True, exist_ok = True)
        
    def _createNoir(self):
        """
        Creates the `Noir.lua` file.
        """
        
        response = requests.get(self.NoirDownloadURL)
        
        if not response.ok:
            raise Exception("Failed to download 'Noir.lua'.")
        
        self.NoirPath.write_bytes(response.content)
        
    def _createCombine(self):
        """
        Creates the `combine.exe` file.
        """
        
        response = requests.get(self.CombineDownloadURL)
        
        if not response.ok:
            raise Exception("Failed to download 'combine.exe'.")

        self.combinePath.write_bytes(response.content)
        
    def _createIntellisense(self):
        """
        Creates the `intellisense.lua` file.
        """
        
        response = requests.get(self.IntellisenseDownloadURL)
        
        if not response.ok:
            raise Exception("Failed to download 'intellisense.lua'.")
        
        self.intellisensePath.write_bytes(response.content)
        
    def _createREADME(self):
        """
        Creates the `README.md` file.
        """
        
        self.READMEPath.write_text(self.README.format(addonName = self.rawName))
            
    def _createPlaylist(self):
        """
        Creates the `playlist.xml` file.
        """
        
        self.romPlaylistPath.write_text(self.playlist.format(escapedAddonName = self.name, addonName = self.rawName))
        
    def _createScript(self):
        """
        Creates the `script.lua` file.
        """
        
        self.scriptPath.write_text(self.script)
            
    def _createOrder(self):
        """
        Creates the `__order.json` file.
        """
        
        order = json.dumps({
            "order" : [
                str(self.NoirPath.relative_to(self.addonPath)),
                str(self.librariesPath.relative_to(self.addonPath)),
                str(self.servicesPath.relative_to(self.addonPath)),
                str(self.scriptPath.relative_to(self.addonPath))
            ]
        }, indent = 7)
        
        self.orderPath.write_text(order)
        
    def _createLibraryExample(self):
        """
        Creates the `ExampleLibrary.lua` file.
        """
        
        self.librariesPath.mkdir(parents = True, exist_ok = True)
        self.exampleLibraryPath.write_text(self.exampleLibrary)
        
    def _createServiceExample(self):
        """
        Creates the `ExampleService.lua` file.
        """
        
        self.exampleServicePath.write_text(self.exampleService)
            
    def _createBuild(self):
        """
        Creates the `build.bat` file.
        """
        
        self.buildPath.write_text(self.build.format(romScriptPath = self.romScriptPath))

# ---- // Main
@errorWrapper
def project_manager():
    # Clear
    os.system("cls")
    
    # Title (ish)
    print(Panel(
        title = "📂 | Noir Project Manager",
        renderable = "This tool will help you create a new project with Noir or update existing projects.\n\nFollow the prompts below.",
        border_style = "blue",
        width = 60
    ))
    
    # Get project name
    rich.print("[blue]1)[/blue] Project name (eg: [bold green]AI Gunners[/bold green])")
    projectName = Prompt.ask("> ")
    
    # Get project path
    rich.print("[blue]2)[/blue] Desired path for your addon (eg: [bold green]C:/MyAddons/AIGunners[/bold green])")
    projectPath = Path(Prompt.ask("> "))
    
    # Get path to Stormworks addons
    rich.print("[blue]3)[/blue] Stormworks addons path (on Windows, this is usually [bold green]%appdata%/Stormworks/data/missions[/bold green])")
    SWAddonsPath = Path(Prompt.ask("> "))
    
    # Create project
    project = Project(
        name = projectName,
        addonPath = projectPath,
        SWAddonsPath = SWAddonsPath
    )

    # Create, update, or open
    while True:
        # Clear
        os.system("cls")
        
        # Show project details
        print(Panel.fit(
            title = f"💻 | {project.name}",
            renderable = f"Path: [bold green]{project.addonPath}[/bold green]",
            border_style = "blue"
        ))
        
        rich.print(f"[blue]Create[/blue]: Sets up the addon by creating directories, files, etc.{" [bold red]The project has already been created.[/bold red]" if project.projectExists() else ""}")
        rich.print(f"[blue]Update[/blue]: Updates Noir and any tools.{" [bold red]The project has not been created yet.[/bold red]" if not project.projectExists() else ""}")
        rich.print(f"[blue]Open[/blue]: Opens the addon in VSCode (or file explorer if not possible).{" [bold red]The project has not been created yet.[/bold red]" if not project.projectExists() else ""}")
        rich.print("[blue]Quit[/blue]: Closes the tool.")
        choice = Prompt.ask("> ", choices = ["create", "update", "open", "quit"], default = "create", show_default = False)
        
        if choice == "create":
            if project.projectExists():
                rich.print("[bold red]The project has already been created![/bold red]")
                time.sleep(1.5)
                continue
            
            project.create()
            project.openAddon()

            rich.print("[green]Project created![/green]")
            time.sleep(1.5)
        elif choice == "update":
            project.update()

            rich.print("[green]Project updated![/green]")
            time.sleep(1.5)
        elif choice == "open":
            project.openAddon()
        elif choice == "quit":
            break
    
if __name__ == "__main__":
    project_manager()