"""Defines the Rosenbrock function and it's gradient, and the gradient descent function.

See: https://www.modular.com/blog/whats-new-in-mojo-24-3-community-contributions-pythonic-collections-and-core-language-enhancements
"""

from python import Python
from testing import assert_true

alias myFloat = Float64


fn import_numpy() raises -> PythonObject:
    return Python.import_module("numpy")


fn import_plt() raises -> PythonObject:
    return Python.import_module("matplotlib.pyplot")


fn my_random_float() raises -> myFloat:
    var np = import_numpy()
    return np.random.uniform(-1, 1, 1).to_float64()


fn rosenbrock(x: myFloat, y: myFloat) -> myFloat:
    """Rosenbrock function with a = 1 and b = 100."""
    return (1 - x) ** 2 + 100 * (y - x**2) ** 2


fn rosenbrock_gradient(x: myFloat, y: myFloat) -> Tuple[myFloat, myFloat]:
    var dx = -2 * (1 - x) - 400 * x * (y - x**2)
    var dy = 200 * (y - x**2)
    return (dx, dy)  # Return as a tuple


fn rosenbrock_meshgrid() raises -> Tuple[myFloat, myFloat, myFloat]:
    var np = Python.import_module("numpy")
    var x = np.linspace(-2, 2, 100)
    var y = np.linspace(-1, 3, 100)
    var grid = np.meshgrid(x, y)
    var X = grid[0].to_float64()
    var Y = grid[1].to_float64()
    var Z = rosenbrock(X, Y)
    return (X, Y, Z)


fn rosenbrock_gradient_descent(
    params: Dict[String, myFloat]
) raises -> List[(myFloat, myFloat, myFloat)]:
    assert_true(params, "Optimization parameters are empty")

    var x = params["initial_x"]
    var y = params["initial_y"]

    var history = List[(myFloat, myFloat, myFloat)]()
    history.append((x, y, rosenbrock(x, y)))
    for _ in range(params["num_iterations"]):
        var grad = rosenbrock_gradient(x, y)
        x -= params["learning_rate"] * grad[0]
        y -= params["learning_rate"] * grad[1]
        var fx = rosenbrock(x, y)
        history.append((x, y, fx))
    return history


fn convert_history_to_numpy(
    history: List[(myFloat, myFloat, myFloat)]
) raises -> PythonObject:
    """Converts the mojo list of tuples to a numpy array."""
    var np = import_numpy()
    var np_arr1 = np.empty((len(history), 3))
    for i in range(len(history)):
        np_arr1[i] = history[i]
    return np_arr1


fn get_python_plot_module() raises -> PythonObject:
    """Sets a relative path to the CWD to import the python plot file."""
    var pathlib = Python.import_module("pathlib")
    Python.add_to_path(pathlib.Path().cwd())
    return Python.import_module("plot")
