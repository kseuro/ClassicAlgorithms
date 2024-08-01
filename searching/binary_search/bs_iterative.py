import numpy as np
from timeit import timeit

max_length = 10_000_000
n_keys = 10
name = "Iterative BinSearch Python"


def benchmarch_binsearch_python() -> float:
    """
    Benchmarks the performance of the iterative binary search algorithm in Python.

    This function generates a random key and a sorted list of integers, and then
    measures the time taken to perform a binary search for the key in the list using
    the `BinSearch` function. The `BinSearch` function is called twice, and the
    average time taken is returned.

    Parameters:
        None

    Returns:
        float: The average time taken to perform the binary search in seconds.

    """
    key = list(np.random.randint(0, max_length, 1))[0]
    arr = [i for i in range(max_length)]

    seconds = timeit(lambda: BinSearch(arr, key, name), number=2)
    return seconds


def verify_behaviour() -> None:
    """
    Verify the behavior of the binary search algorithm by performing
    a search for a randomly generated key in a sorted list of integers.

    This function generates a random key and a sorted list of integers using
    the `numpy.random.randint` function. It then calls the `BinSearch` function with
    the generated key and the sorted list to find the index of the key in the list.
    The index is then used to print the key and the corresponding value from the list.

    Parameters:
        None

    Returns:
        None
    """
    key = list(np.random.randint(0, max_length, 1))[0]
    arr = [i for i in range(max_length)]

    index = BinSearch(arr, key, name)
    print(f"Searched for {key} in array and found {arr[index]}")


def BinSearch(arr: list[int], key: str, name: str) -> int:
    """
    Performs an iterative binary search on a sorted list of integers to find the index of a given key.

    Args:
        arr (list[int]): The sorted list of integers to search in.
        key (str): The key to search for.
        name (str): The name of the search algorithm.

    Returns:
        int: The index of the key in the list if found, otherwise -1.
    """
    low = 0
    high = len(arr)

    while low <= high:
        mid = (low + high) // 2

        if arr[mid] == key:
            return mid

        if key < arr[mid]:
            high = mid - 1
        else:
            low = mid + 1
    return -1


def main():
    verify_behaviour()
    seconds = benchmarch_binsearch_python()
    print(f"Python BinSearch searched {max_length} values in {seconds:.5f} seconds.")


if __name__ == "__main__":
    main()
