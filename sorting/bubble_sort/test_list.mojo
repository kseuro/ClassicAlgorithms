"""Defines the TestList struct and helper functions for use with various sorting algorithms."""

alias type = Int


struct TestList:
    """Defines two lists of ints - the list to sort and the list to check against.
    """

    var unsorted: List[type]
    var sorted: List[type]

    fn __init__(inout self, unsorted: List[type], sorted: List[type]):
        self.unsorted = unsorted
        self.sorted = sorted


fn generate_TestList(np: PythonObject, size: Int) raises -> TestList:
    """Uses numpy to init a TestList struct using a list of random integers."""
    var unsorted_np = np.random.randint(low=0, high=100, size=size)
    var sorted_np = np.sort(unsorted_np)

    # Convert the PythonObjects to Mojo lists
    var unsorted = List[type]()
    var sorted = List[type]()

    for item in unsorted_np:
        unsorted.append(int(item))
    for item in sorted_np:
        sorted.append(int(item))

    return TestList(unsorted, sorted)
