#!/bin/bash

# Merges all paired-end FASTQ files from multiple sequencing lanes into single combined FASTQ file for both forward (R1) and Reverse (r2) reads per sample

FASTQ_DIR=$1 
SAMPLE_ID=$2
OUTPUT_DIR=$3

mkdir -pv $OUTPUT_DIR

# Merge all partial reads (R1_001, R1_002,...) together into a single FASTQ file
# Merge all R1s and R2s together respectively
# 

find $FASTQ_DIR -name "${SAMPLE_ID}*.fastq.gz" | while read -r fastq_path; do
    filename=$(basename "$fastq_path")
    readpair=$(echo "$fastq_path" | grep -o "R[12]")

    if 
done