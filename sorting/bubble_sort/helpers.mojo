"""Defines a set of utility and helper functions."""

from python import Python


def print_list(l: List[Int], name: String):
    print(name, "[", sep=": ", end=" ")
    for i in range(len(l)):
        print(l[i], end=" ")
    print("]", end="\n")


def import_numpy() -> PythonObject:
    var np = Python.import_module("numpy")
    return np
