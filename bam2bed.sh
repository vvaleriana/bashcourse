#!/bin/bash

# Enable Conda inside the script
source $(dirname $(dirname $(which conda)))/etc/profile.d/conda.sh

# Define input arguments
BAM_FILE=$1
OUTPUT_DIR=$2

# Create output directory
mkdir -p "$OUTPUT_DIR"

# Create a new bam2bed environment
conda create --name bam2bed -y bedtools

#activate the environment
conda activate bam2bed
conda env list

# Convert BAM to BED
BED_FILE="$OUTPUT_DIR/$(basename "$BAM_FILE" .bam).bed"
bedtools bamtobed -i "$BAM_FILE" > "$BED_FILE"

# Filter the file for  chromosome 1 and make sure it works for other files too
CHR1_BED_FILE="$OUTPUT_DIR/$(basename "$BAM_FILE" .bam)_chr1.bed"
grep -E '^(chr1|Chr1)[[:space:]]' "$BED_FILE" > "$CHR1_BED_FILE"

# Count lines and pipe to the output file
wc -l "$CHR1_BED_FILE" > "$OUTPUT_DIR/bam2bed_number_of_rows.txt"

# Print success message and author
echo "Script completed successfully! Output in $OUTPUT_DIR Created by Valeriia Vasiahina"
