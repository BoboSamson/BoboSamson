#!/bin/bash

# Input JSON file (if applicable)
INPUT_FILE="shareholders.4.json"

# Output PNG file
OUTPUT_IMAGE="shareholding_chart.png"

# Run the Python script
python3 shareholding_chart.py "$INPUT_FILE" "$OUTPUT_IMAGE"

echo "Graph saved as $OUTPUT_IMAGE"

