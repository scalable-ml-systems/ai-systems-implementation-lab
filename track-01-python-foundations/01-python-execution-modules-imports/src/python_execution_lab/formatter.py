"""Message formatting functions."""


def format_message(name: str) -> str:
    """Return a formatted confirmation message."""
    normalized_name = name.strip()

    if not normalized_name:
        raise ValueError("name must not be empty")

    return f"Hello, {normalized_name}. The package import succeeded."
