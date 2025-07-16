# // ---------------------------------------------------------------------
# // ------- [Noir] Build
# // ---------------------------------------------------------------------

"""
A helper script for building Noir.
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

# // Imports
from pathlib import Path
from tools.combine import Combiner
import subprocess

# // Functions
def build_noir():
    """
    Builds all of Noir into a singular file.
    """

    combiner = Combiner(
        directory = Path("src"),
        destination = Path("_build/Noir.lua"),
        whitelisted_extensions = [".lua"],
        blacklisted_extensions = [],
        ignored = []
    )
    
    combiner.combine()

def get_version() -> tuple[int, int, int]:
    """
    Gets the version from the VERSION file.

    Returns:
        tuple[int, int, int]: The major, minor, and patch version
    """

    return tuple(Path("VERSION").read_text().split("."))

def update_version():
    """
    Updates the version in the Noir.lua build file.
    """
    
    # Update version in Noir
    major, minor, patch = get_version()
    to_replace = "Noir.Version = \"{VERSION_MAJOR}.{VERSION_MINOR}.{VERSION_PATCH}\""

    # Get contents
    noir_path = Path("_build/Noir.lua")
    noir_contents = noir_path.read_text()
    
    # Replace version
    noir_path.write_text(noir_contents.replace(to_replace, to_replace.format(
        VERSION_MAJOR = major,
        VERSION_MINOR = minor,
        VERSION_PATCH = patch
    )))
    
def build(name: str, path: Path, icon: Path|None = None):
    """
    Run PyInstaller with the given path.

    Args:
        name (str): The name of the executable.
        path (Path): The path to build.
        path (Path|None): The path to the icon.
    """
    
    # Build
    arguments = [
        "pyinstaller", str(path.absolute()),
        "--onefile",
        "--distpath", "_build",
        "--name", name,
        "--specpath", "specs"
    ]
    
    if icon is not None:
        arguments.extend([f"--icon={str(icon.absolute())}"])
 
    print(f"> Building {name}... Icon: {icon if icon is not None else "N/A"}")
    print(arguments)
    
    subprocess.run(arguments, check = True)

def build_tools():
    """
    Builds all of Noir's tools.
    """
    
    for tool in Path("tools").iterdir():
        file = tool / "main.py"
        
        if not file.exists():
            continue
    
        icon = tool / "icon.ico"
        
        build(tool.name, file,  icon if icon.exists() else None)

# ---- // Main
if __name__ == "__main__":
    print("Building Noir...")
    build_noir()
    
    print("Updating Noir version...")
    update_version()
    
    print("Building tools...")
    build_tools()