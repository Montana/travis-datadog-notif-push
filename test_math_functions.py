import pytest
from math_functions import add

def test_add():
    """Test case for the add function."""
    assert add(2, 3) == 5, "Should be 5"
    assert add(5, -3) == 2, "Should be 2"
    assert add(0, 0) == 0, "Should be 0"
    assert add(-1, -1) == -2, "Should be -2"
