import pathlib
from python import Python


fn main() raises -> None:
    Python.add_to_path(str(pathlib.Path()))
    var matmul_python = Python.import_module("matmul_python")

    print("Benchmarking Python matrix multiplication")
    var python_gflops = matmul_python.benchmark_matmul_python(128, 128, 128)

    # TODO: Implement MatMul using Mojo
