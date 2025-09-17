#!/bin/bash

# Merges all paired-end FASTQ files from multiple sequencing lanes into single combined FASTQ file for both Forward (R1) and Reverse (R2) reads per lane and sample

FASTQ_DIR=$1 
SAMPLE_ID=$2
OUTPUT_DIR=$3

mkdir -pv "$OUTPUT_DIR"

LANES=$(find "$FASTQ_DIR" -name "${SAMPLE_ID}*.fastq.gz" \
    | grep -o -E "L[0-9]{3}" \
    | sort -u)

for LANE in $LANES; do
    echo "Processing $LANE ..."

    R1_FILES=( $(find "$FASTQ_DIR" -name "${SAMPLE_ID}*${LANE}*R1*.fastq.gz" | sort) )
    R2_FILES=( $(find "$FASTQ_DIR" -name "${SAMPLE_ID}*${LANE}*R2*.fastq.gz" | sort) )

    if [[ ${#R1_FILES[@]} -gt 0 && ${#R2_FILES[@]} -gt 0 ]]; then

        # Merge all R1 files for this lane
        echo "Merging ${#R1_FILES[@]} R1 files for $LANE ..."
        gunzip -c "${R1_FILES[@]}" | gzip > "${OUTPUT_DIR}/${SAMPLE_ID}_${LANE}_R1.fastq.gz" \
    || { echo "ERROR merging R1 for $LANE"; exit 1; }
    
        # Merge all R2 files for this lane
        echo "Merging ${#R2_FILES[@]} R2 files for $LANE ..."
        gunzip -c "${R2_FILES[@]}" | gzip > "${OUTPUT_DIR}/${SAMPLE_ID}_${LANE}_R2.fastq.gz" \
    || { echo "ERROR merging R2 for $LANE"; exit 1; }
    
    else
        echo "WARNING: Skipping $LANE: missing R1 and/or R2 files."
    fi
done