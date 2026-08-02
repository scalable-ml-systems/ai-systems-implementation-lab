"""Command-line interface for system qualification."""

import argparse
import json
from typing import Sequence

from system_qualification_cli.checks import check_python_version
from system_qualification_cli.models import (
    CheckStatus,
    QualificationResult,
)


def parse_version(version_text: str) -> tuple[int, int]:
    """Convert a value such as '3.11' into the tuple (3, 11)."""

    parts = version_text.split(".")

    if len(parts) != 2:
        raise argparse.ArgumentTypeError(
            "Python version must use MAJOR.MINOR format, such as 3.11."
        )

    try:
        major = int(parts[0])
        minor = int(parts[1])
    except ValueError as error:
        raise argparse.ArgumentTypeError(
            "Python version components must be integers."
        ) from error

    if major < 0 or minor < 0:
        raise argparse.ArgumentTypeError(
            "Python version components must not be negative."
        )

    return major, minor


def build_parser() -> argparse.ArgumentParser:
    """Create and configure the command-line argument parser."""

    parser = argparse.ArgumentParser(
        prog="system-qualify",
        description="Validate whether a machine satisfies system requirements.",
    )

    parser.add_argument(
        "--min-python",
        type=parse_version,
        default=(3, 11),
        metavar="MAJOR.MINOR",
        help="Minimum required Python version. Default: 3.11",
    )

    return parser


def result_to_dictionary(
    result: QualificationResult,
) -> dict[str, str | None]:
    """Convert a qualification result into a JSON-safe dictionary."""

    return {
        "name": result.name,
        "status": result.status.value,
        "expected": result.expected,
        "observed": result.observed,
        "reason": result.reason,
    }


def main(arguments: Sequence[str] | None = None) -> int:
    """Run qualification checks and return the process exit code."""

    parser = build_parser()
    parsed_arguments = parser.parse_args(arguments)

    minimum_major, minimum_minor = parsed_arguments.min_python

    result = check_python_version(
        minimum_major=minimum_major,
        minimum_minor=minimum_minor,
    )

    print(
        json.dumps(
            result_to_dictionary(result),
            indent=2,
        )
    )

    if result.status is CheckStatus.PASSED:
        return 0

    return 1
