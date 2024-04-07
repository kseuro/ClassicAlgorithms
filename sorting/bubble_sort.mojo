"""Defines the bubble sort algorithm.

Bubble sort is a simple algorithm that steps through a collection of elements
one at a time, compares each one, and performs a swap operation if needed.
"""


def print_list(l: List[Int], name: String):
    print(name, "[", sep=": ", end=" ")
    for i in range(len(l)):
        print(l[i], end=" ")
    print("]", end="\n")


fn main() raises -> None:
    print("Running Bubble Sort")

    var case1_unsorted = List[Int](5, 1, 4, 2, 8)
    var case1_sorted = List[Int](1, 2, 4, 5, 8)

    print("\nCase 1:")
    print_list(case1_unsorted, name="Start")

    var list_to_sort = case1_unsorted
    var swapped: Bool = True
    while swapped:
        swapped = False
        for i in range(len(list_to_sort) - 1):
            if list_to_sort[i] > list_to_sort[i + 1]:
                var tmp: Int = list_to_sort[i]
                list_to_sort[i] = list_to_sort[i + 1]
                list_to_sort[i + 1] = tmp
                swapped = True

    print_list(list_to_sort, name="Sorted")
    print_list(case1_sorted, name="Reference")
