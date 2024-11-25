lowercase() {
    input="$1"  # Store the first argument in a variable
    input=$(echo "$input" | tr '[:upper:]' '[:lower:]')  # Convert to lowercase
    echo "$input"  # Print the result
}