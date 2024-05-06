"""Defines the bubble sort algorithm.

Bubble sort is a simple algorithm that steps through a collection of elements
one at a time, compares each one, and performs a swap operation if needed.
"""

import benchmark
from python import Python

alias type = Int


struct TestList:
    """Defines two lists of ints - the list to sort and the list to check against.
    """

    var unsorted: List[type]
    var sorted: List[type]

    fn __init__(inout self, unsorted: List[type], sorted: List[type]):
        self.unsorted = unsorted
        self.sorted = sorted


fn generate_TestList(np: PythonObject, size: Int) raises -> TestList:
    """Uses numpy to init a TestList struct using a list of random integers."""
    var unsorted_np = np.random.randint(low=0, high=100, size=size)
    var sorted_np = np.sort(unsorted_np)

    # Convert the PythonObjects to Mojo lists
    var unsorted = List[type]()
    var sorted = List[type]()

    for item in unsorted_np:
        unsorted.append(int(item))
    for item in sorted_np:
        sorted.append(int(item))

    return TestList(unsorted, sorted)


def print_list(l: List[Int], name: String):
    print(name, "[", sep=": ", end=" ")
    for i in range(len(l)):
        print(l[i], end=" ")
    print("]", end="\n")


def import_numpy() -> PythonObject:
    var np = Python.import_module("numpy")
    return np


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


fn verify_behaviour[
    func: fn (TestList) -> List[type], size: Int, name: String
](np: PythonObject) raises:
    """Verifies that the sorting algorithm performs as expected."""
    print("...verifying behaviour:", name)

    var test_list = generate_TestList(np, size)
    var result = func(test_list)

    # If the list is correctly sorted, then the vector difference
    # followed by sum should be zero, no matter the starting list.
    var x = SIMD[DType.int8, size]()
    var y = SIMD[DType.int8, size]()
    for i in range(size):
        x[i] = test_list.sorted[i]
        y[i] = result[i]
    var z = (x - y).reduce_add()
    if z == 0:
        print(name, " correctly sorted the test list.")
    else:
        print(name, " did not correctly sort the test list.")
        print("z:", z)


@always_inline
fn bench[
    func: fn (TestList) -> List[type]
](np: PythonObject, size: Int, name: String) raises:
    """Benchmarking function."""
    # Setup everything required to run the sorting algorithm
    var test_list = generate_TestList(np, size)

    @always_inline
    @parameter
    fn test_fn():
        var result = func(test_list)

    var seconds = benchmark.run[test_fn](max_runtime_secs=10).mean()

    var py = Python.import_module("builtins")
    _ = py.print(
        py.str("{:<13} Size: {:>2} {:>9.5f} Seconds").format(
            name, size, seconds
        )
    )


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
