"""Defines the merge sort algorithm.

Merge sort is an efficient divide-and-conquer sorting algorithm that
has O(nlogn) runtime in the best, worst, and average case, which
makes it good for use with very large datasets.
"""


fn print_list(l: List[Int]) -> None:
    print("")
    for i in range(len(l)):
        print(l[i])
    print("")


fn main() raises -> None:
    var odd = List[Int](1, 3, 5, 7, 9, 11, 13, 15, 17, 19, 21)
    var even = List[Int](2, 4, 6, 8, 10)
    var result = List[Int]()

    var o = 0  # pointer to values in the odd list
    var e = 0  # pointer to values in the even list

    print("Starting")
    while o < len(odd) and e < len(even):
        while odd[o] < even[e] and o < len(odd):
            print("o", o)
            result.append(odd[o])
            o += 1
        while even[e] < odd[o] and e < len(even):
            print("e", e)
            result.append(even[e])
            e += 1

    if o < len(odd):
        print("Appending remaining odd items")
        while o < len(odd):
            result.append(odd[o])
            o += 1

    if e < len(even):
        print("Appending remaining even items")
        while e < len(even):
            result.append(even[e])
            e += 1

    print("Result")
    print_list(result)
