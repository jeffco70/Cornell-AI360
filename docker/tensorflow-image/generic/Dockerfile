# =====================================================================
# Base: Official TensorFlow GPU + Jupyter image
# - Runs as root by default
# - Jupyter default workdir is /tf
# - Jupyter listens on port 8888
# =====================================================================
FROM tensorflow/tensorflow:latest-gpu-jupyter

# Avoid interactive prompts during apt installs
ENV DEBIAN_FRONTEND=noninteractive

# Make sure we are in the same working directory the base image uses
WORKDIR /tf

# ---------------------------------------------------------------------
# APT SECTION: OS-level packages
# ---------------------------------------------------------------------
# Sample tools:
#   - git, curl, wget: common CLI tools
#   - build-essential: compilers for building Python packages (C/C++)
#   - nano, htop: editor and process viewer
# You can add/remove packages as needed.
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
# WGET SECTION: Download external resources at build time (OPTIONAL)
# ---------------------------------------------------------------------
# Example: download a sample dataset into /tf/data.
# Replace the URL with something you actually use or comment this out.
RUN mkdir -p /tf/data && \
    wget -O /tf/data/sample_data.csv "https://example.com/sample_data.csv" || true
# The `|| true` keeps the build from failing if the URL is just a placeholder.


# ---------------------------------------------------------------------
# PIP SECTION: Python packages via requirements.txt
# ---------------------------------------------------------------------
# requirements.txt will live next to this Dockerfile in the build context.
COPY requirements.txt /tmp/requirements.txt

RUN pip install --no-cache-dir --upgrade pip && \
    pip install --no-cache-dir -r /tmp/requirements.txt


# ---------------------------------------------------------------------
# MAMBA / CONDA SECTION (OPTIONAL)
# ---------------------------------------------------------------------
# This shows how to install Mambaforge and then create/update an env using
# environment.yml. Comment out the whole block if you don't need conda/mamba.
#
# NOTE: Mixing pip and conda in the same env is possible, but be deliberate.
# Common pattern: use conda/mamba for heavy numeric libs, pip for everything else.

# === Install Mambaforge (lightweight conda + mamba) ===
# You can pin a specific installer version if desired.
RUN wget -qO /tmp/mambaforge.sh \
      "https://github.com/conda-forge/miniforge/releases/latest/download/Mambaforge-Linux-x86_64.sh" && \
    bash /tmp/mambaforge.sh -b -p /opt/mambaforge && \
    rm /tmp/mambaforge.sh && \
    /opt/mambaforge/bin/conda config --system --set auto_update_conda false && \
    /opt/mambaforge/bin/conda clean -afy

# Put conda/mamba on PATH
ENV PATH=/opt/mambaforge/bin:$PATH

# Copy environment.yml (optional conda env spec)
COPY environment.yml /tmp/environment.yml

# Example: update the base env using environment.yml.
# You could also create a named env (e.g., env: tfenv) if you prefer.
RUN mamba env update -n base -f /tmp/environment.yml && \
    conda clean -afy

# If you created a named env instead, you’d typically:
#   RUN mamba env create -n tfenv -f /tmp/environment.yml && conda clean -afy
#   ENV CONDA_DEFAULT_ENV=tfenv
#   SHELL ["conda", "run", "-n", "tfenv", "/bin/bash", "-c"]
# but that is more advanced; this template keeps it simple.


# ---------------------------------------------------------------------
# SCRIPTS SECTION (OPTIONAL)
# ---------------------------------------------------------------------
# Example: post-start script that you can use to do runtime setup.
# (Log banners, git clone repos, run custom commands, etc.)
COPY scripts/post_start.sh /usr/local/bin/post_start.sh
RUN chmod +x /usr/local/bin/post_start.sh

# If you want to run the script automatically *before* Jupyter starts,
# you can override the CMD or ENTRYPOINT. Since the base image’s CMD
# already launches Jupyter, a common pattern is:
#
# ENTRYPOINT ["/usr/local/bin/post_start.sh"]
# CMD ["bash", "-lc", "jupyter notebook --ip=0.0.0.0 --no-browser --allow-root --notebook-dir=/tf"]
#
# For now, we leave the base image’s default CMD intact so you can choose
# how/when to run post_start.sh.


# ---------------------------------------------------------------------
# NETWORK / PORTS
# ---------------------------------------------------------------------
# Jupyter runs on port 8888 inside the container.
EXPOSE 8888

# ---------------------------------------------------------------------
# USER SECTION (OPTIONAL)
# ---------------------------------------------------------------------
# The base image runs as root. If you want a non-root dev user, uncomment:
#
# RUN useradd -ms /bin/bash dev && \
#     chown -R dev:dev /tf
# USER dev
#
# Remember: all `apt-get` and system installs should happen BEFORE switching user.
#
# For now, we stay with root to match the base TensorFlow image behavior.
