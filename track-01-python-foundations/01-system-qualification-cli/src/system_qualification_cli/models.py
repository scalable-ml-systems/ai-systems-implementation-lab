"""Shared result models for qualification checks."""

from dataclasses import dataclass
from enum import Enum


class CheckStatus(str, Enum):
    """Supported outcomes for a qualification check."""

    PASSED = "PASSED"
    FAILED = "FAILED"


@dataclass(frozen=True, slots=True)
class QualificationResult:
    """Structured evidence produced by one qualification check."""

    name: str
    status: CheckStatus
    expected: str
    observed: str
    reason: str | None = None
