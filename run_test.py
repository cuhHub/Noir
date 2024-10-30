# // ---------------------------------------------------------------------
# // ------- [Noir] Test Tool
# // ---------------------------------------------------------------------

"""
A tool for running a test.
Repo: https://github.com/cuhHub/Noir

---

Copyright (C) 2024 Cuh4

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

# ---- // Main
@click.command()
@click.option("--test", "-t", type = str, required = True, help = "The path to the Noir test .lua file.")
def run(test: str):
    print(Panel(
        title = "⚙️ | Noir Test Tool",
        renderable = "A tool to run a Noir test.",
        border_style = "green",
        width = 60
    ))
    
    path = Path(test)
    
    if not path.exists():
        print("[bold red](Error)[/bold red] Test not found.")
        exit(0)
        
    if path.suffix != ".lua":
        print("[bold red](Error)[/bold red] Test must be a .lua file.")
        exit(0)
    
    success = run_test(path)
    
    if success:
        print(f"[bold green](Done)[/bold green] [bold]{path.relative_to(".")}[/bold] ran successfully.")
    else:
        print(f"[bold red](Error)[/bold red] [bold]{path.relative_to('.')}[/bold] encountered an error.")
    
if __name__ == "__main__":
    run()