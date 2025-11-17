# Machine Learning Stack based on Tensorflow image


Build a **deep learning dev stack** on top of:

```Dockerfile
FROM tensorflow/tensorflow:latest-gpu-jupyter
```

with:

* Good **system libs** for CV/audio
* **pip**-installed DL ecosystem (TensorFlow extras + Hugging Face + training utilities)
* Optional **mamba/conda** layer for heavier CUDA/JAX/PyTorch pieces (commented/optional where it might be risky)

You can comment out anything you don’t want.

---

## 1. Directory layout

```text
tf-dl-stack/
│
├── Dockerfile
├── requirements.txt      # pip-based deep learning stack
├── environment.yml       # optional conda/mamba extras
└── scripts/
    └── post_start.sh     # optional runtime hook
```

---

## 2. Dockerfile (deep-learning–tuned)

```Dockerfile
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
```

---

## 3. `requirements.txt` — DL ecosystem (pip)

This focuses on GPU-aware deep learning tooling built around TensorFlow, plus Hugging Face and training utilities. PyTorch remains optional (see notes).

```text
##############################
# Core numeric / notebook    #
##############################
numpy
pandas
scipy
jupyterlab
ipykernel
ipython
tqdm
ipywidgets

##############################
# Visualization              #
##############################
matplotlib
seaborn
plotly

##############################
# TensorFlow ecosystem       #
##############################
# TF itself is baked into the base image, so we generally avoid
# reinstalling it here to prevent version mismatch.
tensorflow-datasets
tensorflow-probability
# tensorflow-addons   # can be version-sensitive; enable if needed and pin versions

##############################
# Keras / high-level DL      #
##############################
keras                        # usually already available via tf.keras but useful standalone
keras-tuner                 # hyperparameter search
optuna                      # generic hyperparameter optimization

##############################
# Hugging Face stack         #
##############################
transformers
datasets
accelerate
evaluate
sentencepiece
huggingface-hub

##############################
# Computer vision / images   #
##############################
opencv-python
Pillow
albumentations              # image augmentations

##############################
# Audio / speech (optional)  #
##############################
librosa
soundfile

##############################
# RL / control (optional)    #
##############################
gymnasium
gymnasium[classic-control]
# tf-agents                 # optional, can be somewhat version-sensitive

##############################
# Utilities / tooling        #
##############################
rich                        # nicer console logging
tensorboard                 # usually in TF base; safe to include
tensorboard-plugin-profile  # profiling support
wandb                       # experiment tracking (optional)
mlflow                      # experiment tracking (optional)

##############################
# OPTIONAL: PyTorch (CPU-only)
##############################
# If you want CPU-only PyTorch just for experimentation and don’t care
# about PyTorch GPU inside this container, you can uncomment:
# torch
# torchvision
# torchaudio

# For proper GPU PyTorch, it’s safer to either:
#   - Use a dedicated PyTorch CUDA base image, or
#   - Install via conda in environment.yml with pinned CUDA versions.
```

You can trim this down to just TF+HuggingFace if you want a leaner image.

---

## 4. `environment.yml` — optional heavy extras (mamba/conda)

This is where you can pull in things that are easier with conda. You can keep it very small or expand as needed. I’ll keep PyTorch and JAX commented as “advanced / optional” since mixing them in a TF-base container is doable but can get fiddly.

```yaml
name: base
channels:
  - conda-forge
  # - pytorch        # uncomment if you decide to conda-install PyTorch
  # - nvidia         # for certain CUDA-enabled builds
dependencies:
  ##################################
  # Numeric / performance extras   #
  ##################################
  - numpy
  - scipy
  - numba
  - bottleneck
  - numexpr

  ##################################
  # IO / data formats              #
  ##################################
  - pyarrow
  - pytables
  - h5py       # HDF5 support (often used with Keras/TF models)

  ##################################
  # Tools                          #
  ##################################
  - mamba
  - pip

  ##################################
  # OPTIONAL: JAX (CPU or GPU)     #
  ##################################
  # For CPU-only JAX (safer in mixed env):
  # - jax
  # - jaxlib

  # For GPU JAX, you’d normally pin CUDA version carefully and follow
  # official JAX installation instructions; that can collide with the
  # TF base image’s CUDA libs if not managed carefully.

  ##################################
  # OPTIONAL: PyTorch (GPU via conda)
  ##################################
  # If you really want PyTorch GPU inside this TF base, something like:
  #
  # - pytorch
  # - torchvision
  # - torchaudio
  # - pytorch-cuda=12.1
  #
  # and channels:
  #   - pytorch
  #   - nvidia
  #
  # BUT: do this only when you’re ready to accept some CUDA/driver
  # debugging; otherwise, use a dedicated PyTorch base image instead.

  ##################################
  # Pip extras managed via conda   #
  ##################################
  - pip:
      # you can mirror some pip-only packages here if you prefer
      # to manage everything through one spec file
      - onnx
      - onnxruntime-gpu
```

If you don’t want mamba/conda at all, you can:

* Comment out the entire mamba section in the Dockerfile
* Ignore/delete `environment.yml`

---

## 5. `scripts/post_start.sh` — optional runtime hook

Same idea as before; here’s a minimal version:

```bash
#!/usr/bin/env bash
set -e

echo "===================================================="
echo " Deep Learning container post-start"
echo " Workdir: $(pwd)"
echo " User: $(whoami)"
echo "===================================================="

# Example: create a notebooks folder
mkdir -p /tf/notebooks

# Example: list GPUs (if NVIDIA tooling is present)
if command -v nvidia-smi >/dev/null 2>&1; then
  echo "Detected NVIDIA GPUs:"
  nvidia-smi || true
fi

echo "Post-start hook complete."
```

You can call this manually inside the container, or later wire it into ENTRYPOINT if you want it automatic.

---

## 6. Build and run

From inside `tf-dl-stack` directory:

### Build

```bash
docker build -t tf-dl-stack .
# or
# podman build -t tf-dl-stack .
```

### Run (Jupyter via base CMD)

```bash
docker run -it --gpus all \
  -p 8888:8888 \
  -v "$PWD":/tf \
  tf-dl-stack
```

Then:

* Grab the tokenized Jupyter URL from logs
* Open it in your browser
* Start building notebooks in `/tf/notebooks` or directly in `/tf`

### Run (shell for debugging)

```bash
docker run -it --gpus all \
  -p 8888:8888 \
  -v "$PWD":/tf \
  tf-dl-stack \
  bash
```

Inside:

```bash
python -c "import tensorflow as tf; print(tf.__version__); print(tf.config.list_physical_devices('GPU'))"
python -c "import transformers, datasets; print('HF OK')"
```

---

