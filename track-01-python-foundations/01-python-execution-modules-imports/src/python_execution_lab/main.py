"""Application entry point for the Python execution lab."""

import os
import sys
from pathlib import Path

from python_execution_lab.formatter import format_message


def display_runtime_context() -> None:
    """Display information that affects Python execution and imports."""
    print("--- Runtime context ---")
    print(f"__name__: {__name__}")
    print(f"Current working directory: {Path.cwd()}")
    print(f"Current file: {Path(__file__).resolve()}")
    print(f"Python executable: {sys.executable}")
    print(f"Process ID: {os.getpid()}")

    print("\n--- sys.path ---")
    for index, path_entry in enumerate(sys.path):
        print(f"{index}: {path_entry}")


def main() -> None:
    """Run the application."""
    display_runtime_context()

    print("\n--- Application output ---")
    print(format_message("systems engineer"))


if __name__ == "__main__":
    print("The __main__ guard was entered.\n")
    main()
