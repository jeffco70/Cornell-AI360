# Mapping Multiple Volumes

## Map Two Volumes

```powershell
podman run -d `
  --name tensorflow-jupyter `
  --device nvidia.com/gpu=all `
  -v C:\trade\ml:/tf/notebooks:Z `
  -v C:\trade\data:/tf/data:Z `
  -p 8888:8888 `
  tensorflow/tensorflow:latest-gpu-jupyter
```

## Map Multiple Volumes

You can map as many as you need:

```powershell
podman run -d `
  --name tensorflow-jupyter `
  --device nvidia.com/gpu=all `
  -v C:\trade\ml:/tf/notebooks:Z `
  -v C:\trade\data:/tf/data:Z `
  -v C:\trade\models:/tf/models:Z `
  -v C:\trade\datasets:/tf/datasets:Z `
  -p 8888:8888 `
  tensorflow/tensorflow:latest-gpu-jupyter
```

## Common Volume Mapping Patterns

### Separate Code, Data, and Models
```powershell
podman run -d `
  --name tensorflow-jupyter `
  --device nvidia.com/gpu=all `
  -v C:\trade\ml:/tf/notebooks:Z `
  -v D:\datasets:/tf/data:Z `
  -v E:\models:/tf/models:Z `
  -p 8888:8888 `
  tensorflow/tensorflow:latest-gpu-jupyter
```

### Map to Different Container Paths
```powershell
podman run -d `
  --name tensorflow-jupyter `
  --device nvidia.com/gpu=all `
  -v C:\trade\ml:/tf/notebooks:Z `
  -v C:\Users\YourName\Documents\data:/home/data:Z `
  -v C:\trade\output:/workspace/output:Z `
  -p 8888:8888 `
  tensorflow/tensorflow:latest-gpu-jupyter
```

## Access Your Volumes in Jupyter

After starting the container, your directories will be available at:
- `C:\trade\ml` → `/tf/notebooks` (your notebooks folder)
- `C:\trade\data` → `/tf/data` (your data folder)
- `C:\trade\models` → `/tf/models` (your models folder)

You can access them in your notebooks like this:

```python
import os
import pandas as pd

# List files in each volume
print("Notebooks:", os.listdir('/tf/notebooks'))
print("Data:", os.listdir('/tf/data'))
print("Models:", os.listdir('/tf/models'))

# Read data from the data volume
df = pd.read_csv('/tf/data/my_dataset.csv')

# Save model to models volume
# model.save('/tf/models/my_model.h5')
```

## Using Podman Compose with Multiple Volumes

If you prefer using compose:

```yaml
version: '3.8'

services:
  tensorflow-jupyter:
    image: tensorflow/tensorflow:latest-gpu-jupyter
    container_name: tensorflow-jupyter
    ports:
      - "8888:8888"
    volumes:
      - C:\trade\ml:/tf/notebooks:Z
      - C:\trade\data:/tf/data:Z
      - C:\trade\models:/tf/models:Z
      - C:\trade\datasets:/tf/datasets:Z
    devices:
      - nvidia.com/gpu=all
    restart: unless-stopped
```

Then run:
```powershell
podman-compose up -d
```

## Important Notes

1. **The `:Z` flag** is for SELinux labeling (recommended for security)
2. **Create directories first** if they don't exist:
   ```powershell
   New-Item -ItemType Directory -Force -Path C:\trade\data
   New-Item -ItemType Directory -Force -Path C:\trade\models
   ```

3. **Verify mounts** after starting:
   ```powershell
   podman exec tensorflow-jupyter ls -la /tf/
   ```

4. **Read-only volumes** (optional):
   ```powershell
   -v C:\trade\data:/tf/data:ro,Z  # Read-only
   ```


# Volume sharing or isolation

The `:Z` flag in the volume declaration is related to **SELinux (Security-Enhanced Linux) labeling**. Here's what it does:

## What `:Z` Does

The `:Z` flag tells Podman to:
- **Relabel the volume content** with a private, unshared SELinux label
- Make the volume content **accessible only to that specific container**
- Provide **isolation between containers** - other containers cannot access this volume

## SELinux Label Options

### `:Z` (Private/Unshared)
```powershell
-v C:\trade\ml:/tf/notebooks:Z
```
- Volume is **private** to this container
- Highest security isolation
- Use when the volume should only be accessed by this one container

### `:z` (Shared) - lowercase
```powershell
-v C:\trade\ml:/tf/notebooks:z
```
- Volume can be **shared** between multiple containers
- Less restrictive than `:Z`
- Use when multiple containers need to access the same volume

### No flag
```powershell
-v C:\trade\ml:/tf/notebooks
```
- No SELinux relabeling
- May cause **permission denied** errors on SELinux-enabled systems
- Works fine on systems without SELinux (like most Windows/WSL2 setups)

## When Do You Need It?

### **On Windows with Podman/WSL2:**
You typically **don't need** `:Z` because:
- Windows doesn't use SELinux
- WSL2 usually doesn't have SELinux enabled
- The flag is often ignored but doesn't hurt

### **On Linux with SELinux enabled:**
You **should use** `:Z` or `:z` to avoid permission errors:
```bash
# On RHEL, Fedora, CentOS
-v /path/to/data:/container/path:Z  # Required!
```

## Practical Examples

### Single Container (Use :Z)
```powershell
podman run -d `
  --name tensorflow-jupyter `
  -v C:\trade\ml:/tf/notebooks:Z `
  -p 8888:8888 `
  tensorflow/tensorflow:latest-gpu-jupyter
```

### Multiple Containers Sharing Volume (Use :z)
```powershell
# Container 1
podman run -d `
  --name jupyter1 `
  -v C:\trade\shared:/data:z `
  jupyter/datascience-notebook

# Container 2 - can access same volume
podman run -d `
  --name jupyter2 `
  -v C:\trade\shared:/data:z `
  jupyter/tensorflow-notebook
```

### Read-only Volume
```powershell
-v C:\trade\data:/tf/data:ro,Z  # Read-only + SELinux label
```

## Other Volume Options

You can combine multiple flags:

```powershell
# Read-only with SELinux
-v C:\trade\ml:/tf/notebooks:ro,Z

# Shared and read-only
-v C:\trade\data:/tf/data:ro,z

# Just read-only (no SELinux)
-v C:\trade\ml:/tf/notebooks:ro
```

## Should You Use :Z on Windows?

**Short answer:** It doesn't hurt, but it's usually not necessary.

```powershell
# These are equivalent on Windows/WSL2:
-v C:\trade\ml:/tf/notebooks:Z
-v C:\trade\ml:/tf/notebooks
```

**However**, it's good practice to include `:Z` because:
1. Makes your commands portable to Linux
2. Explicit about security intentions
3. Future-proofs your setup
4. Podman documentation recommends it

## Check if SELinux is Active

Inside the container:
```bash
# Check SELinux status
sestatus

# Or
getenforce
```

If SELinux is not installed or disabled, the `:Z` flag is safely ignored.

## Summary

| Flag | Meaning | Use Case |
|------|---------|----------|
| `:Z` | Private label | Single container access only |
| `:z` | Shared label | Multiple containers can share |
| None | No relabeling | Windows/systems without SELinux |
| `:ro` | Read-only | Prevent container from modifying host files |

**For your Windows setup**, you can safely use `:Z` or omit it - both will work fine!
