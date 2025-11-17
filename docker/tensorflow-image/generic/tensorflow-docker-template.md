# Tensorflow Docker Template

Here’s a practical “owner’s manual” for that TensorFlow GPU + Jupyter template you just built.

I’ll walk through:

1. What the template gives you
2. Prerequisites (Docker/Podman, WSL2, GPU)
3. How to configure each part (apt, pip, mamba, scripts)
4. How to build the image
5. How to run and use it (Jupyter, shell, volumes)
6. How to update it cleanly
7. Common workflows and troubleshooting

---

## 1. What this template is

You have a project like:

```text
tf-gpu-template/
│
├── Dockerfile
├── requirements.txt
├── environment.yml
└── scripts/
    ├── download_data.sh
    └── post_start.sh
```

And the **Dockerfile**:

* Extends `tensorflow/tensorflow:latest-gpu-jupyter`
* Keeps the working directory at `/tf`
* Installs OS tools with `apt-get`
* Installs Python packages from `requirements.txt` via `pip`
* Optionally installs Mambaforge and updates the base conda env from `environment.yml`
* Optionally runs custom scripts (e.g., `post_start.sh`)
* Exposes port `8888` (Jupyter)

You’ll use this as a generic “ML/quant dev” base and just toggle or edit sections as you need.

---

## 2. Prerequisites

You should have:

* **Windows 10/11 with WSL2** working
* Either:

  * **Docker Desktop** (with WSL2 backend enabled), or
  * **Podman Desktop** running against WSL2
* **NVIDIA GPU drivers** installed on Windows
* **NVIDIA Container Toolkit** installed in the WSL distro if you’re using Docker-in-WSL (for `--gpus all` to work). With Podman, use the Podman equivalent GPU flags.

On the Linux side (inside WSL):

```bash
docker --version       # or podman --version
nvidia-smi             # should report the GPU from inside WSL
```

---

## 3. Configuring the template

### 3.1 APT packages (system-level tools)

In the Dockerfile:

```Dockerfile
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
```

**How to use it:**

* Add OS-level tools here: compilers, system libs, CLI tools.

* For example, to add `ffmpeg` and `libgl1`:

  ```Dockerfile
  apt-get install -y --no-install-recommends \
      git \
      curl \
      wget \
      build-essential \
      nano \
      htop \
      ffmpeg \
      libgl1 \
  ```

* If you don’t need something (like `nano`), comment it out or remove it.

**Rule of thumb:**
OS libraries, dev headers, compilers → `apt-get`.
Python libraries → `pip` or `mamba/conda`.

---

### 3.2 PIP packages (`requirements.txt`)

Your `requirements.txt`:

```text
# Basic data science stack
pandas
seaborn
scikit-learn

# Jupyter enhancements
jupyterlab

# Add more:
# xgboost
# lightgbm
# matplotlib
# numba
```

**How to use it:**

* Add standard Python packages here (especially pure Python or pip-friendly libs).
* When you change `requirements.txt`, **rebuild** the image (see build section).
* Best practice: don’t install “ad hoc” packages inside a running container if you care about reproducibility; instead, add to `requirements.txt` and rebuild.

---

### 3.3 Mamba / Conda (`environment.yml`)

Your `environment.yml`:

```yaml
name: base
channels:
  - conda-forge
dependencies:
  - numpy
  - scipy
  - statsmodels
  - numba
  - pytables
  - pyarrow
  - mamba
  - pip
  - pip:
      - ta
      - yfinance
```

The Dockerfile:

* Installs **Mambaforge**
* Sets `PATH=/opt/mambaforge/bin:$PATH`
* Runs:

  ```Dockerfile
  mamba env update -n base -f /tmp/environment.yml && \
      conda clean -afy
  ```

**How to use it:**

* Put packages here that are better installed via conda (heavy numeric libs, things with complex C/Fortran deps).
* Use `channels: ["conda-forge"]` for reproducible, modern packages.
* For pip-only libraries, either:

  * Put them under the `pip:` section of `environment.yml`, or
  * Keep them in `requirements.txt` (both are fine; just be consistent).

Inside the container, you can confirm:

```bash
conda list | head
mamba list | head
```

---

### 3.4 Wget-based data or tools (`scripts/download_data.sh` and Dockerfile wget)

You have two options for downloads:

1. **At build time** (in Dockerfile):

   ```Dockerfile
   RUN mkdir -p /tf/data && \
       wget -O /tf/data/sample_data.csv "https://example.com/sample_data.csv" || true
   ```

   * Use this for small, stable datasets or tools that you want baked into the image.
   * The `|| true` prevents build failure if the URL is placeholder during early development.

2. **At runtime** via `scripts/download_data.sh`:

   ```bash
   ./scripts/download_data.sh
   ```

   * Use this for larger/variable datasets or things you might refresh periodically.
   * You can wire this into `post_start.sh` if you want automatic downloads on first run.

---

### 3.5 `post_start.sh` (runtime hook)

`scripts/post_start.sh` is a place for “stuff to do when the container starts”:

* Print info (user, workdir)
* Git clone repos
* Kick off data downloads
* Preload models

You have two ways to use it:

1. **Manual:**
   Start container, then run inside:

   ```bash
   /usr/local/bin/post_start.sh
   ```

2. **Automatic (advanced / optional):**
   Change the Dockerfile to make it the ENTRYPOINT and then start Jupyter from it.

   For example (if you decide later):

   ```Dockerfile
   ENTRYPOINT ["/usr/local/bin/post_start.sh"]
   CMD ["bash", "-lc", "jupyter lab --ip=0.0.0.0 --no-browser --allow-root --notebook-dir=/tf"]
   ```

For now, you can leave it as a utility script and call it when needed.

---

### 3.6 Optional: non-root user

If you want to run as a non-root user (recommended for long-term dev), uncomment something like:

```Dockerfile
RUN useradd -ms /bin/bash dev && \
    chown -R dev:dev /tf
USER dev
```

Key rules:

* All `apt-get` and system-level stuff must happen **before** `USER dev`.
* After switching to `dev`, you can still use `pip` for user-level installs.
* If you need root again, you’d have to use `sudo` (which you’d also have to configure).

---

## 4. Building the image

From inside the `tf-gpu-template` directory (where the Dockerfile is):

### Docker

```bash
docker build -t tf-gpu-template .
```

### Podman

```bash
podman build -t tf-gpu-template .
```

You can tag it more specifically:

```bash
docker build -t tf-gpu-template:tf2.17-py311 .
```

If you change `Dockerfile`, `requirements.txt`, or `environment.yml`, rebuild.

---

## 5. Running and using the image

### 5.1 Basic interactive shell

Docker:

```bash
docker run -it --gpus all \
  -p 8888:8888 \
  -v "$PWD":/tf \
  tf-gpu-template \
  bash
```

Podman (GPU flags vary by setup, but conceptually):

```bash
podman run -it \
  --hooks-dir=/usr/share/containers/oci/hooks.d \
  -e NVIDIA_VISIBLE_DEVICES=all \
  -p 8888:8888 \
  -v "$PWD":/tf \
  tf-gpu-template \
  bash
```

Explanation:

* `--gpus all` (or Podman equivalent) enables GPU access.
* `-p 8888:8888` maps container’s Jupyter port to host.
* `-v "$PWD":/tf` maps your current project directory into `/tf` (which is the workdir in the image).

### 5.2 Let base image start Jupyter automatically

The `tensorflow/tensorflow:latest-gpu-jupyter` base image already has a Jupyter CMD, so you can just:

```bash
docker run -it --gpus all \
  -p 8888:8888 \
  -v "$PWD":/tf \
  tf-gpu-template
```

Then in the logs, you’ll see a Jupyter URL with a token, e.g.:

```
http://127.0.0.1:8888/?token=...
```

Open that in your browser.

### 5.3 Explicit Jupyter Lab command (if you override CMD later)

If you override CMD in the Dockerfile (e.g., to use `bash` by default), you can launch Jupyter manually:

```bash
jupyter lab --ip=0.0.0.0 --no-browser --allow-root --notebook-dir=/tf
```

From inside the running container.

---

## 6. Updating the environment

### 6.1 Adding a Python package

1. Add it to `requirements.txt` or `environment.yml`

2. Rebuild:

   ```bash
   docker build -t tf-gpu-template .
   ```

3. Stop/remove old containers, run new container.

This guarantees your environment is reproducible.

### 6.2 Adding a system package

1. Add the package to the `apt-get install` block.
2. Rebuild the image.

### 6.3 Quick and dirty: install inside a running container

You *can*:

```bash
pip install somepackage
```

inside a running container for a one-off test, but:

* Those changes disappear if you delete the container.
* They are not captured in the Dockerfile → not reproducible.

Good workflow:

* Test quickly inside container.
* If you like it, add to `requirements.txt` or `environment.yml` and rebuild.

---

## 7. Common workflows

### 7.1 New project using this template

1. Copy the whole `tf-gpu-template` directory to a new folder.
2. Rename the image tag in the `docker build` command.
3. Edit:

   * `requirements.txt` for project-specific libs
   * `environment.yml` for heavy conda libs
   * `scripts/post_start.sh` to clone that project’s repos / data
4. Build and run.

### 7.2 Exporting the image

To share or back it up:

```bash
docker save -o tf-gpu-template.tar tf-gpu-template
```

On another machine:

```bash
docker load -i tf-gpu-template.tar
```

### 7.3 Cleaning up

List containers:

```bash
docker ps -a
```

Stop:

```bash
docker stop <id-or-name>
```

Remove:

```bash
docker rm <id-or-name>
```

Remove image:

```bash
docker rmi tf-gpu-template
```

---

## 8. Troubleshooting tips

* **Jupyter not reachable**

  * Check `-p 8888:8888` is in the run command.
  * Make sure Jupyter is actually running (`docker logs <container>`).

* **GPU not visible in container**

  * Inside container: `nvidia-smi`.
  * If it fails:

    * Confirm host `nvidia-smi` works.
    * Confirm `--gpus all` (Docker) or equivalent Podman GPU setup is correct.
    * Check NVIDIA Container Toolkit or Podman GPU hooks setup.

* **Conda/mamba not found**

  * Inside container: `which conda`, `which mamba`.
  * If empty, verify PATH is set as:

    ```Dockerfile
    ENV PATH=/opt/mambaforge/bin:$PATH
    ```

* **Package version conflicts**

  * Try to keep heavy numeric stuff in `environment.yml` (conda), and lighter or pure Python libs in `requirements.txt`.
  * If you hit conflicts, pin versions explicitly.

---

If you want to tune this specifically for:

* a “quant research” stack (specific Python libs for trading/backtesting), or
* a “deep learning” stack (e.g., TensorFlow + PyTorch + ONNX + RL libs),

I can draft a concrete `requirements.txt` and `environment.yml` tailored to that use case next.
