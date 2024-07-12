"""Iterative implementation of the binary search algorithm."""

from pathlib import Path
from python import Python
from benchmarking import verify_behaviour, bench

alias max_length = 10_000_000
alias n_keys = 10
alias name = "Iterative BinSearch"


fn BinSearch(inout arr: List[Int], key: Int) -> Int:
    """Performs a binary search on the given sorted array for the given key.

    Args:
        arr: List[Int] The sorted array to search in.
        key: Int The key to search for.

    Returns:
        Int: The index of the key in the array if found, otherwise -1.
    """

    var low = 0
    var high = len(arr)

    while low <= high:
        var mid = (low + high) // 2

        if arr[mid] == key:
            return mid

        if key < arr[mid]:
            high = mid - 1
        else:
            low = mid + 1
    return -1


fn main() raises -> None:
    verify_behaviour[BinSearch, name]()

    var arr = List[Int]()
    for i in range(max_length):
        arr.append(i)

    # Get n random keys to search for in the sorted array
    var np = Python.import_module("numpy")
    var np_keys = np.random.randint(0, max_length, n_keys)
    var keys = List[Int]()
    for i in range(len(np_keys)):
        keys.append(np_keys[i])

    # Test cases: append keys that will not be in the sorted list
    keys.append(12000)  # Some very large value
    keys.append(-10)  # Some negative value

    for key in keys:
        bench[BinSearch](arr, key[], name)
