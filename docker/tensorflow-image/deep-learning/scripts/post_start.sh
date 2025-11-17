#!/usr/bin/env bash
set -e

echo "===================================================="
echo " Deep Learning container post-start"
echo " Workdir: $(pwd)"
echo " User: $(whoami)"
echo "===================================================="

# Optional: run data downloads at container start instead of build.
# /usr/local/bin/download_data.sh || true

# Example: create a notebooks folder
mkdir -p /tf/notebooks

# Example: list GPUs (if NVIDIA tooling is present)
if command -v nvidia-smi >/dev/null 2>&1; then
  echo "Detected NVIDIA GPUs:"
  nvidia-smi || true
fi

echo "Post-start hook complete."
