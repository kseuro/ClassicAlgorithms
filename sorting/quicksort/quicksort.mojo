"""Defines the quicksort algorithm.

Quicksort is a divide-and-conquer algorithm that reduces the problem of
sorting a list of elements into smaller sub-problems.
"""
import random
from python import Python
from helpers import import_numpy, print_list
from benchmarking import verify_behaviour, bench
from test_list import TestList, generate_TestList

alias type = Int
alias max_len = 100
alias max_size = 10_000
alias step_size = 1000
alias start_size = 1000


fn swap(inout arr: List[Int], borrowed i: Int, borrowed j: Int) -> None:
    """Swap position i with position j."""
    var tmp = arr[i]
    arr[i] = arr[j]
    arr[j] = tmp


fn partition(inout array: List[Int], start: Int, end: Int) -> Int:
    var i: Int = start
    var j: Int = end
    var pivot: Int = array[start]  # Use front value as the inital pivot
    while i < j:
        while array[i] <= pivot:
            i += 1
        while array[j] > pivot:
            j -= 1
        if i < j:
            swap(array, i, j)
    swap(array, start, j)
    return j


fn quicksort(inout array: List[type], start: Int, end: Int) -> None:
    if len(array[start:end]) < 2:
        return
    if start < end:
        var partition_index = partition(array, start, end)
        quicksort(
            array, start, partition_index - 1
        )  # sort items left of the pivot
        quicksort(
            array, partition_index + 1, end
        )  # sort items right of the pivot


fn main() raises -> None:
    print("Running Quicksort")
    verify_behaviour[quicksort, 8, "quicksort"]()

    var np = Python.import_module("numpy")
    for size in range(start_size, max_size, step_size):
        var list = np.random.randint(0, max_len, size)
        var mojo_list = List[Int]()
        for i in range(len(list)):
            mojo_list.append(list[i])
        bench[quicksort](mojo_list, "random_ints", 0, len(mojo_list))
