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


fn rosenbrock(x: myFloat, y: myFloat) -> myFloat:
    return (1 - x) ** 2 + 100 * (y - x**2) ** 2


fn rosenbrock_gradient(x: myFloat, y: myFloat) -> Tuple[myFloat, myFloat]:
    var dx = -2 * (1 - x) - 400 * x * (y - x**2)
    var dy = 200 * (y - x**2)
    return (dx, dy)  # Return as a tuple


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
