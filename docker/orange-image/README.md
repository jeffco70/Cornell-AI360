# Build & Run Orange in Docker.

## Use prebuilt docker image

### Pull the image

**Jeff's Image - no password**

```
docker pull jflachman/orange-docker
```

### Run the image

Note:  Update `{path_to_data_folder_on_host}` to a directory on your computer such as `C\trade\orange-data` or `C:\users\your-user-name\Documents\orange-data`

In powershell, run:

```
docker run --init --rm -d `
  -p 6080:6080 `
  -v {path_to_data_folder_on_host}:/data `
  -e SHARED=0 `
  --name orange-nopass `
  jflachman/orange-docker
```

### Access Orange

Goto: https://localhost:6080/vnc.html

Click on the `VNC button` and you should have access without the need for a password.  If you want to require a password, then goto https://github.com/biolab/orange-docker and build from their Dockerfile.

## The official Orange Image

**Official Image**

See: https://github.com/biolab/orange-docker 

**IMPORTANT Prerequisites:**  Setup a [ghrc.io bearer token](../docker-podman/ghcr-bearer-token.md) to authenticate with ghrc.io to pull images.

```
docker pull ghcr.io/biolab/orange-docker:latest
```

## Build Orange Docker Image

1. In powershell, `cd` to this directory with the `Dockerfile`.
2. run docker build

```
docker build --no-cache -t orange-docker .
```

## Run Orange

**Note:**  This image does not require a login password.

```
docker run --init --rm -d `
  -p 6080:6080 `
  -v {path_to_data_folder_on_host}:/data `
  -e SHARED=0 `
  --name orange-nopass `
  orange-docker
```

## Access via a web browser

- http://localhost/vnc.html

Drag and resize the window to fit your needs.