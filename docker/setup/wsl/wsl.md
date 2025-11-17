
## 🧩 **WSL Command Summary (Windows 10/11, WSL2)**

### **Basic Syntax**

```bash
wsl [command] [options]
```

If no command is provided, this launches the default distribution’s shell.

---

## ⚙️ **Distribution Management**

| Command                                                 | Description                                                          | Example                                           |                                    |
| ------------------------------------------------------- | -------------------------------------------------------------------- | ------------------------------------------------- | ---------------------------------- |
| `wsl --list` or `wsl -l`                                | Lists all installed Linux distributions.                             | `wsl --list`                                      |                                    |
| `wsl --list --verbose` or `wsl -l -v`                   | Lists distributions with version (1/2) and running state.            | `wsl -l -v`                                       |                                    |
| `wsl --setdefault <DistroName>`                         | Sets the default distribution.                                       | `wsl --setdefault Ubuntu-22.04`                   |                                    |
| `wsl --set-version <DistroName> <1                      | 2>`                                                                  | Converts a distro between WSL1 and WSL2.          | `wsl --set-version Ubuntu-22.04 2` |
| `wsl --set-default-version <1                           | 2>`                                                                  | Sets the default WSL version for future installs. | `wsl --set-default-version 2`      |
| `wsl --terminate <DistroName>` or `wsl -t <DistroName>` | Stops a running distribution.                                        | `wsl -t Ubuntu-22.04`                             |                                    |
| `wsl --unregister <DistroName>`                         | Completely removes a distro and its data.                            | `wsl --unregister Ubuntu-22.04`                   |                                    |
| `wsl --shutdown`                                        | Stops all running WSL instances. Useful after configuration changes. | `wsl --shutdown`                                  |                                    |

---

## 📦 **Importing / Exporting Distros**

| Command                                                                | Description                                                   | Example                                                                  |
| ---------------------------------------------------------------------- | ------------------------------------------------------------- | ------------------------------------------------------------------------ |
| `wsl --export <DistroName> <FileName.tar>`                             | Exports a distro to a `.tar` file (for backup or cloning).    | `wsl --export Ubuntu-22.04 D:\Backups\ubuntu2204.tar`                    |
| `wsl --import <DistroName> <InstallLocation> <FileName.tar>`           | Imports a distro from a `.tar` file to a chosen folder.       | `wsl --import Ubuntu-Clone D:\WSL\UbuntuClone D:\Backups\ubuntu2204.tar` |
| `wsl --import-in-place <DistroName> <InstallLocation>` *(Windows 11+)* | Registers an existing WSL rootfs folder without copying data. | `wsl --import-in-place MyWSL D:\WSL\MyRootFS`                            |

**Notes:**

* When importing, you can relocate the distro to a non-system drive (e.g., `D:\WSL\Ubuntu`) to save space on C:.
* You can later reassign drives using `wsl --unregister` and `--import`.

---

## 🚀 **Launching and Executing Commands**

| Command                            | Description                                             | Example                           |
| ---------------------------------- | ------------------------------------------------------- | --------------------------------- |
| `wsl`                              | Launches the default distribution.                      | `wsl`                             |
| `wsl -d <DistroName>`              | Launches a specific distribution.                       | `wsl -d Debian`                   |
| `wsl -e <command>`                 | Executes a single command in the default distro.        | `wsl -e ls -la`                   |
| `wsl -d <DistroName> -e <command>` | Executes a command in a specific distro.                | `wsl -d Ubuntu-22.04 -e uname -a` |
| `wsl ~`                            | Starts in the home directory (instead of `/mnt/c/...`). | `wsl ~`                           |

---

## 🧠 **System Information and Configuration**

| Command                         | Description                                                      | Example                       |
| ------------------------------- | ---------------------------------------------------------------- | ----------------------------- |
| `wsl --status`                  | Displays WSL version info, kernel version, and default settings. | `wsl --status`                |
| `wsl --help`                    | Displays full help and usage information.                        | `wsl --help`                  |
| `wsl --version` *(Windows 11+)* | Shows the WSL version manager version (different from kernel).   | `wsl --version`               |
| `wsl --update`                  | Updates the WSL kernel and components.                           | `wsl --update`                |
| `wsl --update --web-download`   | Forces WSL update from Microsoft’s web source.                   | `wsl --update --web-download` |

---

## 🧹 **Maintenance and Cleanup**

| Command                         | Description                        | Example                   |
| ------------------------------- | ---------------------------------- | ------------------------- |
| `wsl --shutdown`                | Stops all running distributions.   | `wsl --shutdown`          |
| `wsl --unregister <DistroName>` | Deletes the distro (irreversible). | `wsl --unregister Ubuntu` |
| `wsl --repair` *(Windows 11+)*  | Repairs the WSL installation.      | `wsl --repair`            |

---

## 🧰 **File System Locations**

| Type                    | Path                                                        | Notes                                   |
| ----------------------- | ----------------------------------------------------------- | --------------------------------------- |
| Default distro rootfs   | `\\wsl$\Ubuntu-22.04\`                                      | Access via File Explorer or PowerShell. |
| Installed distros       | `%LOCALAPPDATA%\Packages\<DistroName>\LocalState\ext4.vhdx` | The virtual disk file for each distro.  |
| Custom imported distros | Your chosen path during `--import`.                         | You can back up or move these manually. |

---

## 🧪 **Advanced / Debug Commands**

| Command                | Description                                              | Example                                                    |
| ---------------------- | -------------------------------------------------------- | ---------------------------------------------------------- |
| `wsl --exec <command>` | Executes command in the default distro (alias for `-e`). | `wsl --exec whoami`                                        |
| `wsl --mount <Disk>`   | Mounts a physical disk (for WSL2).                       | `wsl --mount \\.\PHYSICALDRIVE2 --partition 1 --type ext4` |
| `wsl --unmount <Disk>` | Unmounts a previously mounted disk.                      | `wsl --unmount \\.\PHYSICALDRIVE2`                         |
| `wsl --cd <Path>`      | Starts WSL in a specific working directory.              | `wsl --cd /mnt/d/projects`                                 |

---

## 🧾 **Typical Workflows**

### **Backup and Restore**

```bash
# Export existing distro
wsl --export Ubuntu-22.04 D:\WSLBackups\ubuntu.tar

# Unregister old one
wsl --unregister Ubuntu-22.04

# Import it to a new drive
wsl --import Ubuntu-22.04 D:\WSL\Ubuntu D:\WSLBackups\ubuntu.tar --version 2
```

### **Clone a Distro**

```bash
wsl --export Ubuntu-22.04 D:\WSLBackups\ubuntu_clone.tar
wsl --import Ubuntu-Dev D:\WSL\UbuntuDev D:\WSLBackups\ubuntu_clone.tar --version 2
```

---
