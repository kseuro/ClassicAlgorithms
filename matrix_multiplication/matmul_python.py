"""Basic matrix multiplication algorithm."""

import numpy as np
from timeit import timeit


class Matrix:

    def __init__(self, value: np.ndarray, rows: int, columns: int):
        self.value = value
        self.rows = rows
        self.columns = columns

    def __repr__(self):
        return str(self.value)

    def __getitem__(self, idxs: tuple[int, int]):
        return self.value[idxs[0]][idxs[1]]

    def __setitem__(self, idxs: tuple[int, int], value: int):
        self.value[idxs[0]][idxs[1]] = value


def matmul(C: Matrix, A: Matrix, B: Matrix):
    """Basic matrix multiplication algorithm."""
    for i in range(C.rows):
        for j in range(C.columns):
            for k in range(A.columns):
                C[i, j] += A[i, k] * B[k, j]


def benchmark_matmul_python(M: int, N: int, K: int) -> float:
    """Benchmark the performance of the matmul function."""

    A = Matrix(np.random.rand(M, K), M, K)
    B = Matrix(np.random.rand(K, N), K, N)
    C = Matrix(np.zeros((M, N)), M, N)

    seconds = timeit(lambda: matmul(C, A, B), number=2)
    print(f"{M}x{N}x{K} matrix multiplication took {seconds:.5f} seconds")

    gflops = ((M * N * K) / seconds) / 1e9
    print(f"{gflops:.5f} GFLOPS\n")

    return gflops
