# Building an Image

---

# 1. Create a project folder

Pick or create a directory for your new image:

```bash
mkdir myapp
cd myapp
```

---

# 2. Create a Dockerfile

Inside your project folder, create a file named **Dockerfile** (no extension):

```bash
nano Dockerfile
```

Example Dockerfile:

```Dockerfile
# Base image
FROM ubuntu:22.04

# Non-interactive installation (avoid tzdata prompts)
ENV DEBIAN_FRONTEND=noninteractive

# Update and install required packages
RUN apt-get update && \
    apt-get install -y curl git && \
    rm -rf /var/lib/apt/lists/*

# Copy local files into the image (optional)
COPY ./scripts /opt/scripts

# Make your script executable (optional)
RUN chmod +x /opt/scripts/startup.sh

# Default working directory inside the container
WORKDIR /opt/scripts

# Default command when container starts
CMD ["bash"]
```

---

# 3. (Optional) Add supporting files

If your Dockerfile references local files (e.g., scripts), create them:

```
myapp/
│
├── Dockerfile
└── scripts/
    └── startup.sh
```

`startup.sh` example:

```bash
#!/bin/bash
echo "Container started successfully!"
```

Make sure the script is executable:

```bash
chmod +x scripts/startup.sh
```

---

# 4. Build the Docker image

From inside the folder **where the Dockerfile lives**, run:

```bash
docker build -t myubuntu:with-tools .
```

Breakdown:

* `docker build` — build an image
* `-t myubuntu:with-tools` — give it a name and tag
  (format: `repository:tag`)
* `.` — use the current directory as build context

---

# 5. Verify the image exists

```bash
docker images
```

Example output:

```
REPOSITORY   TAG          IMAGE ID       CREATED         SIZE
myubuntu     with-tools   abcd1234efgh   10 seconds ago  125MB
```

---

# 6. Run a container from the new image

```bash
docker run -it --name mycontainer myubuntu:with-tools
```

This drops you into a bash shell inside your custom container.

---

# 7. Run a container in detached mode (optional)

```bash
docker run -d --name myservice myubuntu:with-tools sleep infinity
```

---

# 8. Override default command (optional)

```bash
docker run -it myubuntu:with-tools bash /opt/scripts/startup.sh
```

---

# 9. Tag and push the image to a registry (optional)

Tag for Docker Hub:

```bash
docker tag myubuntu:with-tools mydockerhubusername/myubuntu:with-tools
```

Push:

```bash
docker push mydockerhubusername/myubuntu:with-tools
```

---

# 10. Clean up

Stop a running container:

```bash
docker stop mycontainer
```

Remove container:

```bash
docker rm mycontainer
```

Remove image:

```bash
docker rmi myubuntu:with-tools
```

---

# Summary

### Minimum files

```
myapp/
└── Dockerfile
```

### Minimum Dockerfile

```Dockerfile
FROM ubuntu:22.04
RUN apt-get update && apt-get install -y curl
CMD ["bash"]
```

### Build & run

```bash
docker build -t myimage:latest .
docker run -it myimage:latest
```

---
