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


fn quicksort(inout array: List[type], start: Int, end: Int) raises -> None:
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

    var np: PythonObject = import_numpy()
    verify_behaviour[quicksort, 8, "quicksort"](np)
