"""Runs the gradient descent algorithm using the Rosenbrock function."""

from function import rosenbrock_gradient_descent


fn main() raises -> None:
    """Driver function."""

    # Define a parameters dictionary
    var params = Dict[String, Float64]()
    params["initial_x"] = 0.0
    params["initial_y"] = 3.0
    params["learning_rate"] = 0.001
    params["num_iterations"] = 10000

    var history = rosenbrock_gradient_descent(params)

    var min_val = history[-1]

    # Print results
    print("Minimum of Rosenbrock function:")
    print("x =", min_val[0])
    print("y =", min_val[1])
    print("Function value at minimum point:", min_val[2])

    # TODO: Implement results plotting using python interop.
    # TODO: We can store the plotting function in a python file.
