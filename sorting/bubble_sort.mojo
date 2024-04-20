"""Defines the bubble sort algorithm.

Bubble sort is a simple algorithm that steps through a collection of elements
one at a time, compares each one, and performs a swap operation if needed.
"""

import benchmark
from python import Python


struct TestList:
    """Defines two lists of ints - the list to sort and the list to check against."""

    var unsorted: List[Int]
    var sorted: List[Int]

    fn __init__(inout self, unsorted: List[Int], sorted: List[Int]):
        self.unsorted = unsorted
        self.sorted = sorted


fn generate_TestList(np: PythonObject, size: Int) raises -> TestList:
    """Uses numpy to init a TestList struct using a list of random integers."""
    var unsorted_np = np.random.randint(low=0, high=100, size=size)
    var sorted_np = np.sort(unsorted_np)

    # Convert the PythonObjects to Mojo lists
    var unsorted = List[Int]()
    var sorted = List[Int]()

    for item in unsorted_np:
        unsorted.append(item.to_float64().to_int())
    for item in sorted_np:
        sorted.append(item.to_float64().to_int())

    return TestList(unsorted, sorted)


def print_list(l: List[Int], name: String):
    print(name, "[", sep=": ", end=" ")
    for i in range(len(l)):
        print(l[i], end=" ")
    print("]", end="\n")


def import_numpy() -> PythonObject:
    var np = Python.import_module("numpy")
    return np


fn bubble_sort(test_list: TestList) -> List[Int]:
    """Runs the bubble sort algorithm on a TestList struct."""
    var list_to_sort = test_list.unsorted
    var swapped: Bool = True
    while swapped:
        swapped = False
        for i in range(len(list_to_sort) - 1):
            if list_to_sort[i] > list_to_sort[i + 1]:
                var tmp: Int = list_to_sort[i]
                list_to_sort[i] = list_to_sort[i + 1]
                list_to_sort[i + 1] = tmp
                swapped = True
    return list_to_sort


@always_inline
fn bench[
    func: fn (TestList) -> List[Int]
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
        py.str("{:<13} Size: {:>2} {:>9.5f} Seconds").format(name, size, seconds)
    )


fn main() raises -> None:
    print("Running Bubble Sort")
    var np: PythonObject = import_numpy()
    bench[bubble_sort](np, size=1000, name="bubble_sort")
    bench[bubble_sort](np, size=10000, name="bubble_sort")
