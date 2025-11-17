# GPU Checks

## Quick GPU Check

```python
# Check NVIDIA driver and GPUs
!nvidia-smi
```

This should show your GPU info, memory usage, and CUDA driver version.

## Comprehensive GPU Tests

Create a new notebook and run each cell:

### 1. System GPU Check

```python
import subprocess

# Check if nvidia-smi is available
try:
    result = subprocess.run(['nvidia-smi'], capture_output=True, text=True)
    print(result.stdout)
except FileNotFoundError:
    print("nvidia-smi not found - GPU drivers may not be installed")
```

### 2. PyTorch GPU Check

```python
try:
    import torch
    
    print(f"PyTorch version: {torch.__version__}")
    print(f"CUDA available: {torch.cuda.is_available()}")
    print(f"CUDA version: {torch.version.cuda}")
    print(f"cuDNN version: {torch.backends.cudnn.version()}")
    print(f"Number of GPUs: {torch.cuda.device_count()}")
    
    if torch.cuda.is_available():
        print(f"Current GPU: {torch.cuda.current_device()}")
        print(f"GPU Name: {torch.cuda.get_device_name(0)}")
        print(f"GPU Memory: {torch.cuda.get_device_properties(0).total_memory / 1e9:.2f} GB")
        
        # Test computation on GPU
        x = torch.rand(5, 3).cuda()
        print(f"\nTensor on GPU: {x.is_cuda}")
        print(f"Tensor device: {x.device}")
        print("✓ PyTorch GPU test successful!")
    else:
        print("✗ PyTorch cannot access GPU")
        
except ImportError:
    print("PyTorch not installed")
except Exception as e:
    print(f"Error: {e}")
```

### 3. TensorFlow GPU Check

```python
try:
    import tensorflow as tf
    
    print(f"TensorFlow version: {tf.__version__}")
    print(f"Built with CUDA: {tf.test.is_built_with_cuda()}")
    print(f"GPU devices: {tf.config.list_physical_devices('GPU')}")
    
    if tf.config.list_physical_devices('GPU'):
        # Get GPU details
        gpu_devices = tf.config.list_physical_devices('GPU')
        for device in gpu_devices:
            print(f"\nGPU Device: {device}")
            details = tf.config.experimental.get_device_details(device)
            print(f"Details: {details}")
        
        # Test computation on GPU
        with tf.device('/GPU:0'):
            a = tf.constant([[1.0, 2.0, 3.0], [4.0, 5.0, 6.0]])
            b = tf.constant([[1.0, 2.0], [3.0, 4.0], [5.0, 6.0]])
            c = tf.matmul(a, b)
            print(f"\nMatrix multiplication result:\n{c}")
            print("✓ TensorFlow GPU test successful!")
    else:
        print("✗ TensorFlow cannot access GPU")
        
except ImportError:
    print("TensorFlow not installed")
except Exception as e:
    print(f"Error: {e}")
```

### 4. CUDA Runtime Check

```python
import os

# Check CUDA environment variables
cuda_vars = ['CUDA_VISIBLE_DEVICES', 'CUDA_HOME', 'LD_LIBRARY_PATH']

print("CUDA Environment Variables:")
for var in cuda_vars:
    value = os.environ.get(var, "Not set")
    print(f"{var}: {value}")
```

### 5. Comprehensive Test with Benchmark

```python
def benchmark_gpu():
    """Run a simple benchmark to verify GPU performance"""
    
    # PyTorch benchmark
    try:
        import torch
        import time
        
        if torch.cuda.is_available():
            print("PyTorch GPU Benchmark:")
            
            # Warm up
            x = torch.randn(1000, 1000).cuda()
            y = torch.randn(1000, 1000).cuda()
            _ = torch.matmul(x, y)
            
            # Benchmark
            start = time.time()
            for _ in range(100):
                z = torch.matmul(x, y)
            torch.cuda.synchronize()
            gpu_time = time.time() - start
            
            # CPU comparison
            x_cpu = x.cpu()
            y_cpu = y.cpu()
            start = time.time()
            for _ in range(100):
                z_cpu = torch.matmul(x_cpu, y_cpu)
            cpu_time = time.time() - start
            
            print(f"GPU Time: {gpu_time:.4f}s")
            print(f"CPU Time: {cpu_time:.4f}s")
            print(f"Speedup: {cpu_time/gpu_time:.2f}x")
            
    except Exception as e:
        print(f"PyTorch benchmark failed: {e}")
    
    # TensorFlow benchmark
    try:
        import tensorflow as tf
        
        if tf.config.list_physical_devices('GPU'):
            print("\nTensorFlow GPU Benchmark:")
            
            with tf.device('/GPU:0'):
                x = tf.random.normal([1000, 1000])
                y = tf.random.normal([1000, 1000])
                
                start = time.time()
                for _ in range(100):
                    z = tf.matmul(x, y)
                gpu_time = time.time() - start
            
            with tf.device('/CPU:0'):
                start = time.time()
                for _ in range(100):
                    z = tf.matmul(x, y)
                cpu_time = time.time() - start
            
            print(f"GPU Time: {gpu_time:.4f}s")
            print(f"CPU Time: {cpu_time:.4f}s")
            print(f"Speedup: {cpu_time/gpu_time:.2f}x")
            
    except Exception as e:
        print(f"TensorFlow benchmark failed: {e}")

benchmark_gpu()
```

## What to Look For

### ✓ GPU Working:
- `nvidia-smi` shows your GPU
- PyTorch: `torch.cuda.is_available()` returns `True`
- TensorFlow: `tf.config.list_physical_devices('GPU')` returns GPU list
- Benchmark shows GPU is significantly faster than CPU

### ✗ GPU Not Working:
- `nvidia-smi` command not found or fails
- PyTorch/TensorFlow show `False` or empty GPU lists
- GPU and CPU times are similar in benchmark

## Troubleshooting If GPU Not Detected

### 1. Check container has GPU access:

```python
# In Jupyter, run this
!ls -la /dev | grep nvidia
```

Should show: `nvidia0`, `nvidiactl`, `nvidia-uvm`

### 2. Restart container with correct GPU flags:

```powershell
# Stop current container
podman stop jupyterlab
podman rm jupyterlab

# Try alternative GPU flag
podman run -d `
  --name jupyterlab `
  --gpus all `
  -v C:\trade\ml:/home/jovyan/work:Z `
  -p 8888:8888 `
  automaatio/jupyterlab:latest
```

### 3. Check Podman GPU configuration:

```powershell
# Test GPU access from command line
podman run --rm --device nvidia.com/gpu=all nvidia/cuda:12.0.0-base-ubuntu20.04 nvidia-smi
```
