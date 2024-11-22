#!/bin/bash

# File to store the output
output_file="matrix_mul_avg_times.csv"

# Create or clear the CSV file and write the header
echo "Matrix Size,Average Execution Time (ms)" > $output_file

# List of matrix sizes to run the program with
sizes=(100 200 350 500 750 1000 1250 1500 2000 3000 4000 5000)

# Loop over each matrix size
for size in "${sizes[@]}"
do
    total_time=0

    # Run the program 5 times for each matrix size
    for run in {1..5}
    do
        exec_time=$(./mul_openmp $size | grep "time taken" | awk '{print $5}')
        total_time=$(echo "$total_time + $exec_time" | bc) # Sum the execution times
    done

    # Calculate the average time
    avg_time=$(echo "scale=3; $total_time / 5" | bc)

    # Append matrix size and average execution time to the CSV file
    echo "$size,$avg_time" >> $output_file
    echo "Completed for matrix size: $size with avg time: $avg_time ms"
done

echo "All sizes completed. Average times stored in $output_file."

