#!/bin/bash

validate_sql() {
  local query="$1"
  # Define a regex pattern for basic SQL validation
  local sql_pattern="^\s*(SELECT|INSERT|UPDATE|DELETE|CREATE|DROP|ALTER|TRUNCATE)\b.*\b(FROM|INTO|SET|WHERE|TABLE|VALUES|JOIN|ON|GROUP BY|ORDER BY|HAVING|LIMIT|OFFSET|AS)\b.*;$"

  # Check if the query matches the pattern
  if [[ "$query" =~ $sql_pattern ]]; then
    echo "True"
  else
    echo "False"
  fi
}

# Read input from the user
read -p "Enter your SQL query: " sql_query

# Call the validation function
validate_sql "$sql_query"
