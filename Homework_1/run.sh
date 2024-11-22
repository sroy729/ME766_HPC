#!/bin/bash

# Name of the binary
BINARY="./a.out"

# Output file to store the results
OUTPUT_FILE="integration_results_monte.txt"

# Clear the output file
> $OUTPUT_FILE

# Run the program for intervals from 1 to 100
for ((interval = 1; interval <= 1000; interval++)); do
    echo "Running for interval: $interval"
    RESULT=$($BINARY $interval)
    echo "$interval $RESULT" >> $OUTPUT_FILE
done

echo "Results saved to $OUTPUT_FILE"


