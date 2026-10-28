# 🌐 OMNI CLI

> **Intelligent Multi-Device Command & Control Center**  
> *Seamlessly bridging Linux Desktop Workstations, Arch Laptops, Windows PowerShell / WSL, and Android Termux.*

Author: **Jordan Isaac ([@dragpk247](https://github.com/dragpk247))**  
License: **MIT**

---

## ⚡ Highlights

- **Hardware-Aware Context Detection**: Automatically detects whether you are running on your **Desktop**, **Laptop**, **Windows / WSL**, or **Phone** using MAC addresses, interface IPs, and hardware properties.
- **Dedicated Device Interfaces**:
  - 📱 **Mobile Workstation (`omni-phone`)**: Touch-optimized, AI copilot, clipboard automation, battery thermal sentinel, and background wake-lock toggle.
  - 💻 **Portable Workstation (`omni-laptop`)**: Low-latency Moonlight streaming, remote desktop AI execution, and phone screen mirroring.
  - 🖥️ **Master Desktop (`omni-desktop`)**: Local AI orchestration (Antigravity, Claude Code, Aider, Jev), RTX GPU telemetry, and remote fleet management.
  - 🪟 **Native Windows PowerShell Module (`Omni.psm1`)**: Native PowerShell cmdlet dispatch (`omni`, `Send-OmniFile`, `Sync-OmniClipboard`, `Get-OmniStatus`).
- **📁 Multi-Way "AirDrop" Transfer (`omni send`)**: Instantly send files and folders across Desktop $\leftrightarrow$ Laptop $\leftrightarrow$ Windows PC $\leftrightarrow$ Phone over Tailscale with native push notifications.
- **📋 Universal Clipboard Sync (`omni clip`)**: Push or pull clipboards across Wayland (Linux), Windows (`Get-Clipboard` / `Set-Clipboard`), and Android Termux.
- **🐧 Full WSL2 Integration**: Auto-detects WSL environments, bridging Windows host clipboards (`clip.exe`, `powershell.exe`) directly into Linux shells.
- **🎙️ Voice Copilot (`omni voice`)**: Hands-free speech-to-text input with spoken audio AI responses on S24.
- **🔔 Cross-Device Notification Relay (`omni notify`)**: Send push notifications to your phone's notification shade when long builds or AI commands finish.
- **🔍 Fuzzy Action Launcher (`omni -f`)**: Interactive real-time search launcher for every tool and action.
- **🛡️ Thermal & Battery Sentinel**: Circuit-breaker that halts heavy tasks when battery is low or device is hot.
- **🔒 Privacy First**: Zero hardcoded IP addresses, credentials, or private keys in the codebase. All endpoints are configured via `~/.config/omni/config.env`.

---

## 📦 Quick Installation

### Linux / WSL / Android Termux
```bash
curl -fsSL https://raw.githubusercontent.com/dragpk247/omni-cli/main/install.sh | bash
```

### Windows (Native PowerShell)
Run in PowerShell (as Administrator or standard user):
```powershell
irm https://raw.githubusercontent.com/dragpk247/omni-cli/main/install.ps1 | iex
```

Then run the setup wizard on Linux/WSL:
```bash
omni setup
```

---

## 🚀 Quick Usage

### Interactive Menu
Just run `omni` on any device:
```bash
omni
```
It will automatically inspect your hardware signatures and open the exact right dashboard for that device!

### 3-Way File Sharing
```bash
# Send to Phone (saved to /sdcard/Download/ with notification)
omni send photo.png --phone

# Send to Laptop (saved to ~/Downloads/ with notification)
omni send report.pdf --laptop

# Send to Desktop (saved to ~/Downloads/)
omni send notes.md --desktop

# Interactive target selector
omni send archive.tar.gz
```

### Direct Shortcuts
```bash
omni ask "how do I extract tar.gz"   # Smart mobile copilot
omni clip-ask                        # Pipe copied clipboard text to AI
omni clip-run                        # Preview and execute clipboard command safely
omni guard                           # Test battery and thermal safety sentinel
```

---

## ⚙️ Configuration

Your fleet endpoints are stored in `~/.config/omni/config.env` (never committed to git):

```bash
# Desktop
DESKTOP_IP="100.x.y.z"
DESKTOP_MAC="00:11:22:33:44:55"
DESKTOP_USER="jpi"

# Laptop
LAPTOP_IP="100.x.y.z"
LAPTOP_MAC="00:11:22:33:44:66"
LAPTOP_USER="jpi"

# Phone (Termux)
PHONE_IP="100.x.y.z"
PHONE_PORT="8022"
PHONE_USER="u0_a..."
```

---

## 📄 License

MIT © 2026 Jordan Isaac ([dragpk247](https://github.com/dragpk247))
