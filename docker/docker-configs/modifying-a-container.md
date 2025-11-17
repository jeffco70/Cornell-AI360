# Modifying a container

Here’s a clean, repeatable way to do exactly that:

1. start a container
2. install new software inside it
3. turn that modified container into an image
4. launch new containers from that image

I’ll show the “quick & dirty” `docker commit` way (what you asked for), and briefly note the “proper” Dockerfile approach at the end.

---

## 1. Start from a base image

Pick a base image (e.g., Ubuntu):

```bash
docker pull ubuntu:22.04
```

Run a container interactively so you can install stuff:

```bash
docker run -it --name mytemp-ubuntu ubuntu:22.04 /bin/bash
```

* `--name mytemp-ubuntu` gives the container a readable name.
* `-it` attaches you to a shell (`/bin/bash`).

Now you’re **inside** the container.

---

## 2. Install new software inside the container

**Access a container shell**  

- in docker destop, click on the container icon in the left column.
- click on your running container.
- click on the `exec` tab.
- This provides access to a teminal shell inside the container.  Any commands you type hear are inside the containers linux environment.


**Inside the container shell**, do whatever setup you want. For example, install `curl` and `git`:

```bash
apt-get update
apt-get install -y curl git
```

You can also create directories, config files, etc.:

```bash
mkdir -p /opt/tools
echo "echo 'Hello from custom image'" > /opt/tools/startup.sh
chmod +x /opt/tools/startup.sh
```

When you’re done customizing, **exit** the container:

```bash
exit
```

Now you’re back on your host system.

---

## 3. Turn that container into a new image (`docker commit`)

List containers to confirm the name/ID:

```bash
docker ps -a
```

You should see something like:

```text
CONTAINER ID   IMAGE           COMMAND       NAMES
abcd1234...    ubuntu:22.04    "/bin/bash"   mytemp-ubuntu
```

Commit it to create a new image:

```bash
docker commit mytemp-ubuntu myubuntu:with-tools
```

* `mytemp-ubuntu` = container name
* `myubuntu:with-tools` = new image name + tag

You can also add a message:

```bash
docker commit -m "Ubuntu with curl, git, and /opt/tools" mytemp-ubuntu myubuntu:with-tools
```

Verify the image exists:

```bash
docker images
```

You should see `myubuntu` with tag `with-tools`.

---

## 4. (Optional) Export the image to a tar file

If by “export” you meant “save the image to a file” (for backup/sharing):

```bash
docker save -o myubuntu-with-tools.tar myubuntu:with-tools
```

Later, or on another machine, load it:

```bash
docker load -i myubuntu-with-tools.tar
```

This restores the image `myubuntu:with-tools`.

> Note: `docker export` works on **containers** and strips metadata; `docker save` works on **images** and is usually what you want for backup/transfer.

---

## 5. Start a **new** container from your custom image

Now run a fresh container that *starts* with all your installed software:

```bash
docker run -it --name myapp-container myubuntu:with-tools /bin/bash
```

Inside this new container you can verify:

```bash
curl --version
git --version
/opt/tools/startup.sh
```

All your previously installed tools and files should be there.

---

## 6. Make containers more convenient (entrypoint / default command)

If you want the container to always run a specific script or app, you can specify a default command when running:

```bash
docker run -it --name myapp-container myubuntu:with-tools /opt/tools/startup.sh
```

Or you can set an entrypoint in a **Dockerfile** later, but that’s extra polish.

---

## 7. “Proper” way (Dockerfile, for later)

What we did above is perfect for experimentation and quick custom images.
For long-term reproducibility, it’s better to codify your changes in a Dockerfile:

```Dockerfile
FROM ubuntu:22.04

RUN apt-get update && \
    apt-get install -y curl git && \
    rm -rf /var/lib/apt/lists/*

RUN mkdir -p /opt/tools && \
    echo "echo 'Hello from custom image'" > /opt/tools/startup.sh && \
    chmod +x /opt/tools/startup.sh

CMD ["/bin/bash"]
```

Build:

```bash
docker build -t myubuntu:with-tools .
```

Then run as before:

```bash
docker run -it --name myapp-container myubuntu:with-tools
```

---

