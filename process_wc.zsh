#!/bin/zsh

# Enable null_glob to prevent errors if no matching files exist
setopt null_glob

# Define paths
FOLDER_PATH="/Users/samsonbobo/Desktop/Storage_Technologies/stm/mr/3/"
OUTPUT_FILE="${FOLDER_PATH}wc_summary.txt"

# Initialize total counters
total_words=0
total_lines=0
total_chars=0

echo "Processing files in: $FOLDER_PATH"
echo "Generating word, line, and character counts..." > "$OUTPUT_FILE"
echo "------------------------------------------------" >> "$OUTPUT_FILE"

# Process each .tsv file
for file in "$FOLDER_PATH"*.tsv; do
    if [[ -f "$file" ]]; then
        echo "Processing: $file"

        # Get word, line, and character count
        words=$(wc -w < "$file")
        lines=$(wc -l < "$file")
        chars=$(wc -c < "$file")

        # Add to total counts
        (( total_words += words ))
        (( total_lines += lines ))
        (( total_chars += chars ))

        # Save per-file counts
        echo "File: $(basename "$file")" >> "$OUTPUT_FILE"
        echo "Lines: $lines | Words: $words | Characters: $chars" >> "$OUTPUT_FILE"
        echo "--------------------------------" >> "$OUTPUT_FILE"
    fi
done

# Save total counts
echo "TOTAL COUNTS ACROSS ALL FILES:" >> "$OUTPUT_FILE"
echo "Total Lines: $total_lines" >> "$OUTPUT_FILE"
echo "Total Words: $total_words" >> "$OUTPUT_FILE"
echo "Total Characters: $total_chars" >> "$OUTPUT_FILE"
echo "------------------------------------------------" >> "$OUTPUT_FILE"

# Print results to terminal
echo "Processing complete!"
echo "Results saved in: $OUTPUT_FILE"

# Show summary in terminal
cat "$OUTPUT_FILE"