# Running Docker

## Instructions

1. Setup/Install - [WSL / Docker / (optional: VMWare)](../setup/docker-wsl-vmware.md)
2. Pull a container and start it up. 
   - [ml_container](ml_container.md) - how to setup an ML container
   - You may also see: [tensorflow-image](../tensorflow-image/README.md)

## Settings you may adjust in the startup of a container

- [port-mapping.md](port-mapping.md) - mapping http ports to access web servers in the container
- [volume-config.md](volume-config.md) - mapping directories on your computer to directories in the container linux environment

## Checking the container contents

The easiest way to see what is installed in the container that uses jupyter notebooks is to load this [notebook](../jupyter-notebook-examples/docker-container-contents.ipynb) in jupyter notebooks.  

INSTRUCTIONS:  Copy `docker-container-contents.ipynb` in the folder you mapped to your docker container when you started the container in powershell.

Remember:
- you modified  `{path_to_data_folder_on_host}` to a directory on your computer such as `C\trade\notebooks` or `C:\users\your-user-name\Documents\notebooks`.
- you did this in the line `-v C:\trade\ml:/tf/notebooks:Z ` or however you set your mapping.

Jupyter notebook file: [docker-container-contents.ipynb](../jupyter-notebook-examples/docker-container-contents.ipynb)

# Where to get containers

- Many container images are stored on [`hub.docker.com`](https://hub.docker.com)
- Github also has a container repository.  However, there is no way to search it.  If the developer of a capability hosts their container on `ghrc.io` then they will provide a link to pull that image.  However, you may need to setup a [ghrc-bearer-token](ghrc-bearer-token.md) to access it.  This link provides instructions from chatGPT on setting up the token.  I have not verified the instructions.  Give them a try.

## Containers of Interest:

For many ML images, you can select a GPU/CUDA version or a regular CPU version.

- https://hub.docker.com/r/tensorflow/tensorflow - includes jupyter
- https://hub.docker.com/r/pytorch/pytorch - includes jupyter
- https://hub.docker.com/r/jflachman/orange-docker - Orange graphical ML environment (Lloyd has used this)


## Modifying or building a docker image

### Build a Dockerfile

You may build a dockerfile from scratch using a `Dockerfile` to define how to pull a base image, install and configure the software you want.

See: [building-an-image.md](building-an-image.md)

### Modify a Docker Image

You may install software in an existing container and then save the current configuration as an image.

See: [modifying-a-container.md](modifying-a-container.md)
