import pathlib
import benchmark
from algorithm import vectorize, parallelize
from algorithm import Static2DTileUnitFunc as Tile2DFunc
from random import rand, random_float64
from python import Python

alias type = DType.float32
alias nelts = simdwidthof[type]() * 2
alias M = 512
alias N = 512
alias K = 512


@always_inline
fn bench[func: fn (Matrix, Matrix, Matrix) -> None](base_gflops: Float64):
    var C = Matrix[M, N]()
    var A = Matrix[M, N].rand()
    var B = Matrix[M, N].rand()

    @always_inline
    @parameter
    fn test_fn():
        _ = func(C, A, B)

    var seconds = benchmark.run[test_fn](max_runtime_secs=1).mean()

    A.data.free()
    B.data.free()
    C.data.free()

    var gflops = ((2 * M * N * K) / seconds) / 1e9
    var speedup: Float64 = gflops / base_gflops

    print(M, "x", N, "x", K)
    print("Seconds: ", seconds)
    print(gflops, "GFLOP/s, a", speedup, "x speedup over Python")


struct Matrix[rows: Int, cols: Int]:
    var data: DTypePointer[type]

    # Zero init
    fn __init__(inout self):
        self.data = DTypePointer[type].alloc(rows * cols)
        memset_zero(self.data, rows * cols)

    # Init with pointer, no data
    fn __init__(inout self, data: DTypePointer[type]):
        self.data = data

    # Init with random values
    @staticmethod
    fn rand() -> Self:
        var data = DTypePointer[type].alloc(rows * cols)
        rand(data, rows * cols)
        return Self(data)

    fn __getitem__(self, y: Int, x: Int) -> Scalar[type]:
        return self.load[1](y, x)

    fn __setitem__(self, y: Int, x: Int, val: Scalar[type]):
        self.store[1](y, x, val)

    fn load[nelts: Int](self, y: Int, x: Int) -> SIMD[type, nelts]:
        return self.data.load[width=nelts](y * self.cols + x)

    fn store[nelts: Int](self, y: Int, x: Int, val: SIMD[type, nelts]):
        return self.data.store[width=nelts](y * self.cols + x, val)


fn matmul_naive(C: Matrix, A: Matrix, B: Matrix):
    for m in range(C.rows):
        for k in range(A.cols):
            for n in range(C.cols):
                C[m, n] += A[m, k] * B[k, n]


fn matmul_vectorized(C: Matrix, A: Matrix, B: Matrix):
    for m in range(C.rows):
        for k in range(A.cols):

            @parameter
            fn dot[nelts: Int](n: Int):
                C.store(
                    m, n, C.load[nelts](m, n) + A[m, k] * B.load[nelts](k, n)
                )

            vectorize[dot, nelts, size = C.cols]()


fn matmul_parallelized(C: Matrix, A: Matrix, B: Matrix):
    @parameter
    fn calc_row(m: Int):
        for k in range(A.cols):

            @parameter
            fn dot[nelts: Int](n: Int):
                C.store[nelts](
                    m, n, C.load[nelts](m, n) + A[m, k] * B.load[nelts](k, n)
                )

            vectorize[dot, nelts, size = C.cols]()

    parallelize[calc_row](C.rows, C.rows)


fn tile[tiled_fn: Tile2DFunc, tile_x: Int, tile_y: Int](end_x: Int, end_y: Int):
    for y in range(0, end_y, tile_y):
        for x in range(0, end_x, tile_x):
            tiled_fn[tile_x, tile_y](x, y)


fn matmul_tiled_unrolled_parallelized(C: Matrix, A: Matrix, B: Matrix):
    @parameter
    fn calc_row(m: Int):
        @parameter
        fn calc_tile[tile_x: Int, tile_y: Int](x: Int, y: Int):
            for k in range(y, y + tile_y):

                @parameter
                fn dot[nelts: Int](n: Int):
                    C.store(
                        m,
                        n + x,
                        C.load[nelts](m, n + x)
                        + A[m, k] * B.load[nelts](k, n + x),
                    )

                # Vectorize by nelts and unroll by tile_x/nelts
                # Here unroll factor is 4
                alias unroll_factor = tile_x // nelts
                vectorize[
                    dot, nelts, size=tile_x, unroll_factor=unroll_factor
                ]()

        alias tile_size = 4
        tile[calc_tile, nelts * tile_size, tile_size](A.cols, C.cols)

    parallelize[calc_row](C.rows, C.rows)


fn main() raises -> None:
    Python.add_to_path(str(pathlib.Path() / "matrix_multiplication"))
    var matmul_python = Python.import_module("matmul_python")

    print("Benchmarking Python matrix multiplication")
    var python_gflops = matmul_python.benchmark_matmul_python(
        128, 128, 128
    ).to_float64()

    print("Benchmarking Mojo matrix multiplication")
    bench[matmul_naive](python_gflops)
    bench[matmul_vectorized](python_gflops)
    bench[matmul_parallelized](python_gflops)
    bench[matmul_tiled_unrolled_parallelized](python_gflops)
