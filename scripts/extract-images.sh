#!/bin/bash

# Default format is newline
format="newline"

# Parse command line arguments
while getopts "f:" opt; do
  case $opt in
    f) format="$OPTARG" ;;
    *) echo "Usage: $0 [-f format] args_file (format: newline|semicolon)" >&2; exit 1 ;;
  esac
done
shift $((OPTIND-1))

# Check if args file is provided
if [ $# -ne 1 ]; then
  echo "Usage: $0 [-f format] args_file" >&2
  exit 1
fi

args_file="$1"

# Run the command and capture its output
output=$(kurtosis run github.com/ethpandaops/ethereum-package --enclave tmp --args-file "$args_file" --dependencies)

# Extract images based on format
if [ "$format" = "semicolon" ]; then
  echo "$output" | awk '/^Images:$/,/^Packages:$/' | grep -v '^Images:$' | grep -v '^Packages:$' | sed 's/^ //' | grep -v '^$' | paste -sd ";"
else
  echo "$output" | awk '/^Images:$/,/^Packages:$/' | grep -v '^Images:$' | grep -v '^Packages:$' | sed 's/^ //' | grep -v '^$'
fi
