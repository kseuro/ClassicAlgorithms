"""Runs the gradient descent algorithm using the Rosenbrock function."""

from python import Python
from function import (
    rosenbrock_gradient_descent,
    convert_history_to_numpy,
    get_python_plot_module,
    my_random_float,
)


fn main() raises -> None:
    """Driver function."""

    # Define a parameters dictionary
    var params = Dict[String, Float64]()
    params["initial_x"] = -1.5
    params["initial_y"] = 3.0
    params["learning_rate"] = 0.001
    params["num_iterations"] = 10000

    var history = rosenbrock_gradient_descent(params)
    var min_val = history[-1]

    print("Minimum of Rosenbrock function:")
    print("x =", min_val[0])
    print("y =", min_val[1])
    print("Function value at minimum point:", min_val[2])
    var np_arr = convert_history_to_numpy(history)
    var pyplot = get_python_plot_module()
    pyplot.plot_results(np_arr, min_val)
