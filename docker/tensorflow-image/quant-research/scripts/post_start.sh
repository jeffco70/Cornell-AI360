#!/usr/bin/env bash
set -e

echo "===================================================="
echo " Container post-start hook"
echo " Workdir: $(pwd)"
echo " User: $(whoami)"
echo "===================================================="

# Optional: run data downloads at container start instead of build.
# /usr/local/bin/download_data.sh || true


echo "Post-start hook complete."

# Exec the real command (if you decide to use this as ENTRYPOINT).
# For example, to hand off to Jupyter:
# exec jupyter lab --ip=0.0.0.0 --no-browser --allow-root --notebook-dir=/tf

# Right now this script is just a utility; you can:
#  - call it manually inside the container, or
#  - wire it up as ENTRYPOINT in the Dockerfile if you want it automatic.
