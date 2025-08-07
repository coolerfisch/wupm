# WUPM - Windows Universal Package Manager

[![PowerShell](https://img.shields.io/badge/PowerShell-5.1%2B-blue.svg)](https://github.com/PowerShell/PowerShell)
[![Windows](https://img.shields.io/badge/Windows-10%2F11-green.svg)](https://www.microsoft.com/windows)
[![License](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
[![Version](https://img.shields.io/badge/Version-1.3-red.svg)](https://github.com/yourusername/wupm/releases)

> **Finally, Linux-style package management that actually works on Windows!**

WUPM unifies all Windows package managers (WinGet, Chocolatey, Scoop, pip, npm, Cargo) under a single, intelligent command-line interface. One command to rule them all! 🚀

## ✨ Features

- 🔄 **Universal Package Management** - One interface for all package managers
- 🧠 **Intelligent Installation** - Automatically tries all available managers until success
- 🔍 **Cross-Manager Search** - Search across all repositories simultaneously
- 🏥 **System Health Monitoring** - Detailed system analysis and recommendations
- 🪟 **Windows Update Integration** - Manages Windows Updates and Microsoft Store apps
- 🎨 **Beautiful Output** - Professional, colorized terminal interface
- ⚡ **Fallback Mechanisms** - Robust error handling with automatic fallbacks
- 📊 **Comprehensive Reporting** - Detailed installation and upgrade reports

## 🎯 Quick Start

**Install Firefox across all package managers:**
```powershell
wupm install firefox
```

**Update your entire system:**
```powershell
wupm update && wupm upgrade
```

**Get detailed system status:**
```powershell
wupm status
```

## 📦 Supported Package Managers

| Package Manager | Description | Auto-Detection |
|-----------------|-------------|----------------|
| **WinGet** | Microsoft's official package manager | ✅ |
| **Chocolatey** | Community-driven package repository | ✅ |
| **Scoop** | Portable application installer | ✅ |
| **pip** | Python package installer | ✅ |
| **npm** | Node.js package manager | ✅ |
| **Cargo** | Rust package manager | ✅ |

## 🚀 Installation

### Prerequisites
- Windows 10/11
- PowerShell 5.1+ (included in Windows)
- Administrator rights (recommended for Windows Updates)

### Quick Installation
```powershell
# 1. Enable PowerShell scripts
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser -Force

# 2. Create directory and download WUPM
New-Item -Path "C:\wupm" -ItemType Directory -Force
Invoke-WebRequest -Uri "https://github.com/coolerfisch/wupm/releases/latest/download/wupm.ps1" -OutFile "C:\wupm\wupm.ps1"

# 3. Add to PowerShell profile
if (!(Test-Path $PROFILE)) { New-Item -Path $PROFILE -ItemType File -Force }
Add-Content $PROFILE 'function wupm { & "C:\wupm\wupm.ps1" @args }'

# 4. Reload profile and test
. $PROFILE
wupm version
```

### Manual Installation

#### Step 1: Enable PowerShell Scripts
```powershell
# Run PowerShell as Administrator
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser -Force
```

#### Step 2: Create Installation Directory
```powershell
New-Item -Path "C:\wupm" -ItemType Directory -Force
cd C:\wupm
```

#### Step 3: Download WUPM
```powershell
# Download latest release
Invoke-WebRequest -Uri "https://github.com/coolerfisch/wupm/releases/latest/download/wupm.ps1" -OutFile "wupm.ps1"
```

#### Step 4: Create PowerShell Profile Function
```powershell
# Add WUPM function to your PowerShell profile
if (!(Test-Path $PROFILE)) { New-Item -Path $PROFILE -ItemType File -Force }

Add-Content $PROFILE @'
function wupm {
    & "C:\wupm\wupm.ps1" @args
}
'@

# Reload profile
. $PROFILE
```

#### Step 5: Verify Installation
```powershell
wupm version
```

## 🎮 Usage

### Core Commands

| Command | Description | Example |
|---------|-------------|---------|
| `wupm status` | Complete system health report | `wupm status` |
| `wupm search <package>` | Search across all package managers | `wupm search firefox` |
| `wupm install <package>` | Install with intelligent fallback | `wupm install "visual studio code"` |
| `wupm update` | Update repositories + Windows + Store | `wupm update` |
| `wupm upgrade` | Upgrade all packages across all managers | `wupm upgrade` |
| `wupm list --upgradable` | Show available updates | `wupm list --upgradable` |
| `wupm version` | Version info with system summary | `wupm version` |
| `wupm help` | Comprehensive help | `wupm help` |

### Advanced Examples

**Daily System Maintenance:**
```powershell
wupm update && wupm upgrade
# Updates repositories, Windows Updates, Store apps, and all packages
```

**Batch Software Installation:**
```powershell
wupm install git
wupm install nodejs
wupm install python
wupm install "visual studio code"
```

**System Health Check:**
```powershell
wupm status
# Shows hardware info, disk space, memory, package managers, and recommendations
```

**Cross-Manager Package Search:**
```powershell
wupm search firefox
# Searches WinGet, Chocolatey, and Scoop simultaneously
```

## 🎨 Sample Output

```
╔══════════════════════════════════════════════════════════════════════════════╗
║                      WUPM SYSTEM STATUS REPORT                              ║
╚══════════════════════════════════════════════════════════════════════════════╝

🖥️  SYSTEM INFORMATION
   ✓ OS: Windows 11 Pro (AMD64)
   ✓ Version: 10.0.22621
   ✓ PowerShell: 5.1.22621.2506
   ✓ Memory: 32 GB Total
   ✓ Disk C:: 445.2 GB free of 931.5 GB

📦 PACKAGE MANAGERS
   ✓ WinGet - Version: v1.6.2771
   ✓ Chocolatey - Version: 2.2.2
   ✓ Scoop - Version: 0.3.1
   ✓ pip - Version: 23.3.1 (Python 3.12.0)
   ✓ NPM - Version: 10.2.4 (Node.js v21.2.0)

🔐 PRIVILEGES
   ✓ Administrator - Full access to Windows Updates

⚡ RECOMMENDATIONS
   ✓ Multiple package managers detected - excellent coverage
   ✓ Sufficient disk space (445.2 GB free)
```

## 🔧 Installing Package Managers

WUPM works best when you have multiple package managers installed. Here's how to install the most popular ones:

### WinGet (Windows 10)
```powershell
# Install via Microsoft Store: search for "App Installer"
# Or download from: https://github.com/microsoft/winget-cli/releases
```

### Chocolatey
```powershell
Set-ExecutionPolicy Bypass -Scope Process -Force
[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
```

### Scoop
```powershell
iwr -useb get.scoop.sh | iex
```

## 🛠️ Troubleshooting

### Common Issues

**"Execution of scripts is disabled"**
```powershell
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser -Force
```

**"wupm command not found"**
```powershell
# Test direct execution
& "C:\wupm\wupm.ps1" version

# Reload PowerShell profile
. $PROFILE

# Check PowerShell profile
Get-Content $PROFILE
```

**"Access denied" or permission errors**
```powershell
# Run PowerShell as Administrator for system-wide changes
# Or use current user scope for profile changes
```

**Old version still running**
```powershell
# Find all wupm.ps1 files
Get-ChildItem -Path C:\ -Name "wupm.ps1" -Recurse -ErrorAction SilentlyContinue

# Remove old versions and restart PowerShell
```

**Package manager not detected**
```powershell
# Verify package manager installation
Get-Command winget -ErrorAction SilentlyContinue
Get-Command choco -ErrorAction SilentlyContinue
Get-Command scoop -ErrorAction SilentlyContinue

# Add to PATH if necessary
$env:PATH += ";C:\path\to\package\manager"
```

## 🤝 Contributing

Contributions are welcome! Here's how you can help:

1. **Fork** the repository
2. **Create** a feature branch (`git checkout -b feature/amazing-feature`)
3. **Commit** your changes (`git commit -m 'Add amazing feature'`)
4. **Push** to the branch (`git push origin feature/amazing-feature`)
5. **Open** a Pull Request

### Development Guidelines

- Follow PowerShell best practices and style guidelines
- Maintain backward compatibility with PowerShell 5.1+
- Add appropriate error handling for all new features
- Update documentation for any new commands or options
- Test on both Windows 10 and Windows 11
- Ensure all package managers are properly supported

### Reporting Bugs

When reporting bugs, please include:
- **OS Version:** Windows build number (`winver`)
- **PowerShell Version:** `$PSVersionTable.PSVersion`
- **WUPM Version:** `wupm version`
- **Installed Package Managers:** `wupm status`
- **Error Message:** Complete error output
- **Steps to Reproduce:** Detailed reproduction steps

## 📋 Roadmap

### Planned Features
- [ ] **GUI Interface** - Windows Forms or WPF frontend for non-technical users
- [ ] **Configuration File** - User preferences and custom settings
- [ ] **Background Updates** - Automatic update checking and notifications
- [ ] **Plugin System** - Support for additional package managers
- [ ] **Package Lists** - Save and restore package installation lists
- [ ] **Scheduled Tasks** - Automatic maintenance scheduling
- [ ] **Package Groups** - Install predefined software bundles
- [ ] **Remote Management** - Manage packages on remote Windows systems

### Version History
- **v1.3** - Complete system integration, Windows Updates, Store Apps
- **v1.2** - Enhanced error handling, improved output formatting
- **v1.1** - Added Cargo support, system health monitoring
- **v1.0** - Initial release with core functionality

## 📊 System Requirements

### Minimum Requirements
- **Operating System:** Windows 10 1809+ or Windows 11
- **PowerShell:** Version 5.1 or later
- **Memory:** 4 GB RAM
- **Storage:** 100 MB free disk space
- **Network:** Internet connection for package downloads

### Recommended Requirements
- **Operating System:** Windows 11 22H2+
- **PowerShell:** PowerShell 7.0+ (Core)
- **Memory:** 8 GB RAM or more
- **Storage:** 1 GB free disk space for package caching
- **Privileges:** Administrator rights for Windows Updates

## 🏆 Inspiration

WUPM was inspired by the excellent package management systems found in Linux distributions:

- **apt** (Debian/Ubuntu) - Simple, reliable package management
- **yum/dnf** (Red Hat/Fedora) - Dependency resolution and system updates
- **pacman** (Arch Linux) - Fast, lightweight package operations
- **zypper** (openSUSE) - Advanced package management features

The goal was to bring this unified, powerful package management experience to Windows users who have been managing software through various disconnected tools.

## 🌟 Why WUPM?

### The Problem
Windows users typically manage software through:
- Manual downloads from websites
- Multiple package managers with different commands
- Separate update processes for different software
- No unified system overview or health monitoring

### The Solution
WUPM provides:
- **One interface** for all package managers
- **Automatic fallbacks** when one manager fails
- **System-wide updates** including Windows and Store apps
- **Health monitoring** with actionable recommendations
- **Linux-style workflow** familiar to developers

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

```
MIT License

Copyright (c) 2024 WUPM Contributors

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```

## 🙏 Acknowledgments

- **Microsoft** - For PowerShell, WinGet, and the Windows platform
- **Chocolatey Community** - For the amazing community package repository
- **Scoop Community** - For innovative portable application management
- **Python Software Foundation** - For pip and Python ecosystem
- **Node.js Foundation** - For npm and Node.js ecosystem
- **Rust Foundation** - For Cargo and Rust tooling
- **Open Source Community** - For inspiration and continuous improvement
- **Claude AI** - For initial development assistance and architecture design
- **Dr. Windows Community** - For testing, feedback, and German localization

## 📞 Support & Community

### Getting Help
- **📚 Documentation:** [GitHub Wiki](https://github.com/coolerfisch/wupm/wiki)
- **🐛 Bug Reports:** [GitHub Issues](https://github.com/coolerfisch/wupm/issues)
- **💬 Discussions:** [GitHub Discussions](https://github.com/coolerfisch/wupm/discussions)
- **❓ Questions:** Use GitHub Discussions for general questions

### Community Guidelines
- Be respectful and helpful to other users
- Search existing issues before creating new ones
- Provide detailed information when reporting bugs
- Follow the code of conduct for all interactions

### Stay Updated
- **⭐ Star** this repository to show support
- **👀 Watch** for notifications on new releases
- **🔔 Follow** for updates on development progress

---

**⭐ Star this repository if WUPM helps you manage your Windows packages more efficiently!**

**Made with ❤️ for the Windows community**

---

*WUPM - Because Windows deserves proper package management too!* 🚀
