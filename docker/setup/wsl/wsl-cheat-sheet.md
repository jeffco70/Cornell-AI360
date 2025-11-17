

# 🧩 **WSL Command Cheat Sheet (Windows 10/11, WSL2)**

### **General Syntax**

```
wsl [command] [options]
```

---

## 🚀 **Install & Setup**

| Command                                      | Description                               |                                    |
| -------------------------------------------- | ----------------------------------------- | ---------------------------------- |
| `wsl --install`                              | Install WSL 2 + default Ubuntu distro     |                                    |
| `wsl --install -d <Distro>`                  | Install a specific distro                 |                                    |
| `wsl --install --no-distribution`            | Install WSL only, no Linux distro         |                                    |
| `wsl --install --version <1                  | 2>`                                       | Choose default version for install |
| `wsl --install --web-download`               | Force kernel download from Microsoft site |                                    |
| `wsl --install --inbox`                      | Install old inbox WSL (compatibility)     |                                    |
| `wsl --install --enable-wsl1`                | Enable both WSL 1 and WSL 2 components    |                                    |
| `wsl --list --online`                        | Show available distros to install         |                                    |
| **Example:** `wsl --install -d Ubuntu-22.04` |                                           |                                    |

After install → reboot → run `wsl -d <Distro>` → create Linux user.

---

## ⚙️ **Distribution Management**

| Command                                | Description                       |                                  |
| -------------------------------------- | --------------------------------- | -------------------------------- |
| `wsl -l` or `wsl --list`               | List installed distros            |                                  |
| `wsl -l -v`                            | List distros with version & state |                                  |
| `wsl -l -online`                       | List available distros (for installation) |
| `wsl --set-default <Distro>`           | Set default distro                |                                  |
| `wsl --set-version <Distro> <1         | 2>`                               | Convert distro between WSL 1/2   |
| `wsl --set-default-version <1          | 2>`                               | Default version for new installs |
| `wsl -t <Distro>` or `wsl --terminate` | Stop a running distro             |                                  |
| `wsl --unregister <Distro>`            | Remove distro & data              |                                  |
| `wsl --shutdown`                       | Stop all running instances        |                                  |

---

## 📦 **Import / Export Distros**

| Command                                                                                       | Description                     |
| --------------------------------------------------------------------------------------------- | ------------------------------- |
| `wsl --export <Distro> <File.tar>`                                                            | Export distro to TAR backup     |
| `wsl --import <Distro> <InstallPath> <File.tar>`                                              | Import distro from TAR          |
| `wsl --import-in-place <Distro> <Path>` *(Win 11+)*                                           | Register existing rootfs folder |
| **Example Backup:**<br>`wsl --export Ubuntu D:\Backups\ubuntu.tar`                            |                                 |
| **Example Restore:**<br>`wsl --import Ubuntu D:\WSL\Ubuntu D:\Backups\ubuntu.tar --version 2` |                                 |

---

## 🚀 **Launch & Run Commands**

| Command                        | Description                         |
| ------------------------------ | ----------------------------------- |
| `wsl`                          | Launch default distro               |
| `wsl -d <Distro>`              | Launch specific distro              |
| `wsl -e <command>`             | Execute command in default distro   |
| `wsl -d <Distro> -e <command>` | Execute command in chosen distro    |
| `wsl ~`                        | Start in home directory             |
| `wsl --cd <path>`              | Start in specific working directory |

---

## 🧠 **System Info & Updates**

| Command                       | Description                       |
| ----------------------------- | --------------------------------- |
| `wsl --status`                | Show WSL configuration & versions |
| `wsl --version`               | Show WSL manager version (Win 11) |
| `wsl --help`                  | Display help                      |
| `wsl --update`                | Update WSL kernel & components    |
| `wsl --update --web-download` | Force update from Microsoft web   |
| `wsl --repair` *(Win 11+)*    | Repair WSL installation           |

---

## 🧹 **Maintenance / Cleanup**

| Command                       | Description                      |
| ----------------------------- | -------------------------------- |
| `wsl --shutdown`              | Stop all running WSL sessions    |
| `wsl --unregister <Distro>`   | Permanently delete distro        |
| `wsl --terminate <Distro>`    | Gracefully stop one distro       |
| `wsl --set-default-version 2` | Ensure future installs use WSL 2 |
| **Reset Entire WSL:** `wsl --shutdown` → reboot → reinstall kernel |                               |

---

## 💽 **Disks & Mounts (WSL 2)**

| Command                                                                | Description                     |
| ---------------------------------------------------------------------- | ------------------------------- |
| `wsl --mount <Disk>`                                                   | Mount physical disk in WSL      |
| `wsl --unmount <Disk>`                                                 | Unmount previously mounted disk |
| Example:<br>`wsl --mount \\.\PHYSICALDRIVE2 --partition 1 --type ext4` |                                 |
| `wsl --mount <Disk>`                                                             | Mount a physical disk in WSL 2 |
| `wsl --unmount <Disk>`                                                           | Unmount mounted disk           |
| Example: `wsl --mount \\.\PHYSICALDRIVE2 --partition 1 --type ext4`              |                                |
| **Access WSL Filesystem:** `\\wsl$\Ubuntu\`                                      |                                |
| **Default Distro Disk:** `%LOCALAPPDATA%\Packages\<Distro>\LocalState\ext4.vhdx` |                                |
| **Custom Import Location:** Path from `--import`                                 |                                |

---

## 🧾 **Filesystem Paths**

| Location                    | Path                                                    |
| --------------------------- | ------------------------------------------------------- |
| Access WSL filesystem       | `\\wsl$\Ubuntu\`                                        |
| Installed distros (default) | `%LOCALAPPDATA%\Packages\<Distro>\LocalState\ext4.vhdx` |
| Custom import location      | Defined by `--import` path                              |

---

## 🧩 **Quick Workflow Examples**

**Backup + Move to New Drive**

```bash
wsl --export Ubuntu D:\WSLBackups\ubuntu.tar
wsl --unregister Ubuntu
wsl --import Ubuntu D:\WSL\Ubuntu D:\WSLBackups\ubuntu.tar --version 2
```

**Clone a Distro**

```bash
wsl --export Ubuntu D:\WSLBackups\ubuntu_clone.tar
wsl --import Ubuntu-Dev D:\WSL\UbuntuDev D:\WSLBackups\ubuntu_clone.tar --version 2
```

---

## 🧰 **Troubleshooting Tips**

| Issue             | Fix                                               |
| ----------------- | ------------------------------------------------- |
| WSL not launching | `wsl --shutdown` then reopen                      |
| Kernel outdated   | `wsl --update`                                    |
| Reset distro      | `wsl --unregister <Distro>` then reinstall/import |
| Reset entire WSL  | `wsl --shutdown` → reboot → reinstall kernel      |

---

## 🔍 **Verification & Troubleshooting**

| Action               | Command                    |
| -------------------- | -------------------------- |
| Check WSL status     | `wsl --status`             |
| Show kernel version  | `uname -r`                 |
| Check network mounts | `df -h` inside WSL         |
| Reset broken install | `wsl --repair` *(Win 11+)* |
| Kernel outdated      | `wsl --update`             |

---