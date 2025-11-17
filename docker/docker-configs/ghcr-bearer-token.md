# Setting up a Github ghcr.io bearer token

To push or pull images from **GitHub Container Registry (GHCR)** using Podman or Docker, you authenticate using a **GitHub Personal Access Token (PAT)**.
This PAT functions as a **Bearer Token** for `ghcr.io`.

Below is the exact way to generate and use it.

---

# ✅ **Step 1 — Create a GitHub Personal Access Token (PAT)**

### 1. Go to GitHub:

[https://github.com/settings/tokens?type=beta](https://github.com/settings/tokens?type=beta)
(or classic tokens: [https://github.com/settings/tokens](https://github.com/settings/tokens))

### 2. Create a new token with the correct scopes.

### If you use the **fine-grained token (recommended)**:

Choose:

* **Resource owner** → your account
* **Repository access** → *All repositories* (or better: the specific repo)
* **Permissions → Packages → Read and write**

  * Read packages: **✔️**
  * Write packages: **✔️**

### If you use a **classic PAT**:

Check:

* **write:packages**
* **read:packages**
* *(optional)* `delete:packages`

Copy the token—you will not see it again.

This token is your **Bearer Token** for GHCR.

---

# ✅ **Step 2 — Log in to GHCR using Podman (or Docker)**

Use your **GitHub username** and the **PAT** as the password:

```powershell
podman login ghcr.io
```

When prompted:

* **Username:** your GitHub username (e.g., `jflachman`)
* **Password:** your GitHub PAT
  *(paste the token)*

If successful:

```
Login Succeeded!
```

Podman stores the PAT and automatically uses it as a Bearer token.

---

# ✅ **Step 3 — Tag your image for GHCR**

Images pushed to GHCR must follow this format:

```
ghcr.io/<github-username>/<image-name>:<tag>
```

Example:

```powershell
podman tag orange-docker ghcr.io/jflachman/orange-docker:latest
```

---

# ✅ **Step 4 — Push the image to GHCR**

```powershell
podman push ghcr.io/jflachman/orange-docker:latest
```

You’ll see output like:

```
Copying blob ...
Writing manifest ...
Storing signatures
```

---

# 🔍 **Using the Bearer Token Manually (Optional Advanced)**

If you want to inspect the actual token Podman sends:

```powershell
podman login --get-login ghcr.io
```

Or look at:

```
$env:USERPROFILE\.config\containers\auth.json
```

Podman stores:

* The registry host
* Your username
* Your PAT encoded as base64
* Used as the Authorization: Bearer token

---

# 🔄 **Pulling Images from GHCR**

```powershell
podman pull ghcr.io/jflachman/orange-docker:latest
```

---

# 🎯 Summary

| Action          | Command                                   |
| --------------- | ----------------------------------------- |
| Create PAT      | GitHub → Settings → Tokens                |
| Required scopes | `read:packages`, `write:packages`         |
| Login           | `podman login ghcr.io`                    |
| Tag image       | `podman tag local ghcr.io/user/image:tag` |
| Push image      | `podman push ghcr.io/user/image:tag`      |

---
