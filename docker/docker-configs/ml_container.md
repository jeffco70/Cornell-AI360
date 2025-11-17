# Machine Learning Container

The official TensorFlow container is a good superset of ML libraries.

See: https://hub.docker.com/r/tensorflow/tensorflow

Note:  to run using `podman` simply replace `docker` with `podman` in the commands below.

## Launch Using Docker

In Powershell run the following:

### 1. Pull the image from Dockerhub

**With GPU Support:**
```
docker pull tensorflow/tensorflow:latest-gpu-jupyter
```

**CPU-Only Version:**
```
docker pull tensorflow/tensorflow:latest-jupyter
```

### 2. Run with Your Local Directory Mapped

**With GPU Support:**
```powershell
docker run -d `
  --name tensorflow-jupyter-gpu `
  --device nvidia.com/gpu=all `
  -v C:\ml:/tf/notebooks:Z `
  -p 8888:8888 `
  tensorflow/tensorflow:latest-gpu-jupyter
```

**CPU-Only Version:**
```powershell
docker run -d `
  --name tensorflow-jupyter `
  -v C:\ml:/tf/notebooks:Z `
  -p 8888:8888 `
  tensorflow/tensorflow:latest-jupyter
```

### 3. Get the Jupyter Token

```powershell
docker logs tensorflow-jupyter
```

Look for output like:
```
http://127.0.0.1:8888/?token=abc123def456...
```

Copy that full URL into your browser!

### 4. Access Your Files

Your `C:\ml` directory will be available in Jupyter at:
- The root notebooks directory (`/tf/notebooks`)
- All your files will appear in the Jupyter file browser

## Verify GPU Access (if using GPU version)

Create a new notebook in Jupyter and run:

```python
import tensorflow as tf

# Check TensorFlow version
print(f"TensorFlow version: {tf.__version__}")

# Check GPU availability
print(f"GPU available: {tf.config.list_physical_devices('GPU')}")
print(f"Built with CUDA: {tf.test.is_built_with_cuda()}")

# Test GPU
if tf.config.list_physical_devices('GPU'):
    with tf.device('/GPU:0'):
        a = tf.constant([[1.0, 2.0], [3.0, 4.0]])
        b = tf.constant([[1.0, 1.0], [0.0, 1.0]])
        c = tf.matmul(a, b)
        print("GPU computation successful!")
        print(c)
```

--- 

