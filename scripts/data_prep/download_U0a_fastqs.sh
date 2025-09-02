#!/bin/bash

# Skip the header and read each line
tail -n +2 sample_U0a_metadata.tsv | while IFS=$'\t' read -r FASTQ1 MD5_1 FASTQ2 MD5_2 SAMPLE
do
  # Extract filenames from URLs
  FILE1=$(basename "$FASTQ1")
  FILE2=$(basename "$FASTQ2")

  echo "Downloading $FILE1"
  wget -c "$FASTQ1" 2>&1 | tee /dev/tty

  echo "Verifying $FILE1"
  DL_MD5_1=$(md5 "$FILE1" | awk '{print $1}')
  if [ "$DL_MD5_1" != "$MD5_1" ]; then
    echo "MD5 mismatch for $FILE1!"
    echo "Expected: $MD5_1"
    echo "Actual:   $DL_MD5_1"
  else
    echo "$FILE1 passed MD5 check."
  fi

  echo "Downloading $FILE2"
  wget -c "$FASTQ2" 2>&1 | tee /dev/tty

  echo "Verifying $FILE2"
  DL_MD5_2=$(md5 "$FILE2" | awk '{print $1}')
  if [ "$DL_MD5_2" != "$MD5_2" ]; then
    echo "MD5 mismatch for $FILE2!"
    echo "Expected: $MD5_2"
    echo "Actual:   $DL_MD5_2"
  else
    echo "$FILE2 passed MD5 check."
  fi

  echo "------------------------------------------------"

done

