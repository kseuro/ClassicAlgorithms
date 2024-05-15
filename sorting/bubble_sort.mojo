"""Defines the bubble sort algorithm.

Bubble sort is a simple algorithm that steps through a collection of elements
one at a time, compares each one, and performs a swap operation if needed.
"""

from helpers import import_numpy
from benchmarking import bench, verify_behaviour
from test_list import TestList, generate_TestList

alias type = Int


fn swap(inout l: List[type], borrowed i: Int):
    var tmp = l[i]
    l[i] = l[i + 1]
    l[i + 1] = tmp


fn bubble_sort(test_list: TestList) -> List[type]:
    """Runs the bubble sort algorithm on a TestList struct."""
    var list_to_sort = test_list.unsorted
    var swapped: Bool = True
    while swapped:
        swapped = False
        for i in range(len(list_to_sort) - 1):
            if list_to_sort[i] > list_to_sort[i + 1]:
                swap(list_to_sort, i)
                swapped = True
    return list_to_sort


fn cocktail_shaker_sort(test_list: TestList) -> List[type]:
    """Runs the cocktail shaker sort algorithm on a TestList struct."""
    var list_to_sort = test_list.unsorted
    var swapped: Bool = True
    while swapped:
        swapped = False
        for i in range(len(list_to_sort) - 1):
            if list_to_sort[i] > list_to_sort[i + 1]:
                swap(list_to_sort, i)
                swapped = True
        if not swapped:
            return list_to_sort
        swapped = False
        for i in range(len(list_to_sort) - 1, 0, -1):
            if list_to_sort[i] > list_to_sort[i + 1]:
                swap(list_to_sort, i)
                swapped = True
        swapped = False
    return list_to_sort


fn main() raises -> None:
    print("Running bubble sort and its variants")
    var np: PythonObject = import_numpy()

    # Basic bubble sort algorithm
    verify_behaviour[bubble_sort, 64, "bubble_sort"](np)
    for size in range(10000, 50000, 15000):
        bench[bubble_sort](np, size=size, name="bubble_sort")

    verify_behaviour[cocktail_shaker_sort, 64, "cocktail_shaker_sort"](np)
    for size in range(10000, 50000, 15000):
        bench[cocktail_shaker_sort](np, size=size, name="cocktail_shaker_sort")
