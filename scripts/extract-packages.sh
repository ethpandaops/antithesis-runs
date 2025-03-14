#!/bin/bash

# Default format is newline
format="newline"
package="github.com/ethpandaops/ethereum-package"

# Parse command line arguments
while getopts "f:p:" opt; do
  case $opt in
    f) format="$OPTARG" ;;
    p) package="$OPTARG"
       # Remove http:// or https:// prefix if present
       package="${package#http://}"
       package="${package#https://}"
       ;;
    *) echo "Usage: $0 [-f format] [-p package] args_file (format: newline|semicolon)" >&2; exit 1 ;;
  esac
done
shift $((OPTIND-1))

# Check if args file is provided
if [ $# -ne 1 ]; then
  echo "Usage: $0 [-f format] [-p package] args_file" >&2
  exit 1
fi

args_file="$1"

# Run the command and capture its output
output=$(kurtosis run "$package" --enclave tmp --args-file "$args_file" --dependencies)

# Extract and process packages based on format
if [ "$format" = "semicolon" ]; then
  echo "$output" | awk '/^Packages:$/,/^Name:/' | grep -v '^Packages:$' | grep -v '^Name:' | sed 's/^ //' | grep -v '^$' | paste -sd ";"
else
  echo "$output" | awk '/^Packages:$/,/^Name:/' | grep -v '^Packages:$' | grep -v '^Name:' | sed 's/^ //' | grep -v '^$'
fi
