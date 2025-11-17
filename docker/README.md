# Tool and Environment Setup on Windows

Using Docker is an easy way to setup python and machine learning environments.

Docker provides a consistent, isolated, and reproducible environment for running tools like Jupyter Notebooks, Orange, Prometheus, and machine-learning or data-science workloads. Instead of manually installing and configuring complex dependencies—often with conflicting versions—Docker encapsulates everything in a portable image that runs the same way on any machine. This eliminates “it works on my laptop” problems, accelerates onboarding, and ensures experiments, pipelines, and dashboards are fully reproducible months later. For ML and data science specifically, Docker streamlines GPU setup, dependency pinning, version control of environments, and the ability to run multiple independent stacks side-by-side without interference. It also enables easy scaling: containers can be deployed locally, on servers, or in the cloud with no changes, making Docker ideal for modern analytics workflows.


## Setup Overview

1. Install [Windows Terminal](setup/windows-terminal.md)
2. Install multiple tools with virtualization & GPU support
   - Following these instruction - [Docker / WSL2 / VMWare Virtualization](setup/docker-wsl-vmware.md)
   - **WSL2 & Docker are required**.  VMWare is optional and we do not anticipate using it by the team.
3. Docker Images
   - We will typically be using the [tensorflow-image](tensorflow-image)
   - You may also be interested in the [orange-image](orange-image)
4. Examples
   - See [jupyter-notebook-examples](jupyter-notebook-examples) for short examples using jupyter notebooks to access and manipulate data.

## getting started with tensorflow

Note: Prerequisite - [Install Docker](setup/docker-wsl-vmware.md)

TensorFlow is an open-source machine learning framework developed by Google that provides a flexible, efficient platform for building, training, and deploying deep learning models. It supports a wide range of neural network architectures—from basic linear models to large-scale convolutional, recurrent, and transformer-based systems—using a computation graph approach that enables optimized execution on CPUs, GPUs, and TPUs. With high-level APIs like Keras for rapid model development and low-level operations for full customization, TensorFlow is widely used for tasks such as computer vision, natural language processing, reinforcement learning, and time-series forecasting.

See the [Tensorflow-image](tensorflow-image) directory for more more information.