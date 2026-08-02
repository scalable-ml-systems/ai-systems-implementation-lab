import pytest

from python_execution_lab.formatter import format_message

def test_fromat_message_returns_expected_message() -> None:
    result = format_message("Nancy")

    assert result == "Hello, Nancy. The package import succeeded."

def test_format_message_strips_surrounding_whitespace() -> None:
    result = format_message("  Nancy  ")

    assert result == "Hello, Nancy. The package import succeeded."

def test_format_message_rejects_empty_name() -> None:
    with pytest.raises(ValueError, match="name must not be empty"):
        format_message("   ")
