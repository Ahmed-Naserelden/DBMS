#!/bin/bash

# Check if a file argument is provided
if [ -z "$1" ]; then
    echo "Usage: $0 <input-file>"
    exit 1
fi

# Input file is the first argument
input_file="$1"

# Check if the file exists
if [ ! -f "$input_file" ]; then
    echo "File '$input_file' not found!"
    exit 1
fi

# Read the first line to get the column names
header=$(head -n 1 "$input_file")
IFS=':' read -r -a columns <<< "$header"

# Calculate the maximum width for each column
max_width=()
for col in "${columns[@]}"; do
    max_width+=($(echo "$col" | wc -c))
done

# Read the remaining lines to find the maximum length in each column
tail -n +2 "$input_file" | while IFS=':' read -r -a values; do
    for i in "${!values[@]}"; do
        # Update max_width for each column
        len=$(echo -n "${values[$i]}" | wc -c)
        if [ ${len} -gt ${max_width[$i]} ]; then
            max_width[$i]=$len
        fi
    done
done

# Print the table header
printf "+"
for width in "${max_width[@]}"; do
    printf "%-${width}s+"  # Dynamic width for each column
done
echo

# Print column names with dynamic width
printf "|"
for i in "${!columns[@]}"; do
    printf " %-${max_width[$i]}s |" "${columns[$i]}"
done
echo

# Print the separator line
printf "+"
for width in "${max_width[@]}"; do
    printf "%-${width}s+"  # Dynamic width for each column
done
echo

# Read the remaining lines from the file and format the data
tail -n +2 "$input_file" | while IFS=':' read -r -a values; do
    printf "|"
    for i in "${!values[@]}"; do
        printf " %-${max_width[$i]}s |" "${values[$i]}"
    done
    echo
done

# Print the table footer
printf "+"
for width in "${max_width[@]}"; do
    printf "%-${width}s+"  # Dynamic width for each column
done
echo
