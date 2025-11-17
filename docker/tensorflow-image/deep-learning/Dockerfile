# =====================================================================
# Base: Official TensorFlow GPU + Jupyter image
# - Includes TensorFlow + CUDA + Jupyter
# - Default workdir /tf, Jupyter on port 8888, runs as root
# =====================================================================
FROM tensorflow/tensorflow:latest-gpu-jupyter

# Avoid interactive prompts during apt installs
ENV DEBIAN_FRONTEND=noninteractive

# Keep consistent with base image
WORKDIR /tf

# ---------------------------------------------------------------------
# APT: System tools + common CV/audio dependencies
# ---------------------------------------------------------------------
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        git \
        curl \
        wget \
        build-essential \
        nano \
        htop \
        ffmpeg \
        libsm6 \
        libxext6 \
        libxrender1 \
        libglib2.0-0 \
        libgl1 \
    && apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# ---------------------------------------------------------------------
# PIP: Deep learning / DL tooling stack
# ---------------------------------------------------------------------
COPY requirements.txt /tmp/requirements.txt

RUN pip install --no-cache-dir --upgrade pip && \
    pip install --no-cache-dir -r /tmp/requirements.txt

# ---------------------------------------------------------------------
# OPTIONAL: Mambaforge + conda extras
# ---------------------------------------------------------------------
# This layer is optional; it’s useful if you want to bring in things that
# are easier via conda (special CUDA builds, JAX, etc.).
# Comment this whole block out if you want a pure-pip stack.
RUN wget -qO /tmp/mambaforge.sh \
      "https://github.com/conda-forge/miniforge/releases/latest/download/Mambaforge-Linux-x86_64.sh" && \
    bash /tmp/mambaforge.sh -b -p /opt/mambaforge && \
    rm /tmp/mambaforge.sh && \
    /opt/mambaforge/bin/conda config --system --set auto_update_conda false && \
    /opt/mambaforge/bin/conda clean -afy

ENV PATH=/opt/mambaforge/bin:$PATH

COPY environment.yml /tmp/environment.yml

# Update base environment with conda extras (optional)
RUN mamba env update -n base -f /tmp/environment.yml && \
    conda clean -afy

# ---------------------------------------------------------------------
# Optional runtime hook (for cloning repos, etc.)
# ---------------------------------------------------------------------
COPY scripts/post_start.sh /usr/local/bin/post_start.sh
RUN chmod +x /usr/local/bin/post_start.sh

# Jupyter port
EXPOSE 8888

# ---------------------------------------------------------------------
# OPTIONAL: Non-root user (uncomment if/when you want it)
# ---------------------------------------------------------------------
# RUN useradd -ms /bin/bash dev && \
#     chown -R dev:dev /tf
# USER dev

# We keep the base image’s CMD that launches Jupyter.
