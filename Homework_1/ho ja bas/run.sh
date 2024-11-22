#!/bin/bash

# Ensure that the script exits on any error
set -e

# File to store results
results_file="timing_results.txt"
echo "Threads, Trapezoidal Time (s), Monte Carlo Time (s)" > $results_file

# Number of samples for Monte Carlo and intervals for Trapezoidal
N=1000000   # Number of samples for Monte Carlo
intervals=1000  # Number of intervals for trapezoidal rule

# Compile the trapezoidal and Monte Carlo codes
gcc -o trapezoidal_parallel trapezoidal_parallel.c -fopenmp -lm
gcc -o monte_carlo_parallel monte_carlo_parallel.c -fopenmp -lm

# Loop through different thread counts
for threads in 2 4 6 8; do
    trapezoidal_time=0
    monte_carlo_time=0

    # Average over 10 runs
    for i in {1..10}; do
        # Measure trapezoidal rule time
        trapezoidal_run_time=$(./trapezoidal_parallel $intervals $threads)
        trapezoidal_time=$(echo "$trapezoidal_time + $trapezoidal_run_time" | bc)

        # Measure Monte Carlo time
        monte_carlo_run_time=$(./monte_carlo_parallel $N $threads)
        monte_carlo_time=$(echo "$monte_carlo_time + $monte_carlo_run_time" | bc)
    done

    # Calculate average time
    avg_trapezoidal_time=$(echo "$trapezoidal_time / 10" | bc -l)
    avg_monte_carlo_time=$(echo "$monte_carlo_time / 10" | bc -l)

    # Write results to file
    echo "$threads, $avg_trapezoidal_time, $avg_monte_carlo_time" >> $results_file
done

