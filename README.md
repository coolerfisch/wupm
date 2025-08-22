[2.1.0] - 2025-08-22 - Enhanced Safety Edition
🆕 Added

Enhanced Safety System - Multi-level protection with configurable security levels (High/Medium/Low)
AI Assistant - Natural language command processing with safety validation
Execution Policy Auto-Fix - Automatic handling of PowerShell execution policy restrictions
Package Trust Scoring - Reputation-based package validation system
Content Filtering - Block malicious, adult, and risky content
Parental Controls - Adult content blocking with configurable settings
Comprehensive Audit Logging - Complete operation tracking and security events
Package Blacklist Protection - Block known malicious packages
Backup & Restore System - Save and restore package configurations
Safety Configuration Commands - wupm safety and wupm safety-reset
User Confirmation System - Optional confirmations for sensitive operations
Risk Assessment Engine - AI-powered threat detection for commands and packages

🛡️ Security Enhancements

WUPMSafetyFilter Class - Comprehensive content and command validation
Multi-Level Security Controls - Granular safety configuration options
Real-time Safety Logging - All security events logged with timestamps
Package Manager Safety Ratings - WinGet (High), Chocolatey (Medium), Scoop (High)
Command Validation - Block dangerous system commands and operations

🎨 UI/UX Improvements

Enhanced ASCII Interface - Beautiful boxes and modern visual design
Color-Coded Safety Indicators - Visual security status throughout interface
Improved Error Messages - Clear, actionable error descriptions
Safety Status Dashboard - Comprehensive security overview in status command
Better Banner Design - Professional branding with safety emphasis

🤖 AI Features

Natural Language Processing - Process plain English commands safely
Smart Package Installation - Context-aware development environment setup
System Analysis - AI-powered health checks and recommendations
Safety-First AI - All AI responses filtered through security validation

🔧 Technical Improvements

Automatic Policy Bypass - Self-restarting with execution policy bypass
Enhanced Error Handling - Robust error recovery and user guidance
Configuration Management - JSON-based safety settings storage
Modular Architecture - Clean separation of safety, AI, and package management
Memory Efficiency - Optimized for better performance

📦 Package Management

Safety-Filtered Installation - All installations validated before execution
Manager Prioritization - Safety rating-based manager selection
Enhanced Search - Multi-manager search with safety annotations
Secure Updates - Validated repository updates and package upgrades

📊 Configuration

User Safety Preferences - Persistent safety configuration
Granular Controls - Individual setting management
Default Security - Secure-by-default configuration
Easy Reset - Simple safety configuration reset

🐛 Fixed

Execution Policy Issues - Automatic bypass handling
Unicode Display Problems - ASCII-safe character set
Error Message Clarity - Improved user-friendly error descriptions
Package Manager Detection - More reliable manager availability checking
Command Parsing - Better handling of complex arguments

📚 Documentation

Comprehensive Help System - Detailed command documentation
Safety Guide - Complete security feature explanation
Example Commands - Practical usage examples for all features
Troubleshooting - Common issues and solution



# WUPM v2.0 - Windows Universal Package Manager 🤖✨
![PowerShell](https://img.shields.io/badge/PowerShell-5.1%2B-blue) ![Windows](https://img.shields.io/badge/Windows-10%2F11-blue) ![License](https://img.shields.io/badge/License-MIT-green) ![Version](https://img.shields.io/badge/Version-2.0-orange)

**Finally, Linux-style package management that actually works on Windows - now with AI! 🚀**

WUPM unifies all Windows package managers (WinGet, Chocolatey, Scoop, pip, npm, Cargo) under a single, intelligent command-line interface with **AI-powered natural language processing**. One command to rule them all!

## ✨ New in v2.0: AI-Powered Edition

### 🤖 AI Assistant
- **Natural Language Processing** - Talk to your package manager in plain English
- **Intelligent Recommendations** - Get smart software suggestions based on your needs
- **System Analysis** - AI-powered health checks and optimization tips
- **Context-Aware Help** - Get assistance tailored to your specific situation

### 🪟 Complete Windows Integration
- **Windows Updates** - Full integration with Windows Update (3 methods: PSWindowsUpdate, UsoClient, COM)
- **Microsoft Store** - Automatic Store app updates via WinGet Store source
- **System Health Monitoring** - Comprehensive analysis with actionable insights
- **Beautiful Interface** - Modern, colorized output with progress indicators

## 🎯 Quick Start Examples

### AI-Powered Commands
```powershell
# Natural language installation
wupm ai 'install development tools'
# → Installs VS Code, Git, Node.js, Python automatically

# AI system analysis
wupm ai 'analyze my system'
# → Complete health check with recommendations

# Smart troubleshooting
wupm ai 'why is my computer slow?'
# → Performance analysis and optimization tips

# Intelligent updates
wupm ai 'update everything'
# → Updates packages, Windows, and Store apps
```

### Classic Commands
```powershell
# Install software with automatic fallback
wupm install firefox

# Update everything (packages + Windows + Store)
wupm upgrade

# Beautiful system status
wupm status

# Cross-manager search
wupm search "visual studio code"
```

## 📦 Supported Package Managers

| Package Manager | Description | Auto-Detection | Windows Updates | Store Apps |
|----------------|-------------|---------------|----------------|-----------|
| **🔷 WinGet** | Microsoft's official package manager | ✅ | ✅ | ✅ |
| **🍫 Chocolatey** | Community-driven package repository | ✅ | ❌ | ❌ |
| **🥄 Scoop** | Portable application installer | ✅ | ❌ | ❌ |
| **🐍 pip** | Python package installer | ✅ | ❌ | ❌ |
| **📦 npm** | Node.js package manager | ✅ | ❌ | ❌ |
| **🦀 Cargo** | Rust package manager | ✅ | ❌ | ❌ |

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
Invoke-WebRequest -Uri "https://raw.githubusercontent.com/coolerfisch/wupm/main/wupm.ps1" -OutFile "C:\wupm\wupm.ps1"

# 3. Add to PowerShell profile
if (!(Test-Path $PROFILE)) { New-Item -Path $PROFILE -ItemType File -Force }
Add-Content $PROFILE 'function wupm { & "C:\wupm\wupm.ps1" @args }'

# 4. Reload profile and test
. $PROFILE
wupm version
```

## 🎮 Complete Command Reference

### Core Commands
| Command | Description | Example |
|---------|-------------|---------|
| `wupm status` | Complete system health report with AI insights | `wupm status` |
| `wupm search <package>` | Search across all package managers | `wupm search firefox` |
| `wupm install <package>` | Install with intelligent fallback | `wupm install "visual studio code"` |
| `wupm update` | Update repositories + Windows + Store | `wupm update` |
| `wupm upgrade` | Upgrade all packages across all managers | `wupm upgrade` |
| `wupm list --upgradable` | Show available updates | `wupm list --upgradable` |
| `wupm version` | Version info with system summary | `wupm version` |
| `wupm help` | Comprehensive help | `wupm help` |

### 🤖 AI Commands
| Command | Description | Example |
|---------|-------------|---------|
| `wupm ai 'your request'` | Natural language interface | `wupm ai 'install development tools'` |
| `wupm ai 'analyze my system'` | Complete AI system analysis | `wupm ai 'analyze my system'` |
| `wupm ai 'windows updates'` | Windows Update management | `wupm ai 'windows updates'` |
| `wupm ai 'store updates'` | Microsoft Store management | `wupm ai 'store updates'` |
| `wupm ai 'recommend software'` | Get software suggestions | `wupm ai 'recommend software'` |

## 🎨 Beautiful Output Example

```
╔══════════════════════════════════════════════════════════════════════════════╗
║                      ✨ WUPM v2.0 - Complete Edition ✨                       ║
║                  🪟 Windows + 🏪 Store + 📦 Packages + 🤖 AI                  ║
╚══════════════════════════════════════════════════════════════════════════════╝

🖥️  SYSTEM INFORMATION
   ✨ OS: Microsoft Windows 11 Pro Insider Preview (AMD64)
   ℹ️ Version: 10.0.27919
   ⚡ PowerShell: 7.6.0-preview.4
   🛡️ User: assen@THINK (THINK)
   📊 Memory: 31.82 GB Total
   ✨ Disk C:: 290.85 GB free of 476.07 GB

📦 PACKAGE MANAGERS
   🔷 WinGet v1.11.430 🤖
   🍫 Chocolatey v2.5.0 🤖
   🥄 Scoop v#6080 🤖
   🐍 pip v25.2 🤖
     └─ Python: 3.13.6
   📦 NPM v11.5.2 🤖
     └─ Node.js: v24.0.2
   🦀 Cargo v1.89.0 🤖

🪟 WINDOWS UPDATES
   ✨ Windows Update: Up to date

🏪 MICROSOFT STORE
   ✨ Microsoft Store: All apps up to date

🔐 PRIVILEGES
   👑 Administrator - Full system access

🚀 Quick Actions
   🚀 wupm upgrade                    # Update everything
   🤖 wupm ai 'analyze my system'       # AI analysis
   🪟 Settings → Windows Update         # Manual Windows updates
   🏪 Microsoft Store → Downloads      # Manual Store updates
```

## 🤖 AI Features Deep Dive

### Natural Language Processing
WUPM's AI understands natural language and converts it to appropriate actions:

```powershell
# Development Environment Setup
wupm ai 'install development tools'
# → Installs VS Code, Git, Node.js, Python

# Web Development Setup  
wupm ai 'setup web development environment'
# → Installs VS Code, Node.js, Git, browsers

# System Optimization
wupm ai 'clean up my system'
# → Provides cleanup recommendations

# Performance Troubleshooting
wupm ai 'why is my computer slow?'
# → Analyzes performance issues
```

### Intelligent System Analysis
The AI provides comprehensive system health analysis:

- **Disk Space Analysis** - Warns about low space with actionable recommendations
- **Package Manager Coverage** - Evaluates your package management setup
- **Windows Update Status** - Checks for pending Windows and Store updates
- **Performance Scoring** - Gives your system a health score out of 100
- **Personalized Recommendations** - Tailored suggestions based on your system

## 🔧 Installing Package Managers

WUPM works best when you have multiple package managers installed:

### WinGet (Recommended)
```powershell
# Usually pre-installed on Windows 11
# For Windows 10: Install via Microsoft Store (search "App Installer")
# Or: https://github.com/microsoft/winget-cli/releases
```

### Chocolatey
```powershell
Set-ExecutionPolicy Bypass -Scope Process -Force
[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
```

### Scoop
```powershell
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
irm get.scoop.sh | iex
```

## 🛠️ Advanced Usage

### Daily Maintenance Workflow
```powershell
# Complete system update (AI-powered)
wupm ai 'update everything'

# Or step-by-step
wupm update    # Update repositories
wupm upgrade   # Upgrade all packages
```

### Development Environment Setup
```powershell
# AI-powered development setup
wupm ai 'install development tools'

# Manual installation
wupm install git
wupm install nodejs  
wupm install python
wupm install "visual studio code"
wupm install docker-desktop
```

### System Health Monitoring
```powershell
# AI system analysis
wupm ai 'analyze my system'

# Classic status check
wupm status

# Check for updates
wupm list --upgradable
```

## 🆕 What's New in v2.0

### 🤖 AI Integration
- **Natural Language Processing** - Understand user intent from plain English
- **Intelligent Recommendations** - Context-aware software suggestions
- **System Analysis** - AI-powered health checks and optimization
- **Smart Troubleshooting** - Performance analysis and issue resolution

### 🪟 Windows Integration
- **Windows Updates** - Full integration with multiple update methods
- **Microsoft Store** - Automatic Store app management
- **System Monitoring** - Comprehensive health and performance tracking
- **Admin Detection** - Automatic privilege escalation when needed

### 🎨 Enhanced Interface
- **Beautiful Output** - Modern, colorized interface with Unicode icons
- **Progress Indicators** - Visual feedback for long-running operations
- **Structured Information** - Organized, scannable output format
- **Error Handling** - Graceful error messages with helpful suggestions

### 🔧 Technical Improvements
- **Modern PowerShell** - Uses CIM cmdlets instead of deprecated WMI
- **Enhanced Security** - Input validation and safe command execution
- **Robust Error Handling** - Comprehensive try-catch blocks and fallbacks
- **Performance Optimization** - Faster execution and better resource usage

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
```

**"Access denied" errors**
```powershell
# Run PowerShell as Administrator for system-wide features
# Right-click PowerShell → "Run as Administrator"
```

**Package manager not detected**
```powershell
# Verify installation
wupm status

# Check PATH
$env:PATH -split ';' | Where-Object { $_ -like "*winget*" -or $_ -like "*choco*" }
```

## 📋 Roadmap

### Planned Features
- [ ] **GUI Interface** - Windows Forms frontend for non-technical users
- [ ] **Configuration File** - User preferences and custom settings  
- [ ] **Package Lists** - Save and restore installation lists
- [ ] **Scheduled Tasks** - Automatic maintenance scheduling
- [ ] **Plugin System** - Support for additional package managers
- [ ] **Remote Management** - Manage packages on remote systems

## 🤝 Contributing

### 🙏 A Note from Martin (Creator)

Hi there! 👋 I'm not a PowerShell expert or professional developer. This entire project was built with AI assistance (mainly Claude and ChatGPT) and lots of curiosity.

**The idea was simple:** "Why isn't there a single tool that manages everything on Windows – like apt on Linux?"

### How to Contribute

**Small improvements:** Send a PR - I'll review with AI help  
**Major features:** Feel free to fork - just keep me credited  
**Want to co-maintain?** Reach out! I'm open to collaboration  

**What I ask:**
- Keep credit to Martin (original creator) and AI assistants
- Be patient with my learning curve - I use AI to understand suggestions! 😊
- If you fork for major expansions, mention this as the original

### Development Guidelines
- Follow PowerShell best practices
- Maintain backward compatibility with PowerShell 5.1+
- Add error handling for new features
- Test on both Windows 10 and Windows 11
- Update documentation for new commands

## 📊 System Requirements

### Minimum Requirements
- **OS:** Windows 10 1809+ or Windows 11
- **PowerShell:** 5.1 or later
- **Memory:** 4 GB RAM
- **Storage:** 100 MB free space
- **Network:** Internet connection

### Recommended
- **OS:** Windows 11 22H2+
- **PowerShell:** 7.0+ (Core)
- **Memory:** 8 GB+ RAM
- **Privileges:** Administrator rights
- **Package Managers:** WinGet + Chocolatey + Scoop

## 📄 License

MIT License - see [LICENSE](LICENSE) file for details.

**Made with ❤️ and 🤖 AI in Munich, Bavaria, Germany - for the Windows community.**

## 🙏 Acknowledgments

**Original Creator:** Martin (with AI tool assistance)  

### 🤖 AI Tools Used
**Honest thanks to the AI tools that made this possible:**
- **🧠 Claude (Anthropic)** - Primary coding assistant, helped with architecture, debugging, and problem-solving
- **🤖 ChatGPT (OpenAI)** - Additional development support, documentation help, and creative input
- **🌟 The AI tool ecosystem** - Making programming accessible to non-developers like Martin

**WUPM v2.0 shows what's possible when someone with an idea uses AI tools to learn and build.** As a non-developer, Martin couldn't have created this without these AI assistants - but the vision, persistence, and curiosity were all human.

### 🏢 Technology & Community
**Special thanks to:**
- Microsoft - For PowerShell, WinGet, and Windows
- Chocolatey Community - For the amazing package ecosystem  
- Scoop Community - For portable application innovation
- Python, Node.js, Rust communities - For excellent tooling
- **All contributors and users** - For making WUPM better

*"I'm not a developer, but with AI tools like Claude and ChatGPT, I could build something useful. The future is about using these tools to turn ideas into reality."* - Martin, WUPM Creator

---

⭐ **Star this repository if WUPM helps you manage your Windows packages more efficiently!**

**WUPM v2.0 - Built by human vision + AI tools 🚀🤖**

⭐ **Star this repository if WUPM helps you manage your Windows packages more efficiently!**

**WUPM v2.0 - Because Windows deserves AI-powered package management! 🚀🤖**
