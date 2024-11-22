#!/bin/bash

# Check if the user provided the gprof output file as an argument
if [ -z "$1" ]; then
  echo "Usage: $0 <gprof_output_file>"
  exit 1
fi

# File path to the gprof output
GPROF_FILE="$1"

# Output CSV file
OUTPUT_CSV="gprof_output.csv"

# Check if the file exists
if [ ! -f "$GPROF_FILE" ]; then
  echo "File '$GPROF_FILE' not found!"
  exit 1
fi

# Create or overwrite the CSV file
echo "================== Flat Profile =================="
echo "  % Time,Cumulative Seconds,Self Seconds,Calls,Self ms/Call,Total ms/Call,Function Name" > "$OUTPUT_CSV"

# Extract and format the Flat Profile table into CSV
grep -A 20 'Flat profile' "$GPROF_FILE" | sed -n '/Flat profile/,/Call graph/p' | tail -n +2 | head -n -1 | awk '{print $1 "," $2 "," $3 "," $4 "," $5 "," $6 "," $7}' >> "$OUTPUT_CSV"

# Append a separator for clarity
echo "" >> "$OUTPUT_CSV"

# Extract and format the Call Graph table into CSV
echo "================== Call Graph ==================" >> "$OUTPUT_CSV"
echo "Index,% Time,Self Seconds,Children Seconds,Calls,Function Name" >> "$OUTPUT_CSV"
grep -A 20 'Call graph' "$GPROF_FILE" | sed -n '/Call graph/,/Index by function name/p' | tail -n +2 | head -n -1 | awk '{print $1 "," $2 "," $3 "," $4 "," $5 "," $6}' >> "$OUTPUT_CSV"

# Append a separator for clarity
echo "" >> "$OUTPUT_CSV"

# Extract and format the Index by Function Name section into CSV
echo "================== Index by Function Name ==================" >> "$OUTPUT_CSV"
echo "Index,Function Name" >> "$OUTPUT_CSV"
grep -A 20 'Index by function name' "$GPROF_FILE" | tail -n +2 | head -n -1 | awk '{print $1 "," $2}' >> "$OUTPUT_CSV"

# Inform the user that the CSV file has been created
echo "CSV file 'gprof_output.csv' has been created with the extracted data."

