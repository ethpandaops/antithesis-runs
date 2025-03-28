#!/bin/bash

# Default format is newline
format="newline"
package="github.com/ethpandaops/ethereum-package"

# Parse command line arguments
while getopts "f:" opt; do
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

# Extract and process images based on format
if [ "$format" = "semicolon" ]; then
  echo "$output" | awk '/^Images:$/,/^Packages:$/' | grep -v '^Images:$' | grep -v '^Packages:$' | sed 's/^ //' | grep -v '^$' | \
  awk '{
    split($0, parts, ":")
    registry = parts[1]
    if (registry !~ /\//) {
      registry = "docker.io/library/" parts[1]
    } else if (registry !~ /\./) {
      registry = "docker.io/" registry
    }
    if (length(parts) > 1) {
      print registry ":" parts[2]
    } else {
      print registry ":latest"
    }
  }' | paste -sd ";"
else
  echo "$output" | awk '/^Images:$/,/^Packages:$/' | grep -v '^Images:$' | grep -v '^Packages:$' | sed 's/^ //' | grep -v '^$' | \
  awk '{
    split($0, parts, ":")
    registry = parts[1]
    if (registry !~ /\//) {
      registry = "docker.io/library/" parts[1]
    } else if (registry !~ /\./) {
      registry = "docker.io/" registry
    }
    if (length(parts) > 1) {
      print registry ":" parts[2]
    } else {
      print registry ":latest"
    }
  }'
fi
