"""Iterative implementation of the binary search algorithm."""

from pathlib import Path
from python import Python

alias max_length = 1000


fn BinSearch(arr: List[Int], key: Int) -> Int:
    """Performs a binary search on the given sorted array for the given key.

    Args:
        arr: List[Int] The sorted array to search in.
        key: Int The key to search for.

    Returns:
        Int: The index of the key in the array if found, otherwise -1.
    """

    var low = 1
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
    var arr = List[Int]()
    for i in range(max_length):
        arr.append(i)

    var np = Python.import_module("numpy")
    var np_keys = np.random.randint(0, max_length, 10)
    var mojo_keys = List[Int]()
    for i in range(len(np_keys)):
        mojo_keys.append(np_keys[i])

    # Append keys that are not in the index
    mojo_keys.append(12000)
    mojo_keys.append(-10)

    print("Searching array for: ")
    for key in mojo_keys:
        print("Key: ", key[])
        var index = BinSearch(arr, key[])
        print("Index: ", index)
