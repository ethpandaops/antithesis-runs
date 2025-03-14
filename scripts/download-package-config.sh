#!/bin/bash

input="$1"
output="${2:-ethereum-package-config.yaml}"

if [[ "$input" =~ ^https?:// ]]; then
    # Download from URL
    curl -L -o "$output" "$input"
else
    # Copy local file
    cp "$input" "$output"
fi
