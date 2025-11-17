# Tensorflow 

TensorFlow is an open-source machine learning framework developed by Google that provides a flexible, efficient platform for building, training, and deploying deep learning models. It supports a wide range of neural network architectures—from basic linear models to large-scale convolutional, recurrent, and transformer-based systems—using a computation graph approach that enables optimized execution on CPUs, GPUs, and TPUs. With high-level APIs like Keras for rapid model development and low-level operations for full customization, TensorFlow is widely used for tasks such as computer vision, natural language processing, reinforcement learning, and time-series forecasting.

These instructions assume you have already [installed docker](../setup/README.md)

## Pulling and Running Tensorflow

The authoritive source for Tensorflow docker images is here: https://hub.docker.com/r/tensorflow/tensorflow

### 1. Pull a tensorflow image

**with GPU & Jupyter support**

```
docker pull tensorflow/tensorflow:latest-gpu
```

**with CPU and Jupyter support** - without GPU support

```
docker pull tensorflow/tensorflow:latest-jupyter
```

### 2. Run a container from the image

The easiest way to run and configure a docker container is from the command line or [windows terminal](../setup/windows-terminal.md)

**IMPORTANT:** the `-v` line maps a folder on your host computer to a folder inside the tensorflow container.  So below: `C:\trade\ml` on my computer is mapped to `/tf/notebooks` in the tensorflow container.  Change this path to your preferred location:  i.e. `C:\users\your-user-name\Documents\notebooks`.  So the new line would be `-v C:\users\your-user-name\Documents\notebooks:/tf/notebooks:Z `

**With GPU Support**

```powershell
docker run -d `
  --name tensorflow-jupyter-GPU `
  --device nvidia.com/gpu=all `
  -v C:\trade\ml:/tf/notebooks:Z `
  -p 8888:8888 `
  tensorflow/tensorflow:latest-gpu-jupyter
```

**Without GPU Support**

```powershell
docker run -d `
  --name tensorflow-jupyter `
  -v C:\trade\ml:/tf/notebooks:Z `
  -p 8888:8888 `
  tensorflow/tensorflow:latest-jupyter
```

### 3. Getting Started

See the [getting-started](getting-started.md) page for a more detailed desription on running and testing your container.


## Modifying the Tensorflow base image

**Problem Statement:**
When you run a Docker image, you’re launching an isolated container based on that image. Any software you install or changes you make inside the running container exist **only** within that container. Once the container is removed, those changes disappear.
To preserve enhancements, you should **extend the base TensorFlow image and build a new image** that includes your additional packages and configuration.

This section describes how to create your own TensorFlow-based images with the enhancements you need.

### Base Image

Review the [base-image](base-image.md) document if you want background on the TensorFlow GPU Jupyter image used as the foundation for all templates.

### Templates

Three template directories are provided for extending the base TensorFlow image:

1. **Generic Template:**
   The [TensorFlow Docker Template](generic/tensorflow-docker-template.md) offers a minimal structure for adding your own tools, libraries, and configuration to the base TensorFlow image.

2. **Quant Research Template:**
   The [Quant Research Template](quant-research/quant-research-build-instructions.md) comes preloaded with a broad collection of quantitative finance and research libraries.
   You can use ChatGPT to evaluate, trim, or customize the library set to match your specific workflow.

3. **Deep Learning Template:**
   The [Deep Learning Template](deep-learning/machine-learning-build-instructions.md) includes a curated set of deep learning packages and frameworks.
   ChatGPT can help you adjust this list based on your project’s requirements.

---
