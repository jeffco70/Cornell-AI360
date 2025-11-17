# Tensorflow Base Image

```Dockerfile
FROM tensorflow/tensorflow:latest-gpu-jupyter
```

---

## 1. What the base image is doing (that you should be aware of)

From TensorFlow’s runtime Dockerfiles and the way the official images behave, plus their docs and logs, we can safely say:

### Working directory / notebook root

* Jupyter logs from the official images say:

  > Serving notebooks from local directory: **/tf** ([I Learned How To...][1])

* That’s because the Jupyter command in the image is effectively something like:

  ```bash
  jupyter notebook --notebook-dir=/tf --ip=0.0.0.0 --no-browser --allow-root
  ```

* So, **you should assume `/tf` is the main “project/notebook” root** inside the container.

In your derived Dockerfile, it’s totally fine (and often helpful) to make this explicit:

```Dockerfile
WORKDIR /tf
```

(Even if the base image already sets it, re-stating it is harmless and documents intent.)

---

### Default user

* The Jupyter logs clearly show everything running under **`/root`**:

  ````text
  Writing notebook server cookie secret to /root/.local/share/jupyter/runtime/...
  ``` :contentReference[oaicite:1]{index=1}  

  ````
* That strongly implies the container runs as **`root`** by default (no `USER` switch in the runtime image).

So, unless you change it, **your derived image will also run as root**.

If you *want* a non-root user (often a good idea for dev):

```Dockerfile
RUN useradd -ms /bin/bash dev && \
    chown -R dev:dev /tf
USER dev
WORKDIR /tf
```

Just remember: once you change `USER`, any `apt-get` steps must happen **before** that, or you’ll need `sudo` inside the container.

---

### Ports and Jupyter server

From the docs and examples for `*-jupyter` images: ([TensorFlow][2])

* Jupyter Notebook runs on **port 8888** inside the container.

* TensorFlow’s official docs show:

  ```bash
  docker run -it -p 8888:8888 tensorflow/tensorflow:nightly-jupyter
  ```

* The GPU-Jupyter image behaves the same, but with GPU support:

  ```bash
  docker run --gpus all -it -p 8888:8888 tensorflow/tensorflow:latest-gpu-jupyter
  ```

So, in your own Dockerfile, you can document this:

```Dockerfile
EXPOSE 8888
```

(not strictly required to work, but clarifies intent.)

---

## 2. How to *inspect* the base image yourself (super useful trick)

On your machine (Docker or Podman):

```bash
docker image inspect tensorflow/tensorflow:latest-gpu-jupyter \
  --format 'User: {{.Config.User}}  Workdir: {{.Config.WorkingDir}}  Cmd: {{.Config.Cmd}}  Entrypoint: {{.Config.Entrypoint}}'
```

You’ll see something like:

* `User:` (likely empty → root)
* `Workdir:` `/tf`
* `Cmd:` Jupyter notebook command
* `Entrypoint:` often empty or default shell

You can also dump all env vars:

```bash
docker run --rm tensorflow/tensorflow:latest-gpu-jupyter env | sort
```

That lets you see:

* CUDA-related env
* Any TensorFlow-specific env
* Jupyter settings

So if TensorFlow ever changes something in a newer tag, you can quickly re-check without digging through GitHub.

---

## 3. How to use this information in *your* Dockerfile

Given what we know, a good pattern for extending the image is:

```Dockerfile
FROM tensorflow/tensorflow:latest-gpu-jupyter

# Keep the same notebook root as the base image
WORKDIR /tf

# System deps (must be done as root)
RUN apt-get update && \
    apt-get install -y wget && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Python deps via requirements
COPY requirements.txt /tmp/requirements.txt
RUN pip install --upgrade pip && \
    pip install --no-cache-dir -r /tmp/requirements.txt

# Optional: Switch to a non-root user AFTER all apt/pip installs
# RUN useradd -ms /bin/bash dev && \
#     chown -R dev:dev /tf
# USER dev

EXPOSE 8888
# Let the base image's CMD/entrypoint keep running Jupyter
```

Key points:

* **Don’t change WORKDIR** unless you have a reason; living in `/tf` keeps you aligned with the Jupyter notebook root.
* **Do your `apt-get` and `pip` installs as root** before any `USER` change.
* **Let the base CMD run Jupyter** unless you explicitly want to override it.

---

[1]: https://ilearnedhowto.wordpress.com/2022/11/04/how-to-use-tensorflow-and-jupyter-in-a-machine-with-an-nvidia-gpu-using-docker/?utm_source=chatgpt.com "How to use Tensorflow and Jupyter in a machine with an ..."
[2]: https://www.tensorflow.org/install/docker "Docker  |  TensorFlow"
