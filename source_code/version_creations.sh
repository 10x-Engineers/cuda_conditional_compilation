#!/bin/bash

# Check if the correct number of arguments are provided
if [ "$#" -ne 3 ]; then
    echo "Usage: $0 <input_file_path> <version> <output_file_path>"
    echo "Versions: pro | lite"
    exit 1
fi

INPUT_FILE=$1
VERSION=$2
OUTPUT_FILE=$3

# Check if input file exists
if [ ! -f "$INPUT_FILE" ]; then
    echo "Error: Input file '$INPUT_FILE' not found."
    exit 1
fi

# Ensure the directory for the output file exists
OUTPUT_DIR=$(dirname "$OUTPUT_FILE")
if [ ! -d "$OUTPUT_DIR" ]; then
    echo "Error: Output directory '$OUTPUT_DIR' does not exist."
    exit 1
fi

if [ "$VERSION" == "pro" ]; then
    # PRO: Remove only the guard lines (#ifdef and #endif)
    sed '/#ifdef CUDA_PRO/,/#endif/ { /#ifdef CUDA_PRO/d; /#endif/d; }' "$INPUT_FILE" > "$OUTPUT_FILE"
    echo "Pro version created at: $OUTPUT_FILE"

elif [ "$VERSION" == "lite" ]; then
    # LITE: Remove the entire block including the code inside
    sed '/#ifdef CUDA_PRO/,/#endif/d' "$INPUT_FILE" > "$OUTPUT_FILE"
    echo "Lite version created at: $OUTPUT_FILE"

else
    echo "Error: Invalid version. Use 'pro' or 'lite'."
    exit 1
fi