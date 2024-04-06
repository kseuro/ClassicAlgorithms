"""Defines the bubble sort algorithm."""


def print_list(l: List[Int], name: String):
    print(name, "[", sep=": ", end=" ")
    for i in range(len(l)):
        print(l[i], end=" ")
    print("]", end="\n")


fn main() raises -> None:
    print("Running Bubble Sort")

    var case1_unsorted = List[Int](5, 1, 4, 2, 8)
    var case1_sorted = List[Int](1, 2, 3, 4, 5)

    print("\nCase 1:")
    print_list(case1_unsorted, name="unsorted")
    print_list(case1_sorted, name="reference")
