#!/bin/bash

LOG_FILE=output100_16.txt
NUM_RUNS=5

if [ -f "$LOG_FILE" ]; then
	rm "$LOG_FILE"
fi

./compile.sh

echo "Size, Time, S?F, Avg_time" >> $LOG_FILE
for((i=100; i<=1000; i+=100)) do 
	echo "Running for input size: $i"
	TOTAL_TIME=0

	for((j=1; j<=NUM_RUNS; j++)); do
		echo "run $j"
		OUTPUT=$(./mat_mul $i)
		RUN_TIME=$(echo "$OUTPUT" | grep -oP "\d+\.\d+")
		TOTAL_TIME=$(echo "$TOTAL_TIME + $RUN_TIME" | bc)
	done

	AVG_TIME=$(echo "$TOTAL_TIME / $NUM_RUNS" | bc -l)
	echo "$AVG_TIME"


	echo "$OUTPUT"

	echo "$OUTPUT, $AVG_TIME" >> $LOG_FILE
done
