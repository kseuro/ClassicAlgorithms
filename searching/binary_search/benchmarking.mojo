import benchmark
from python import Python


@always_inline
fn bench[
    func: fn (inout List[Int], Int) -> Int
](inout arr: List[Int], key: Int, name: String) raises:
    """Benchmarking function."""
    print("Benchmarking")

    @always_inline
    @parameter
    fn test_fn():
        _ = func(arr, key)

    var seconds = benchmark.run[test_fn](max_runtime_secs=10).mean()

    var py = Python.import_module("builtins")
    _ = py.print(py.str("{:<13} {:>9.10f} Seconds").format(name, seconds))


fn verify_behaviour[
    func: fn (inout List[Int], Int) -> Int,
    name: String,
]() raises:
    """Verifies that the binary searcg algorithm performs as expected."""
    print("...verifying behaviour:", name)

    # Array in sorted order
    var arr = List[Int]()
    for i in range(100):
        arr.append(i)

    # Keys that we want to find and corresponding correct search values
    var keys = List[Int](0, 1, 10, 27, 80, 90, 105, -10)
    var expected = List[Int](0, 1, 10, 27, 80, 90, -1, -1)

    var expected_simd = SIMD[DType.int8, 8]()
    var results = SIMD[DType.int8, 8]()
    for i in range(len(keys)):
        expected_simd[i] = expected[i]
        results[i] = func(arr, keys[i])

    var check = (abs(results) - abs(expected_simd)).reduce_add()
    if check == 0:
        print("Search algorithm is working correctly")
    else:
        print("Search algorithm not working correctly")
        print("Results: ", results)
        print("Expected: ", expected_simd)
