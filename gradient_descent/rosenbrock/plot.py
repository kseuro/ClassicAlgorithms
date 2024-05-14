"""Defines a plotting function to visualizing the results of gradient descent."""

import numpy as np
import matplotlib.pyplot as plt


def plot_results(history: np.ndarray, min_val: float):
    """Plots the gradient descent results."""

    def rosenbrock(x, y):
        return (1 - x) ** 2 + 100 * (y - x**2) ** 2

    # Generate data for contour plot
    x = np.linspace(-2, 2, 100)
    y = np.linspace(-1, 3, 100)
    X, Y = np.meshgrid(x, y)
    Z = rosenbrock(X, Y)

    # Create figure and subplots
    fig, (ax1, ax2) = plt.subplots(1, 2, figsize=(15, 6))

    # Plot surface in the left subplot
    ax1.contour(X, Y, Z, levels=50, cmap="viridis")
    ax1.scatter(history[:, 0], history[:, 1], color="red", marker=".", label="Gradient Descent Path", s=1)
    ax1.plot(history[:, 0], history[:, 1], color="red", linewidth=2, linestyle="-", alpha=0.5)
    ax1.scatter(min_val[0], min_val[1], color="green", marker="o", label="Minimum Point")
    ax1.axvline(x=1, color="magenta", linestyle="--")
    ax1.axhline(y=1, color="magenta", linestyle="--")
    ax1.text(1, 1, "(1,1)", fontsize=12, color="black")
    ax1.set_xlabel("x")
    ax1.set_ylabel("y")
    ax1.set_title("Gradient Descent Path on Rosenbrock Function (Contour Plot)")
    plt.grid(True)
    ax1.legend()

    # Plot contour plot in the right subplot
    ax2 = fig.add_subplot(122, projection="3d")
    ax2.view_init(elev=40, azim=-70, roll=None)
    ax2.plot_surface(X, Y, Z, cmap="viridis", rstride=1, cstride=1, alpha=0.7, edgecolor="none")
    ax2.scatter(min_val[0], min_val[1], rosenbrock(min_val[0], min_val[1]), color="green", s=100, label="Minimum Point")
    ax2.plot(
        history[:, 0],
        history[:, 1],
        rosenbrock(history[:, 0], history[:, 1]),
        color="red",
        label="Gradient Descent Path",
    )
    ax2.set_xlabel("x")
    ax2.set_ylabel("y")
    ax2.set_zlabel("z")
    ax2.set_title("Gradient Descent Path on Rosenbrock Function (3D)")
    ax2.legend()

    plt.show()
