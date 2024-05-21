"""Defines general benchmarking functionality for testing sorting algorithms."""

import benchmark
from python import Python
from test_list import TestList, generate_TestList

alias type = Int


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
