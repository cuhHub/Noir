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
POLYFILL = (TEST_DIR / "_polyfill.lua").read_text()
NOIR_PATH = Path("src/Noir")
LUA_PATH = Path("lua")
LUA_EXECUTABLE = LUA_PATH / "lua53.exe"

# ---- // Main
class NoirTest():
    """
    A Noir test.
    """
    
    def __init__(self, path: Path):
        """
        Initializes new `NoirTest` instances.
        
        Args:
            path (Path): The path to the test file.
        """
        
        self.name = path.stem
        self.path = path

        
    def _create_temp_noir_build(self) -> Path:
        """
        Creates a temporary build of Noir to be packed with the test file.
        
        Returns:
            Path: The path to the temporary build.
        """
        
        # Create temp file
        temp_file = self.path.parent / f"{self.name}_temp.lua"
        
        # Build Noir and dump to temp file
        combiner = Combiner(
            directory = NOIR_PATH,
            destination = temp_file,
            whitelisted_extensions = [".lua"],
            blacklisted_extensions = [],
            ignored = []
        )
        
        combiner.combine()
        
        # Add polyfill
        contents = temp_file.read_text()
        contents = POLYFILL + "\n\n" + contents
        temp_file.write_text(contents)
        
        # Return
        return temp_file
    
    def _get_error_message(self, stderr: bytes) -> str:
        """
        Gets the error message from test command stderr.
        
        Args:
            stderr (bytes): The test command stderr.
            
        Returns:
            str: The formatted error message.
        """
        
        error = stderr.decode("utf-8")
        no_path = "".join(error.split("_temp.lua:")[1:]) # removes long path at start of error message
        no_traceback = no_path.split("\n")[0] # removes traceback at end of error message

        return no_traceback 
        
    def run(self) -> tuple[bool, str]:
        """
        Runs the test.
        
        Returns:
            tuple[bool, str]: Whether or not the test passed, and the reason why it failed (if it did)
        """
        
        # Create a temporary build of Noir to be packed with the test file
        temp_noir_build = self._create_temp_noir_build()
        
        # Add test code to the temp file
        test_content = self.path.read_text()
        
        with temp_noir_build.open("a") as file:
            file.write("\n\n" + test_content)
        
        # Run the temp file
        result = subprocess.run([LUA_EXECUTABLE, temp_noir_build.absolute()], cwd = LUA_PATH, capture_output = True)
        temp_noir_build.unlink()
        
        # Return
        if result.returncode == 0:
            return True, ""
        else:
            return False, self._get_error_message(result.stderr)

def success(message: str):
    """
    Prints a success message.
    
    Args:
        message (str): The message to print.
    """    
    
    print("[bold green](Success)[/bold green] " + message)
    
def info(message: str):
    """
    Prints an info message.
    
    Args:
        message (str): The message to print.
    """    
    
    print("[bold blue](Info)[/bold blue] " + message)
    
def error(message: str):
    """
    Prints an error message.
    
    Args:
        message (str): The message to print.
    """    
    
    print("[bold red](Error)[/bold red] " + message)

@click.command()
def run():
    print(Panel(
        title = "⚙️ | Noir Test Tool",
        renderable = "A tool to run all Noir tests.",
        border_style = "green",
        width = 60
    ))
    
    # Run tests
    results: list[tuple[NoirTest, bool, str]] = []
    success_count, fail_count = 0, 0
    
    for test_path in TEST_DIR.iterdir():
        if test_path.suffix != ".lua":
            continue
        
        if test_path.name.startswith("_"):
            continue
        
        test = NoirTest(test_path)
        successful, fail_reason = test.run()
        results.append((test, successful, fail_reason))
        
        if successful:
            success_count += 1
        else:
            fail_count += 1

        info(f"Ran test: \"{test.name}\"")
        
    # Show results
    info("----------------")
    info("Results:")
        
    for test, successful, fail_reason in results:
        if successful:
            success(f"[:)] \"{test.name}\" passed.")
        else:
            error(f"[:(] \"{test.name}\" failed: {fail_reason}")
            
    test_count = len(results)
    info(f"Out of {test_count} tests, {success_count} ({success_count / test_count * 100:.1f}%) passed and {fail_count} failed ({fail_count / test_count * 100:.1f}%).")
    
if __name__ == "__main__":
    run()