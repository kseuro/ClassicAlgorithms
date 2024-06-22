"""Defines the merge sort algorithm.

Merge sort is an efficient divide-and-conquer sorting algorithm that
has O(nlogn) runtime in the best, worst, and average case, which
makes it good for use with very large datasets.
"""

import benchmark
from python import Python
from random import random_si64


fn print_list(l: List[Int]) -> None:
    print("")
    for i in range(len(l)):
        print(l[i], end=" ")
    print("")


fn merge_sort(inout unsorted_array: List[Int]):
    if len(unsorted_array) > 1:
        # Get the middle and divide the array
        var middle = int(len(unsorted_array) / 2)
        var left = unsorted_array[:middle]
        var right = unsorted_array[middle:]

        merge_sort(left)
        merge_sort(right)

        var i = 0
        var j = 0
        var k = 0

        while i < len(left) and j < len(right):
            if left[i] < right[j]:
                unsorted_array[k] = left[i]
                i += 1
            else:
                unsorted_array[k] = right[j]
                j += 1
            k += 1

        while i < len(left):
            unsorted_array[k] = left[i]
            i += 1
            k += 1

        while j < len(right):
            unsorted_array[k] = right[j]
            j += 1
            k += 1


@always_inline
fn bench[
    func: fn (inout List[Int]) -> None, size: Int, python_gflops: Float32
]() raises:
    """Benchmarking function."""

    var target_array = List[Int]()
    for _ in range(size):
        target_array.append(int(random_si64(0, size)))

    @always_inline
    @parameter
    fn test_fn():
        func(target_array)

    var seconds = benchmark.run[test_fn](max_runtime_secs=10).mean()
    var gflops = ((2 * size) / seconds) / 1e9
    var py = Python.import_module("builtins")
    _ = py.print(
        py.str("{} {} elements in {:.5f} Seconds at {:>.5f} GFlops").format(
            "Sorted:", len(target_array), seconds, gflops
        )
    )
    var speedup: Float32 = gflops / python_gflops
    _ = py.print(py.str("Speedup: {:.5f}x faster than Python").format(speedup))


def verify_behaviour() -> None:
    var test_array = List[Int](70, 50, 30, 10, 20, 40, 60)
    merge_sort(test_array)
    print("Results of sorting test array:")
    print_list(test_array)


fn main() raises -> None:
    """Driver function."""
    print("Benchmarking Merge Sort")
    verify_behaviour()

    bench[merge_sort, 10_000, 0.00041]()
    bench[merge_sort, 100_000, 0.00035]()
    bench[merge_sort, 1_000_000, 0.00030]()
