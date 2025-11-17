## Port Mapping Basics

```powershell
-p 8888:8888
```

This means: **`HOST_PORT:CONTAINER_PORT`**

- **8888** (left/first) = Port on your **Windows host machine**
- **8888** (right/second) = Port **inside the container**

## How It Works

```
Your Browser (Windows)     →     Podman Container
localhost:8888            →     Container:8888
    ↓                              ↓
Windows Port 8888         →     Jupyter running on port 8888
```

When you access `http://localhost:8888` in your browser:
1. Request goes to **Windows port 8888**
2. Podman **forwards** it to **container port 8888**
3. Jupyter inside container receives the request
4. Response travels back the same way

## Different Port Mapping Examples

### Same Port (Most Common)
```powershell
-p 8888:8888
# Access: http://localhost:8888
# Windows:8888 → Container:8888
```

### Different Ports
```powershell
-p 9000:8888
# Access: http://localhost:9000
# Windows:9000 → Container:8888 (Jupyter still runs on 8888 inside)
```
Useful when **port 8888 is already in use** on your Windows machine.

### Multiple Port Mappings
```powershell
podman run -d `
  --name tensorflow-jupyter `
  --device nvidia.com/gpu=all `
  -v C:\trade\ml:/tf/notebooks:Z `
  -p 8888:8888 `
  -p 6006:6006 `
  -p 8080:8080 `
  tensorflow/tensorflow:latest-gpu-jupyter
```

- Port **8888**: Jupyter Lab
- Port **6006**: TensorBoard
- Port **8080**: Custom web app

### Bind to Specific IP
```powershell
-p 127.0.0.1:8888:8888
# Only accessible from localhost (more secure)

-p 0.0.0.0:8888:8888
# Accessible from any network interface (less secure)
```

## Common Port Usage Scenarios

### Scenario 1: Multiple Jupyter Containers
```powershell
# Container 1 - TensorFlow
podman run -d `
  --name tensorflow-jupyter `
  -v C:\trade\ml:/tf/notebooks:Z `
  -p 8888:8888 `
  tensorflow/tensorflow:latest-gpu-jupyter

# Container 2 - PyTorch (different host port!)
podman run -d `
  --name pytorch-jupyter `
  -v C:\trade\ml:/home/jovyan/work:Z `
  -p 8889:8888 `
  jupyter/pytorch-notebook
```

Access:
- TensorFlow: http://localhost:8888
- PyTorch: http://localhost:8889

### Scenario 2: Jupyter + TensorBoard
```powershell
podman run -d `
  --name tensorflow-jupyter `
  -v C:\trade\ml:/tf/notebooks:Z `
  -p 8888:8888 `
  -p 6006:6006 `
  tensorflow/tensorflow:latest-gpu-jupyter
```

Then in Jupyter, start TensorBoard:
```python
# In notebook
%load_ext tensorboard
%tensorboard --logdir logs --port 6006
```

Access:
- Jupyter: http://localhost:8888
- TensorBoard: http://localhost:6006

### Scenario 3: Port Already in Use
```powershell
# If 8888 is busy, use different host port
podman run -d `
  --name tensorflow-jupyter `
  -v C:\trade\ml:/tf/notebooks:Z `
  -p 9999:8888 `
  tensorflow/tensorflow:latest-gpu-jupyter
```

Access: http://localhost:9999

## Port Mapping Syntax Variations

### Basic
```powershell
-p 8888:8888              # HOST:CONTAINER
```

### With IP binding
```powershell
-p 127.0.0.1:8888:8888   # IP:HOST:CONTAINER
```

### With protocol
```powershell
-p 8888:8888/tcp         # Specify TCP (default)
-p 53:53/udp             # Specify UDP
```

### Random host port
```powershell
-p 8888                  # Container port only
# Podman assigns random available host port
```

Find the assigned port:
```powershell
podman port tensorflow-jupyter
# Output: 8888/tcp -> 0.0.0.0:49153
```

### Port range
```powershell
-p 8000-8010:8000-8010   # Map range of ports
```

## Check Port Mappings

### See what ports are mapped:
```powershell
# List port mappings
podman port tensorflow-jupyter

# See all container details including ports
podman inspect tensorflow-jupyter

# See running containers with ports
podman ps
```

### Check if port is in use on Windows:
```powershell
# Check specific port
netstat -ano | findstr :8888

# See all listening ports
netstat -ano | findstr LISTENING
```

## Troubleshooting Port Issues

### Error: "Port already in use"
```
Error: cannot listen on the TCP port: listen tcp4 0.0.0.0:8888: bind: address already in use
```

**Solution 1:** Use different host port
```powershell
-p 8889:8888  # Use 8889 instead
```

**Solution 2:** Find and stop the process using the port
```powershell
# Find process using port 8888
netstat -ano | findstr :8888
# Output: TCP  0.0.0.0:8888  0.0.0.0:0  LISTENING  12345

# Kill the process (use PID from output)
taskkill /PID 12345 /F
```

**Solution 3:** Stop the conflicting container
```powershell
podman ps
podman stop <container-name>
```

### Can't Access Jupyter
```powershell
# Make sure container is running
podman ps

# Check logs for the Jupyter URL with token
podman logs tensorflow-jupyter

# Verify port mapping
podman port tensorflow-jupyter
```

## Security Considerations

### Localhost only (Secure - Recommended)
```powershell
-p 127.0.0.1:8888:8888
```
Only accessible from your Windows machine.

### All interfaces (Less Secure)
```powershell
-p 0.0.0.0:8888:8888
# or just
-p 8888:8888  # Defaults to 0.0.0.0
```
Accessible from other machines on your network.

### Using Firewall
Even with port mapping, Windows Firewall may block external access. This is good for security!

## Real-World Example

```powershell
# Complete setup with multiple services
podman run -d `
  --name ml-workspace `
  --device nvidia.com/gpu=all `
  -v C:\trade\ml:/workspace:Z `
  -p 8888:8888 `
  -p 6006:6006 `
  -p 5000:5000 `
  tensorflow/tensorflow:latest-gpu-jupyter
```

Services:
- **8888** → Jupyter Lab (main interface)
- **6006** → TensorBoard (model monitoring)
- **5000** → Flask app (model API/demo)

Access:
- Jupyter: http://localhost:8888
- TensorBoard: http://localhost:6006
- Flask app: http://localhost:5000

## Summary Table

| Syntax | Meaning | Access |
|--------|---------|--------|
| `-p 8888:8888` | Map host 8888 to container 8888 | http://localhost:8888 |
| `-p 9000:8888` | Map host 9000 to container 8888 | http://localhost:9000 |
| `-p 127.0.0.1:8888:8888` | Localhost only | http://localhost:8888 |
| `-p 8888` | Random host port | Check with `podman port` |
