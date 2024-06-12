# ClassicAlgorithms

A collection of classic computer science algorithms implemented in pure [Mojo](https://www.modular.com/max/mojo) `version 24.3.0`. This repo is meant as a learning exercise to cover the various aspects of the Mojo language and not as a comprehensive overview or instruction manual of the various algorithms detailed below.

## Sorting

- [Bubble sort](https://en.wikipedia.org/wiki/Bubble_sort)
  - [X] Implemented
  - [X] Tested
  - [X] Benchmarked

- [Cocktail Shaker Sorter](https://en.wikipedia.org/wiki/Cocktail_shaker_sort)
  - [X] Implemented
  - [X] Tested
  - [X] Benchmarked

- [Quicksort](https://en.wikipedia.org/wiki/Quicksort)
  - [X] Implemented
  - [X] Tested
  - [ ] Benchmarked - Memory error when benchmarking.

- Merge sort
  - [X] Implemented
  - [X] Tested
  - [ ] Benchmarked

## Searching

- Linear search
- Binary search

## Gradient Descent

- [Rosenbrock Function](https://en.wikipedia.org/wiki/Rosenbrock_function)
  - Note: Due to relative path importing, call the optimization function from within the containing folder like:

    ```bash
    cd gradient_descent/rosenbrock
    mojo optimize.mojo
    ```
