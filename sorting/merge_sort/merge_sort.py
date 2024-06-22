"""Python implementation of merge sort for comparison with Mojo implementation."""

import numpy as np
from timeit import timeit


def merge_sort(array):
    """
    Recursively sorts an array using the merge sort algorithm.

    Parameters:
    - array: a list of comparable elements to be sorted.

    Returns:
    None
    """
    if len(array) > 1:
        middle = int(len(array) / 2)
        left = array[:middle]
        right = array[middle:]

        merge_sort(left)
        merge_sort(right)

        i = j = k = 0
        while i < len(left) and j < len(right):
            if left[i] < right[j]:
                array[k] = left[i]
                i += 1
            else:
                array[k] = right[j]
                j += 1
            k += 1

        while i < len(left):
            array[k] = left[i]
            i += 1
            k += 1

        while j < len(right):
            array[k] = right[j]
            j += 1
            k += 1


def benchmark(size: int):
    """
    Benchmark the performance of the merge_sort function by sorting an array of random integers.

    This function generates a random array of integers using numpy's random.randint function,
    sorts it using the merge_sort function, and then measures the time it takes to sort the array.
    The function prints the size of the array and the time it took to sort it in seconds.

    Parameters:
        size (int): The number of elements in the array to be sorted.

    Returns:
        None

    Example:
        >>> benchmark(1000)
        1000 elements in 0.000535 Seconds
    """

    array = np.random.randint(0, 1000, size=size)
    seconds = timeit(lambda: merge_sort(array), number=2)
    print(f"{size} elements in {seconds:.5f} Seconds")

    gflops = ((2 * size) / seconds) / 1e9
    print(f"{gflops:.5f} GFLOPS")


def verify_behaviour():
    array = [70, 50, 30, 10, 20, 40, 60]
    merge_sort(array)
    print("Results of sorting test array:")
    print(*array, sep=" ")
    print("\n")


def main():
    """Driver function."""
    print("Benchmarking Merge Sort")
    verify_behaviour()
    benchmark(10_000)
    benchmark(100_000)
    benchmark(1_000_000)


if __name__ == "__main__":
    main()
