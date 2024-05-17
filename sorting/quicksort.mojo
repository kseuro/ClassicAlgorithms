"""Defines the quicksort algorithm.

Quicksort is a divide-and-conquer algorithm that reduces the problem of
sorting a list of elements into smaller sub-problems.
"""
from helpers import import_numpy, print_list
from benchmarking import bench, verify_behaviour
from test_list import TestList, generate_TestList

alias type = Int


fn swap(inout l: List[Int], borrowed i: Int) -> None:
    var tmp = l[i]
    l[i] = l[i + 1]
    l[i + 1] = tmp


fn partition(array: List[Int], start: Int, end: Int) -> Int:
    return -1


fn quicksort(array: List[type], start: Int, end: Int) -> None:
    if start < end:
        var pIndex: Int = partition(array, start, end)
        quicksort(array, start, pIndex - 1)
        quicksort(array, pIndex + 1, end)


fn main() raises -> None:
    print("Running Quicksort")

    var np: PythonObject = import_numpy()

    var test_list: TestList = generate_TestList(np, size=10)
    print_list(test_list.unsorted, "test_list")
