# Getting Started with Tensorflow & Jupyter Container

Here’s a compact step-by-step you can follow on Windows with the TensorFlow Jupyter GPU container.

**Note:**  See the following for additional information

- [volume configurations](../docker-podman/volume-config.md)
- [port mapping](../docker-podman/port-mapping.md)

---

## 1. Start the container with the volume mapped

In PowerShell:

```powershell
docker run -d `
  --name tensorflow-jupyter-GPU `
  --device nvidia.com/gpu=all `
  -v C:\trade\ml:/tf/notebooks `
  -p 8888:8888 `
  tensorflow/tensorflow:latest-gpu-jupyter
```

Notes:

* `C:\trade\ml` = folder on your host. you can change it to `C:\Users\your-user-name\Documents\notebooks` or wherever you want to store your files.
* `/tf/notebooks` = working directory inside the container (Jupyter’s default in this image)
* Anything saved in `/tf/notebooks` will appear in `C:\trade\ml` and vice versa.
* ***You may replace `C:\trade\ml`*** with the path to your desired local folder, or you may create the `C:\trade\ml` folder on your computer.

---

## 2. Copy `docker-container-contents.ipynb` 

See: [docker-container-contents.ipynb](../jupyter-notebook-examples/docker-container-contents.ipynb)

Put it directly in the mapped folder.

Inside the container (and in Jupyter), it will show up as:

```text
/tf/notebooks/docker-container-contents.ipynb
```

---

## 3. Get the Jupyter token and URL

The TensorFlow Jupyter image prints the access URL (with token) to the container logs.

In PowerShell:

```powershell
docker logs tensorflow-jupyter-GPU
```

Look for a line like:

```text
    To access the notebook, open this file in a browser:
        http://127.0.0.1:8888/?token=abc123...   # example
```

Copy that full URL.

---

## 4. Access Jupyter in your browser

Paste the URL into your browser, e.g.:

```text
http://127.0.0.1:8888/?token=abc123...
```

If you only see `http://127.0.0.1:8888/lab` without a token, you can manually add the token you saw in the logs:

```text
http://127.0.0.1:8888/?token=abc123...
```

---

## 5. Open and run `docker-container-contents.ipynb`

Inside the Jupyter file browser:

1. Navigate to the `/tf/notebooks` folder (it should be the default root).
2. Click `docker-container-contents.ipynb`.
3. Use **Kernel → Restart & Run All** (or run cells one by one) to execute the notebook and inspect:

   * GPU visibility / `tf.config.list_physical_devices('GPU')`
   * Installed packages
   * Pip libraries, etc.

As you save the notebook, changes are written to `/tf/notebooks/docker-container-contents.ipynb`, which is **`C:\trade\ml\docker-container-contents.ipynb` on your host**, so it persists even when the container is removed.
