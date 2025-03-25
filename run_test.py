# // ---------------------------------------------------------------------
# // ------- [Noir] Test Tool
# // ---------------------------------------------------------------------

"""
A tool for running a test.
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
import click
import subprocess
from rich import print
from rich.panel import Panel
from pathlib import Path

from tools.combine import Combiner

# ---- // Variables
TEST_DIR = Path("tests")
NOIR_PATH = Path("src/Noir")
LUA_PATH = Path("lua")
LUA_EXECUTABLE = LUA_PATH / "lua53.exe"

# ---- // Functions
def run_test(path: Path):
    """
    Runs a Noir .lua test.

    Args:
        path (Path): The path to the test file.
    """
    
    # Create a temporary build of Noir to be packed with the test file
    temp_file = LUA_PATH / "temp.lua"
    
    combiner = Combiner(
        directory = NOIR_PATH,
        destination = temp_file,
        whitelisted_extensions = [".lua"],
        blacklisted_extensions = [],
        ignored = []
    )
    
    combiner.combine()
    
    # Add test code to the temp file
    test_content = path.read_text()
    
    with temp_file.open("a") as file:
        file.write("\n\n" + test_content)
    
    # Run the temp file
    try:
        assert subprocess.run([LUA_EXECUTABLE, temp_file.absolute()], cwd = LUA_PATH).returncode == 0
    except:
        temp_file.unlink()
        return False
    
    # Remove temp file
    temp_file.unlink()
    return True

def success(message: str):
    """
    Prints a success message.
    
    Args:
        message (str): The message to print.
    """    
    
    print("[bold green](Success)[/bold green] " + message)
    
def error(message: str):
    """
    Prints an error message.
    
    Args:
        message (str): The message to print.
    """    
    
    print("[bold red](Error)[/bold red] " + message)

# ---- // Main
@click.command()
@click.option("--test", "-t", type = str, required = True, help = "The name of the Noir test .lua file.")
def run(test: str):
    print(Panel(
        title = "⚙️ | Noir Test Tool",
        renderable = "A tool to run a Noir test.",
        border_style = "green",
        width = 60
    ))
    
    path = TEST_DIR / Path(test)
    relative = path.relative_to(".")
    
    if not path.exists():
        error(f"Test does not exist ([bold]{relative}[/bold]).")
        exit(0)
        
    if path.suffix != ".lua":
        error("Test must be a [bold].lua[/bold] file.")
        exit(0)
    
    test_success = run_test(path)
    
    if test_success:
        success(f"[bold]{relative}[/bold] ran successfully.")
    else:
        error(f"[bold]{relative}[/bold] failed to run.")
    
if __name__ == "__main__":
    run()