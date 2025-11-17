# =====================================================================
# Base: Official TensorFlow GPU + Jupyter image
# =====================================================================
FROM tensorflow/tensorflow:latest-gpu-jupyter

ENV DEBIAN_FRONTEND=noninteractive
WORKDIR /tf

# ---------------------------------------------------------------------
# APT: system tools and basic build deps
# ---------------------------------------------------------------------
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        git \
        curl \
        wget \
        build-essential \
        nano \
        htop \
    && apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# ---------------------------------------------------------------------
# Optional: small sample data baked in (you can remove this)
# ---------------------------------------------------------------------
RUN mkdir -p /tf/data && \
    wget -O /tf/data/README.txt "https://example.com/placeholder.txt" || true

# ---------------------------------------------------------------------
# PIP: Quant research Python stack
# ---------------------------------------------------------------------
COPY requirements.txt /tmp/requirements.txt

RUN pip install --no-cache-dir --upgrade pip && \
    pip install --no-cache-dir -r /tmp/requirements.txt

# ---------------------------------------------------------------------
# MAMBA / CONDA: heavy numeric + IO stack for quant work (optional)
# ---------------------------------------------------------------------
RUN wget -qO /tmp/mambaforge.sh \
      "https://github.com/conda-forge/miniforge/releases/latest/download/Mambaforge-Linux-x86_64.sh" && \
    bash /tmp/mambaforge.sh -b -p /opt/mambaforge && \
    rm /tmp/mambaforge.sh && \
    /opt/mambaforge/bin/conda config --system --set auto_update_conda false && \
    /opt/mambaforge/bin/conda clean -afy

ENV PATH=/opt/mambaforge/bin:$PATH

COPY environment.yml /tmp/environment.yml

RUN mamba env update -n base -f /tmp/environment.yml && \
    conda clean -afy

# ---------------------------------------------------------------------
# Optional: post-start script wiring (kept simple for now)
# ---------------------------------------------------------------------
COPY scripts/post_start.sh /usr/local/bin/post_start.sh
RUN chmod +x /usr/local/bin/post_start.sh

EXPOSE 8888

# Optional non-root user – leave commented until you want it:
# RUN useradd -ms /bin/bash dev && \
#     chown -R dev:dev /tf
# USER dev
