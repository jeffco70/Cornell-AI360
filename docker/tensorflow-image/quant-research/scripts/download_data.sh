#!/usr/bin/env bash
set -e

DATA_DIR="/tf/data"
mkdir -p "$DATA_DIR"

echo "Downloading sample data into ${DATA_DIR}..."

# Replace these URLs with real datasets you use
# Examples: CSVs, model weights, etc.
wget -O "${DATA_DIR}/sample1.csv" "https://example.com/sample1.csv" || echo "sample1.csv download failed"
wget -O "${DATA_DIR}/sample2.csv" "https://example.com/sample2.csv" || echo "sample2.csv download failed"

echo "Download complete (with possible warnings above)."
