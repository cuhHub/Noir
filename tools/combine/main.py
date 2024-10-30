# // ---------------------------------------------------------------------
# // ------- [Noir] Combiner Tool
# // ---------------------------------------------------------------------

"""
A tool for combining all files in a directory into one.
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
from pathlib import Path
import click
import json
import rich
from rich import print
from rich.panel import Panel

# ---- // Classes
class Combiner():
    """
    A class used to combine all files in a directory into one.
    """

    def __init__(self, directory: Path, destination: Path, whitelisted_extensions: list[str], blacklisted_extensions: list[str], ignored: list[Path]):
        """
        Initialize the class.

        Args:
            directory (Path): The directory containing files to combine.
            destination (Path): The file which should have the content of all files combined.
            whitelisted_extensions (list[str]): The file extensions to allow. Leave empty to allow all extensions.
            blacklisted_extensions (list[str]): The file extensions to ignore. Leave empty to ignore no extensions.
            ignored (list[Path]): The paths (inc. files) to ignore when combining.
            
        Raises:
            ValueError: If both whitelisted_extensions and blacklisted_extensions are used at the same time.
            ValueError: If the directory does not exist.
        """
        
        if len(whitelisted_extensions) > 0 and len(blacklisted_extensions) > 0:
            raise ValueError("Cannot use both whitelisted_extensions and blacklisted_extensions at the same time.")
        
        if not directory.exists():
            raise ValueError("Directory does not exist.")
        
        self.directory = directory
        self.destination = destination
        self.whitelisted_extensions = whitelisted_extensions
        self.blacklisted_extensions = blacklisted_extensions
        self.ignored = ignored
        self.ignored.extend([Path(destination)])
        
    def combine(self, prevent_write: bool = False, *, _directory: Path|None = None) -> tuple[str, dict[Path, str]]:
        """
        Combine all files in the directory into one.
        
        Args:
            prevent_write (bool, optional): Whether or not to prevent writing the combined file. Defaults to False.
            _directory (Path, optional): The directory to combine. Used internally. Defaults to None.

        Returns:
            str: The combined content of all files, joined together by two newlines.
            dict[Path, str]: The contents of all combined files.
            
        Raises:
            ValueError: If an existing `__order.json` file is invalid.
        """
        
        # Validation
        if _directory is None:
            _directory = self.directory
        
        # For later
        contents: dict[Path, str] = {}
        
        # Read __order.json if it exists 
        order = self._read_order(_directory)

        if order is not None:
            orderedFiles: list[str]|None = order.get("order")
            
            if orderedFiles is None:
                raise ValueError(f"Invalid `__order.json` file @ {path}. Missing `order` list.")
            
            paths = [_directory / file for file in orderedFiles]
        else:
            paths = [*_directory.iterdir()]
        
        # Read files
        for path in paths:
            if path.is_file():
                # Check if the file is allowed
                if not self.is_file_allowed(path):
                    continue
                
                # Read and save
                try:
                    contents[path] = path.read_text("utf-8")
                except:
                    continue
            else:
                # Check if the directory is allowed
                if not self._is_directory_allowed(path):
                    continue
            
                # Iterate through files
                _, results = self.combine(prevent_write = prevent_write, _directory = path)
                contents.update(results)
                
        # Write
        result = "\n\n".join(contents.values())
        
        if not prevent_write:
            self.destination.parents[0].mkdir(exist_ok = True)
            self.destination.write_text(result, encoding = "utf-8")
        
        # Return
        return result, contents
    
    def _read_order(self, directory: Path) -> dict|None:
        """
        Read an __order.json file.
        
        Args:
            directory (Path): The directory containing the file.
        
        Returns:
            dict|None: The __order.json contents as a dictionary, or None if it does not exist.
        """
        
        order_definition = directory / "__order.json"
        
        if not order_definition.exists():
            return None

        try:
            return json.loads(order_definition.read_text("utf-8"))
        except json.JSONDecodeError:
            raise ValueError(f"Invalid `__order.json` file @ {order_definition}.")
                
    def _is_directory_allowed(self, path: Path) -> bool:
        """
        Check if a directory is allowed to be parsed.

        Args:
            path (Path): The path to check.
            
        Returns:
            bool: Whether or not the directory is allowed to be parsed.
        """

        if self.in_paths(path, self.ignored):
            return False
        
        return True
                
    def is_file_allowed(self, path: Path) -> bool:
        """
        Check if a file is allowed to be parsed.

        Args:
            path (Path): The path to check.

        Returns:
            bool: Whether or not the file is allowed to be parsed.
        """
        
        if len(self.whitelisted_extensions) > 0 and not path.suffix in self.whitelisted_extensions:
            return False
        
        if len(self.blacklisted_extensions) > 0 and path.suffix in self.blacklisted_extensions:
            return False
        
        if self.in_paths(path, self.ignored):
            return False
        
        return True
  
    def in_paths(self, path: Path, paths: list[Path]) -> bool:
        """
        Check if a path is in a list of paths.

        Args:
            path (Path): The path to check.
            paths (list[Path]): A list of paths to check against.

        Returns:
            bool: Whether or not the path is in the list of paths.
        """
        
        for current_path in paths:
            if path.absolute() == current_path.absolute():
                return True
            
        return False

# ---- // Main
@click.command()
@click.option("--directory", "-d", "-p", "--path", type = str, required = True, help = "The directory containing files to combine.")
@click.option("--destination", "-de", type = str, required = True, help = "The file which should have the content of all files combined. Created automatically if it doesn't exist.")
@click.option("--allow_file_extension", "-afe", default = [], multiple = True, help = "The file extensions to allow.")
@click.option("--ignore_path", "-ip", default = [], multiple = True, help = "The paths to ignore when combining.")
def combiner_tool(directory: str, destination: str, allow_file_extension: list[str], ignore_path: list[str]):
    """
    Combine all files in the directory into one.

    Args:
        directory (str): The directory containing files to combine.
        destination (str): The file which should have the content of all files combined. Created automatically if it doesn't exist.
        allow_file_extension (list[str]): The file extensions to allow.
        ignore_path (list[str]): The paths to ignore when combining.
    """    
    
    # Combine files
    ignored = [Path(path) for path in ignore_path]
    ignored.extend([Path(__file__)])

    combiner = Combiner(
        directory = Path(directory),
        destination = Path(destination),
        whitelisted_extensions = allow_file_extension,
        blacklisted_extensions = [],
        ignored = ignored
    )
    
    _, contents = combiner.combine()

    # Output
    print(Panel(
        title = "📂 | Noir Combiner Tool",
        renderable = "A tool to combine multiple files into a single file.",
        border_style = "blue",
        width = 60
    ))

    print("[bold green](Done)[/bold green] Combined the following files:")
    
    if len(contents) == 0:
        print("     - [red]None[/red]")
    
    for path in contents.keys():
        print(f"    🗃️ [blue]{path}[/blue]")
    
    print(f"To: {combiner.destination}")
    
if __name__ == "__main__":
    combiner_tool()