#!/bin/bash

# CSV output file
output_file="mpi_matrix_multiplication_times.csv"

# List of matrix sizes
matrix_sizes=(100 200 350 500 750 1000 1250 1500 2000 3000 4000 5000)

# List of MPI processes to use
mpi_processes=(2 4 8)

# Number of times to repeat each run
num_runs=5

# MPI executable
executable="./mul_mpi"

# Header for CSV file
echo "MPI Processes,Matrix Size,Average Execution Time" > $output_file

# Iterate over the number of MPI processes
for processes in "${mpi_processes[@]}"
do
    # Iterate over each matrix size
    for size in "${matrix_sizes[@]}"
    do
        # Initialize total time
        total_time=0

        # Run the executable for the specified number of times and record time
        for run in $(seq 1 $num_runs)
        do
            # Run the MPI code and extract the execution time
            exec_time=$(mpirun -np $processes $executable $size | grep "Time taken" | awk '{print $NF}')
            
            # Add the execution time to the total time
            total_time=$(echo "$total_time + $exec_time" | bc -l)
        done

        # Calculate the average execution time
        avg_time=$(echo "$total_time / $num_runs" | bc -l)

        # Write the results to the CSV file
        echo "$processes,$size,$avg_time" >> $output_file
    done
done

echo "Experiment complete. Results saved to $output_file."

