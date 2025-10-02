#!/usr/bin/env bash

set -euo pipefail

# Handle --help or missing arguments
show_help() {
    echo "Usage: $0 <input_fastq_dir> <output_dir>"
    echo
    echo "Arguments:"
    echo "  <input_fastq_dir>   Directory containing FASTQ (.fastq.gz) files"
    echo "  <output_dir>        Directory where FastQC reports will be saved"
    echo
    echo "Example:"
    echo "  $0 data/fastq/merged results/fastqc_reports"
}

if [[ $# -lt 2 || "$1" == "--help" || "$1" == "-h" ]]; then
    show_help
    exit 0
fi

INPUT_FASTQS=$1 
OUTPUT_DIR=$2

# Collect FASTQ files into an array
FILES=("${INPUT_FASTQS}"/*.fastq.gz)
N_THREADS=${#FILES[@]}

if [[ ${N_THREADS} -eq 0 ]]; then
    echo "Error: no fastq.gz files found in ${INPUT_FASTQS}." >&2
    exit 1
fi

echo "Found ${N_THREADS} FASTQ files in ${INPUT_FASTQS}"

# Run fastqc
mkdir -pv "${OUTPUT_DIR}"
/Users/rishanvaratheeswaran/bin/micromamba run -n wgs_env fastqc -o "${OUTPUT_DIR}" -t "${N_THREADS}" "${FILES[@]}"

echo "FastQC finished! Reports are in ${OUTPUT_DIR}"