"""Defines general benchmarking functionality for testing sorting algorithms."""

import benchmark
from python import Python
from test_list import TestList, generate_TestList
from helpers import print_list

alias type = Int


@always_inline
fn bench[
    func: fn (inout List[Int], Int, Int) -> None
](inout unsorted_list: List[Int], name: String, start: Int, end: Int,) raises:
    """Benchmarking function."""
    # Setup everything required to run the sorting algorithm
    print("Benchmarking")

    @always_inline
    @parameter
    fn test_fn():
        _ = func(unsorted_list, start, end)

    var seconds = benchmark.run[test_fn](max_runtime_secs=10).mean()

    var py = Python.import_module("builtins")
    _ = py.print(
        py.str("{:<13} Size: {:>2} {:>9.5f} Seconds").format(
            name, len(unsorted_list), seconds
        )
    )


fn verify_behaviour[
    func: fn (inout List[Int], Int, Int) -> None,
    size: Int,
    name: String,
]() raises:
    """Verifies that the sorting algorithm performs as expected."""
    print("...verifying behaviour:", name)

    var array = List(10, 16, 17, 8, 12, 17, 15, 6, 3, 9, 19, 234)
    var sorted = List(3, 6, 8, 9, 10, 12, 15, 16, 17, 17, 19, 234)
    func(array, 0, len(array) - 1)

    # If the list is correctly sorted, then the vector difference
    # followed by sum should be zero, no matter the starting list.
    var x = SIMD[DType.int8, size]()
    var y = SIMD[DType.int8, size]()
    for i in range(size):
        x[i] = sorted[i]
        y[i] = array[i]
    var z = (x - y).reduce_add()
    if z == 0:
        print(name, " correctly sorted the test list.")
    else:
        print(name, " did not correctly sort the test list.")
        print_list(sorted, "sorted")
        print_list(array, "unsorted")
