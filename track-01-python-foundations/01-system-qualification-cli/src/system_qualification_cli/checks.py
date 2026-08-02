"""System qualification checks."""

import sys

from system_qualification_cli.models import (
    CheckStatus,
    QualificationResult,
)


def check_python_version(
    minimum_major: int,
    minimum_minor: int,
) -> QualificationResult:
    """Determine whether the running Python version meets the requirement."""

    required_version = (minimum_major, minimum_minor)
    observed_version = (sys.version_info.major, sys.version_info.minor)

    passed = observed_version >= required_version

    required_text = f">={minimum_major}.{minimum_minor}"
    observed_text = f"{observed_version[0]}.{observed_version[1]}"

    if passed:
        return QualificationResult(
            name="python_version",
            status=CheckStatus.PASSED,
            expected=required_text,
            observed=observed_text,
        )

    return QualificationResult(
        name="python_version",
        status=CheckStatus.FAILED,
        expected=required_text,
        observed=observed_text,
        reason=(
            f"Python {observed_text} does not satisfy "
            f"the minimum version {required_text}."
        ),
    )
