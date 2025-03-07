#!/bin/zsh

# Enable null_glob to avoid "no matches found" error if no .tsv files exist
setopt null_glob

# Define paths
FOLDER_PATH="/Users/samsonbobo/Desktop/Storage_Technologies/stm/mr/3/"
SORTED_FILE="${FOLDER_PATH}sorted_words.txt"
GLOBAL_WORD_COUNT="${FOLDER_PATH}total_word_counts.txt"
TEMP_FILE="${FOLDER_PATH}temp_word_counts.txt"

# Declare an associative array to store global word counts
typeset -A word_totals

echo "Processing files in: $FOLDER_PATH"

# Process each .tsv file
for file in "$FOLDER_PATH"*.tsv; do
    if [[ -f "$file" ]]; then
        echo "Processing: $file"

        # Print header for the file
        echo "Sorted words from $file:" >> "$SORTED_FILE"

        # Extract words, remove punctuation, count occurrences
        cat "$file" | tr -cs '[:alnum:]' '\n' | grep -v "^$" | sort | uniq -c | sort -nr | tee -a "$SORTED_FILE" > "$TEMP_FILE"

        echo "" >> "$SORTED_FILE"  # Add a newline for readability

        # Update global counts
        while read -r count word; do
            if [[ -n "$word" ]]; then
                ((word_totals[$word] += count))
            fi
        done < "$TEMP_FILE"

    fi
done

# Check if any files were processed
if [[ ${#word_totals} -eq 0 ]]; then
    echo "No .tsv files found in $FOLDER_PATH!"
    exit 1
fi

# Write total word frequency across all files
echo "Total word frequencies across all files:" > "$GLOBAL_WORD_COUNT"
for word in "${(@k)word_totals}"; do
    echo "${word_totals[$word]} $word" >> "$GLOBAL_WORD_COUNT"
done

# Sort the total word count file in descending order
sort -nr "$GLOBAL_WORD_COUNT" -o "$GLOBAL_WORD_COUNT"

rm "$TEMP_FILE"

# Print results to terminal
echo "Processing complete!"
echo "Individual word counts saved in: $SORTED_FILE"
echo "Total word frequencies saved in: $GLOBAL_WORD_COUNT"

# Show top 10 words from global count
echo "Top words across all files:"
head -10 "$GLOBAL_WORD_COUNT"
