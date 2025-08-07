# WUPM - Windows Universal Package Manager - English Version v1.3
# The ultimate Windows package management tool

$cmd = $args[0]
$pkg = $args[1..100] -join " "

# Color and output functions
function Write-Info($text) { Write-Host $text -ForegroundColor Cyan }
function Write-Success($text) { Write-Host $text -ForegroundColor Green }
function Write-Error($text) { Write-Host $text -ForegroundColor Red }
function Write-Warning($text) { Write-Host $text -ForegroundColor Yellow }
function Write-Detail($text) { Write-Host $text -ForegroundColor Gray }
function Write-Highlight($text) { Write-Host $text -ForegroundColor Magenta }

function Write-Box($Title) {
    Write-Info ""
    Write-Info "╭─ $Title"
    Write-Info "│"
}

function Write-BoxEnd {
    Write-Info "╰─"
}

# Collect system information
function Get-SystemInfo {
    try {
        return @{
            'OS' = (Get-WmiObject Win32_OperatingSystem).Caption
            'Version' = (Get-WmiObject Win32_OperatingSystem).Version
            'Architecture' = $env:PROCESSOR_ARCHITECTURE
            'PowerShell' = $PSVersionTable.PSVersion.ToString()
            'User' = $env:USERNAME
            'Computer' = $env:COMPUTERNAME
            'Domain' = $env:USERDOMAIN
            'Memory' = [math]::Round((Get-WmiObject Win32_ComputerSystem).TotalPhysicalMemory / 1GB, 2)
            'FreeSpace' = [math]::Round((Get-WmiObject Win32_LogicalDisk -Filter "DeviceID='C:'").FreeSpace / 1GB, 2)
            'TotalSpace' = [math]::Round((Get-WmiObject Win32_LogicalDisk -Filter "DeviceID='C:'").Size / 1GB, 2)
        }
    } catch {
        return @{ 'Error' = 'Could not retrieve system information' }
    }
}

# Detailed package manager information
function Get-PackageManagerInfo {
    $managers = @()
    
    # WinGet
    if (Get-Command winget -ErrorAction SilentlyContinue) {
        try {
            $wingetVersion = (winget --version).Trim()
            $managers += @{
                'Name' = 'WinGet'
                'Status' = 'Available'
                'Version' = $wingetVersion
                'Path' = (Get-Command winget).Source
            }
        } catch {
            $managers += @{ 'Name' = 'WinGet'; 'Status' = 'Error'; 'Version' = 'Unknown' }
        }
    }
    
    # Chocolatey  
    if (Get-Command choco -ErrorAction SilentlyContinue) {
        try {
            $chocoVersion = (choco --version).Trim()
            $managers += @{
                'Name' = 'Chocolatey'
                'Status' = 'Available'
                'Version' = $chocoVersion
                'Path' = (Get-Command choco).Source
            }
        } catch {
            $managers += @{ 'Name' = 'Chocolatey'; 'Status' = 'Error'; 'Version' = 'Unknown' }
        }
    }
    
    # Scoop
    if (Get-Command scoop -ErrorAction SilentlyContinue) {
        try {
            $scoopVersion = (scoop --version).Split("`n")[0].Replace("Current Scoop version:", "").Trim()
            $managers += @{
                'Name' = 'Scoop'
                'Status' = 'Available'
                'Version' = $scoopVersion
                'Path' = (Get-Command scoop).Source
            }
        } catch {
            $managers += @{ 'Name' = 'Scoop'; 'Status' = 'Error'; 'Version' = 'Unknown' }
        }
    }
    
    # pip
    if (Get-Command pip -ErrorAction SilentlyContinue) {
        try {
            $pipVersion = (pip --version).Split(" ")[1]
            $pythonVersion = try { (python --version 2>&1).Replace("Python ", "") } catch { "Unknown" }
            $managers += @{
                'Name' = 'pip'
                'Status' = 'Available'
                'Version' = $pipVersion
                'PythonVersion' = $pythonVersion
                'Path' = (Get-Command pip).Source
            }
        } catch {
            $managers += @{ 'Name' = 'pip'; 'Status' = 'Error'; 'Version' = 'Unknown' }
        }
    }
    
    # NPM
    if (Get-Command npm -ErrorAction SilentlyContinue) {
        try {
            $npmVersion = (npm --version).Trim()
            $nodeVersion = try { (node --version).Trim() } catch { "Unknown" }
            $managers += @{
                'Name' = 'NPM'
                'Status' = 'Available'
                'Version' = $npmVersion
                'NodeVersion' = $nodeVersion
                'Path' = (Get-Command npm).Source
            }
        } catch {
            $managers += @{ 'Name' = 'NPM'; 'Status' = 'Error'; 'Version' = 'Unknown' }
        }
    }
    
    # Cargo
    if (Get-Command cargo -ErrorAction SilentlyContinue) {
        try {
            $cargoVersion = (cargo --version).Split(" ")[1]
            $managers += @{
                'Name' = 'Cargo'
                'Status' = 'Available'
                'Version' = $cargoVersion
                'Path' = (Get-Command cargo).Source
            }
        } catch {
            $managers += @{ 'Name' = 'Cargo'; 'Status' = 'Error'; 'Version' = 'Unknown' }
        }
    }
    
    return $managers
}

# Detailed system status
function Show-DetailedStatus {
    $sysInfo = Get-SystemInfo
    $managers = Get-PackageManagerInfo
    
    Write-Info "╔══════════════════════════════════════════════════════════════════════════════╗"
    Write-Info "║                      WUPM SYSTEM STATUS REPORT                              ║"
    Write-Info "╚══════════════════════════════════════════════════════════════════════════════╝"
    
    # System Information
    Write-Info ""
    Write-Highlight "🖥️  SYSTEM INFORMATION"
    if ($sysInfo.Error) {
        Write-Error "   Error: $($sysInfo.Error)"
    } else {
        Write-Success "   OS: $($sysInfo.OS) ($($sysInfo.Architecture))"
        Write-Success "   Version: $($sysInfo.Version)"
        Write-Success "   PowerShell: $($sysInfo.PowerShell)"
        Write-Success "   User: $($sysInfo.User)@$($sysInfo.Computer) ($($sysInfo.Domain))"
        Write-Success "   Memory: $($sysInfo.Memory) GB Total"
        Write-Success "   Disk C:: $($sysInfo.FreeSpace) GB free of $($sysInfo.TotalSpace) GB"
    }
    
    # Package Managers Detail
    Write-Info ""
    Write-Highlight "📦 PACKAGE MANAGERS"
    
    foreach ($mgr in $managers) {
        if ($mgr.Status -eq 'Available') {
            Write-Info ""
            Write-Success "   ✓ $($mgr.Name)"
            Write-Detail "     Version: $($mgr.Version)"
            Write-Detail "     Path: $($mgr.Path)"
            
            switch ($mgr.Name) {
                'pip' {
                    Write-Detail "     Python: $($mgr.PythonVersion)"
                }
                'NPM' {
                    Write-Detail "     Node.js: $($mgr.NodeVersion)"
                }
            }
        } else {
            Write-Warning "   ⚠ $($mgr.Name) - $($mgr.Status)"
        }
    }
    
    # Admin Status
    $isAdmin = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
    Write-Info ""
    Write-Highlight "🔐 PRIVILEGES"
    if ($isAdmin) {
        Write-Success "   ✓ Administrator - Full access to Windows Updates"
    } else {
        Write-Warning "   ⚠ Standard User - Windows Updates require Administrator privileges"
        Write-Detail "     Run: Right-click PowerShell → Run as Administrator"
    }
    
    # Performance Tips
    Write-Info ""
    Write-Highlight "⚡ RECOMMENDATIONS"
    
    if ($managers.Count -ge 3) {
        Write-Success "   ✓ Multiple package managers detected - excellent coverage"
    } else {
        Write-Warning "   ⚠ Consider installing additional package managers"
        Write-Detail "     Recommended: WinGet, Chocolatey, Scoop"
    }
    
    if ($sysInfo.FreeSpace -and $sysInfo.FreeSpace -lt 10) {
        Write-Warning "   ⚠ Low disk space ($($sysInfo.FreeSpace) GB) - cleanup recommended"
    } elseif ($sysInfo.FreeSpace) {
        Write-Success "   ✓ Sufficient disk space ($($sysInfo.FreeSpace) GB free)"
    }
    
    Write-Info ""
    Write-Info "╔══════════════════════════════════════════════════════════════════════════════╗"
    Write-Info "║ Usage: wupm update (repositories) | wupm upgrade (packages) | wupm help    ║"
    Write-Info "╚══════════════════════════════════════════════════════════════════════════════╝"
}

# Admin check and package manager detection
$isAdmin = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
$hasWinget = Get-Command winget -ErrorAction SilentlyContinue
$hasChoco = Get-Command choco -ErrorAction SilentlyContinue
$hasScoop = Get-Command scoop -ErrorAction SilentlyContinue
$hasPip = Get-Command pip -ErrorAction SilentlyContinue
$hasNpm = Get-Command npm -ErrorAction SilentlyContinue
$hasCargo = Get-Command cargo -ErrorAction SilentlyContinue

# Main command switch
switch ($cmd) {
    { $_ -in @("status", "stat", "health", "info") } {
        Show-DetailedStatus
    }
    
    "search" {
        if (!$pkg) { 
            Write-Error "Usage: wupm search <package-name>"
            Write-Detail "Example: wupm search firefox"
            return
        }
        
        Write-Box "Searching for '$pkg'"
        $totalResults = 0
        
        if ($hasWinget) {
            Write-Info "│ [WinGet - Windows Package Manager]"
            try {
                winget search $pkg
                Write-Success "│ ✓ WinGet search completed"
            } catch {
                Write-Warning "│ ⚠ WinGet search failed"
            }
            Write-Info "│"
        }
        
        if ($hasChoco) {
            Write-Info "│ [Chocolatey - Community Repository]"  
            try {
                choco search $pkg --limit-output
                Write-Success "│ ✓ Chocolatey search completed"
            } catch {
                Write-Warning "│ ⚠ Chocolatey search failed"
            }
            Write-Info "│"
        }
        
        if ($hasScoop) {
            Write-Info "│ [Scoop - Portable Applications]"
            try {
                scoop search $pkg
                Write-Success "│ ✓ Scoop search completed"
            } catch {
                Write-Warning "│ ⚠ Scoop search failed"
            }
            Write-Info "│"
        }
        
        Write-BoxEnd
        Write-Info "💡 Use 'wupm install <package>' to install from any available manager"
    }
    
    "install" {
        if (!$pkg) { 
            Write-Error "Usage: wupm install <package-name>"
            Write-Detail "Example: wupm install firefox"
            return
        }
        
        Write-Box "Installing '$pkg'"
        $installed = $false
        
        # Priority order: WinGet → Chocolatey → Scoop → pip → npm
        $managers = @(
            @{Name='WinGet'; Available=$hasWinget; Cmd="winget install `"$pkg`" --accept-source-agreements --accept-package-agreements --silent"},
            @{Name='Chocolatey'; Available=$hasChoco; Cmd="choco install `"$pkg`" -y"},
            @{Name='Scoop'; Available=$hasScoop; Cmd="scoop install `"$pkg`""},
            @{Name='pip'; Available=$hasPip; Cmd="pip install `"$pkg`""},
            @{Name='NPM'; Available=$hasNpm; Cmd="npm install -g `"$pkg`""}
        )
        
        foreach ($mgr in $managers | Where-Object {$_.Available}) {
            Write-Info "│ Trying $($mgr.Name)..."
            
            try {
                Invoke-Expression $mgr.Cmd 2>&1 | Out-Null
                if ($LASTEXITCODE -eq 0) {
                    Write-Success "│ ✓ Successfully installed via $($mgr.Name)"
                    $installed = $true
                    break
                } else {
                    Write-Detail "│   $($mgr.Name) failed (Exit Code: $LASTEXITCODE)"
                }
            } catch {
                Write-Detail "│   $($mgr.Name) error: $($_.Exception.Message)"
            }
        }
        
        if (!$installed) {
            Write-Error "│ ✗ Failed to install '$pkg' via any available manager"
            Write-Detail "│ Try: wupm search $pkg (to verify package name)"
            Write-Detail "│ Or install package managers: WinGet, Chocolatey, Scoop"
        }
        
        Write-BoxEnd
    }
    
    "update" {
        Write-Box "System Update - Repositories + Windows + Store Apps"
        
        $success = 0
        $total = 0
        
        # Package Manager Updates
        if ($hasWinget) {
            $total++
            Write-Info "│ Updating WinGet sources..."
            try {
                winget source update 2>&1 | Out-Null
                if ($LASTEXITCODE -eq 0) {
                    Write-Success "│ ✓ WinGet sources updated"
                    $success++
                } else {
                    Write-Warning "│ ⚠ WinGet update issues detected"
                }
            } catch {
                Write-Warning "│ ⚠ WinGet update failed"
            }
        }
        
        if ($hasChoco) {
            $total++
            Write-Info "│ Updating Chocolatey..."
            try {
                choco upgrade chocolatey -y --limit-output 2>&1 | Out-Null
                Write-Success "│ ✓ Chocolatey updated"
                $success++
            } catch {
                Write-Warning "│ ⚠ Chocolatey update failed"
            }
        }
        
        if ($hasScoop) {
            $total++
            Write-Info "│ Updating Scoop..."
            try {
                $result = scoop update 2>&1
                if ($result -match "Scoop was updated successfully" -or $result -match "Latest versions") {
                    Write-Success "│ ✓ Scoop updated"
                } else {
                    Write-Warning "│ ⚠ Scoop update issues detected"
                }
                $success++
            } catch {
                Write-Warning "│ ⚠ Scoop update failed"
            }
        }
        
        if ($hasPip) {
            $total++
            Write-Info "│ Updating pip..."
            try {
                pip install --upgrade pip --quiet 2>&1 | Out-Null
                Write-Success "│ ✓ pip updated"
                $success++
            } catch {
                Write-Warning "│ ⚠ pip update failed"
            }
        }
        
        if ($hasNpm) {
            $total++
            Write-Info "│ Updating NPM..."
            try {
                npm update -g npm --silent 2>&1 | Out-Null
                Write-Success "│ ✓ NPM updated"
                $success++
            } catch {
                Write-Warning "│ ⚠ NPM update failed"
            }
        }
        
        # Windows Updates (requires Administrator)
        if ($isAdmin) {
            $total++
            Write-Info "│ Checking Windows Updates..."
            try {
                # Windows Update check without PSWindowsUpdate module
                $session = New-Object -ComObject Microsoft.Update.Session
                $searcher = $session.CreateUpdateSearcher()
                $searchResult = $searcher.Search("IsInstalled=0")
                
                if ($searchResult.Updates.Count -gt 0) {
                    Write-Warning "│ Found $($searchResult.Updates.Count) available Windows Updates"
                    Write-Detail "│   Manual installation: Settings → Update & Security → Windows Update"
                } else {
                    Write-Success "│ ✓ Windows Updates - system up to date"
                }
                $success++
            } catch {
                Write-Detail "│ Windows Update check via: Settings → Update & Security → Windows Update"
            }
        } else {
            Write-Warning "│ ⚠ Windows Updates require Administrator privileges"
            Write-Detail "│   Run PowerShell as Administrator for Windows Update access"
        }
        
        # Microsoft Store Updates
        $total++
        Write-Info "│ Checking Microsoft Store Apps..."
        try {
            if ($hasWinget) {
                $storeResult = winget upgrade --source msstore --accept-source-agreements --accept-package-agreements --silent 2>&1
                Write-Success "│ ✓ Microsoft Store Apps checked"
            } else {
                Write-Detail "│ Store Apps update automatically in background"
            }
            $success++
        } catch {
            Write-Detail "│ Manual update: Microsoft Store → Downloads and Updates"
        }
        
        Write-BoxEnd
        Write-Success "System update completed: $success/$total sources processed"
        
        if (!$isAdmin) {
            Write-Info "💡 Tip: Run as Administrator for complete Windows Update access"
        }
    }
    
    "upgrade" {
        Write-Box "System Upgrade - All Package Updates"
        
        $packagesUpgraded = 0
        
        if ($hasWinget) {
            Write-Info "│ Upgrading WinGet packages..."
            try {
                winget upgrade --all --accept-source-agreements --accept-package-agreements --silent
                Write-Success "│ ✓ WinGet packages upgraded"
                $packagesUpgraded++
            } catch {
                Write-Warning "│ ⚠ Some WinGet upgrades failed"
            }
        }
        
        if ($hasChoco) {
            Write-Info "│ Upgrading Chocolatey packages..."
            try {
                choco upgrade all -y --limit-output
                Write-Success "│ ✓ Chocolatey packages upgraded"
                $packagesUpgraded++
            } catch {
                Write-Warning "│ ⚠ Some Chocolatey upgrades failed"
            }
        }
        
        if ($hasScoop) {
            Write-Info "│ Upgrading Scoop packages..."
            try {
                scoop update *
                Write-Success "│ ✓ Scoop packages upgraded"
                $packagesUpgraded++
            } catch {
                Write-Warning "│ ⚠ Some Scoop upgrades failed"
            }
        }
        
        if ($hasPip) {
            Write-Info "│ Upgrading pip packages..."
            try {
                $outdated = pip list --outdated --format=freeze 2>$null | Where-Object { $_ -match "==" }
                if ($outdated) {
                    $packages = $outdated | ForEach-Object { ($_ -split "==")[0] }
                    pip install --upgrade $packages --quiet 2>$null
                    Write-Success "│ ✓ pip packages upgraded ($($packages.Count) packages)"
                    $packagesUpgraded++
                } else {
                    Write-Success "│ ✓ pip packages are up to date"
                }
            } catch {
                Write-Warning "│ ⚠ pip upgrade failed"
            }
        }
        
        if ($hasNpm) {
            Write-Info "│ Upgrading NPM global packages..."
            try {
                npm update -g --silent 2>$null
                Write-Success "│ ✓ NPM global packages upgraded"
                $packagesUpgraded++
            } catch {
                Write-Warning "│ ⚠ NPM upgrade failed"
            }
        }
        
        Write-BoxEnd
        if ($packagesUpgraded -gt 0) {
            Write-Success "Package upgrade completed: $packagesUpgraded package managers processed"
        } else {
            Write-Info "🎉 All packages appear to be up to date!"
        }
        
        if (!$isAdmin) {
            Write-Info "💡 Tip: Run as Administrator for Windows Updates and system packages"
        }
    }
    
    "list" {
        if ($pkg -eq "--upgradable" -or $pkg -eq "--outdated") {
            Write-Box "Available Updates Analysis"
            
            if ($hasWinget) {
                Write-Info "│ [WinGet Available Updates]"
                try {
                    winget upgrade
                } catch {
                    Write-Warning "│ ⚠ Could not check WinGet updates"
                }
                Write-Info "│"
            }
            
            if ($hasChoco) {
                Write-Info "│ [Chocolatey Available Updates]"
                try {
                    choco outdated
                } catch {
                    Write-Warning "│ ⚠ Could not check Chocolatey updates"
                }
                Write-Info "│"
            }
            
            if ($hasScoop) {
                Write-Info "│ [Scoop Available Updates]"
                try {
                    scoop status
                } catch {
                    Write-Warning "│ ⚠ Could not check Scoop updates"
                }
                Write-Info "│"
            }
            
            Write-BoxEnd
            Write-Info "💡 Use 'wupm upgrade' to install all available updates"
            
        } else {
            # Show system status instead of simple list
            Show-DetailedStatus
        }
    }
    
    "version" {
        Write-Info "╔══════════════════════════════════════════════════════════════════════════════╗"
        Write-Info "║              WUPM - Windows Universal Package Manager v1.3                  ║"
        Write-Info "║                          Complete Final Edition                             ║"
        Write-Info "╚══════════════════════════════════════════════════════════════════════════════╝"
        
        $sysInfo = Get-SystemInfo
        Write-Info ""
        Write-Highlight "📋 SYSTEM SUMMARY"
        if ($sysInfo.OS) {
            Write-Success "   OS: $($sysInfo.OS) ($($sysInfo.Architecture))"
            Write-Success "   PowerShell: $($sysInfo.PowerShell)"
        }
        Write-Success "   Admin Mode: $(if($isAdmin){'Yes - Full System Access'}else{'No - Limited Access'})"
        
        Write-Info ""
        Write-Highlight "📦 DETECTED PACKAGE MANAGERS"
        if ($hasWinget) { Write-Success "   ✓ WinGet - Windows Package Manager" }
        if ($hasChoco) { Write-Success "   ✓ Chocolatey - Community Repository" }
        if ($hasScoop) { Write-Success "   ✓ Scoop - Portable Applications" }
        if ($hasPip) { Write-Success "   ✓ pip - Python Packages" }
        if ($hasNpm) { Write-Success "   ✓ NPM - Node.js Packages" }
        if ($hasCargo) { Write-Success "   ✓ Cargo - Rust Packages" }
        
        $totalManagers = @($hasWinget, $hasChoco, $hasScoop, $hasPip, $hasNpm, $hasCargo) | Where-Object {$_} | Measure-Object | Select-Object -ExpandProperty Count
        Write-Info ""
        Write-Highlight "⚡ QUICK COMMANDS"
        Write-Info "   wupm status              # Complete system analysis ($totalManagers managers detected)"
        Write-Info "   wupm update              # Update repositories + Windows + Store Apps"
        Write-Info "   wupm upgrade             # Upgrade all packages across all managers"
        Write-Info "   wupm search <package>    # Search across all package managers"
        Write-Info "   wupm install <package>   # Smart installation with automatic fallback"
        Write-Info "   wupm list --upgradable   # Show all available updates"
        
        Write-Info ""
        Write-Info "🌐 Project: https://github.com/yourusername/wupm"
        Write-Info "📚 Documentation: https://github.com/yourusername/wupm/wiki"
    }
    
    "help" {
        Write-Info @"
╔══════════════════════════════════════════════════════════════════════════════╗
║                    WUPM - WINDOWS UNIVERSAL PACKAGE MANAGER                 ║
║                            Complete Final Edition v1.3                      ║
╚══════════════════════════════════════════════════════════════════════════════╝

🎯 MAIN COMMANDS:
   status                   Complete system health report with recommendations
   search <package>         Search across all available package managers  
   install <package>        Intelligent installation with automatic fallback
   update                   Update repositories + Windows Updates + Store Apps
   upgrade                  Upgrade all packages across all managers
   list [--upgradable]      Show system status or available package updates  
   version                  Version information with system summary
   help                     Show this comprehensive help message

🔍 DETAILED EXAMPLES:
   wupm status                      # Complete system analysis & health report
   wupm search firefox              # Search for Firefox across all managers
   wupm install "visual studio code"  # Install with quotes for multi-word packages
   wupm update                      # Update everything (repositories, Windows, Store)
   wupm upgrade                     # Upgrade all packages (like Linux apt upgrade) 
   wupm list --upgradable           # Show all available package updates

📦 SUPPORTED PACKAGE MANAGERS:
"@

        if ($hasWinget) { Write-Success "   ✓ WinGet - Microsoft's Windows Package Manager" }
        if ($hasChoco) { Write-Success "   ✓ Chocolatey - Community-driven package repository" }  
        if ($hasScoop) { Write-Success "   ✓ Scoop - Portable application installer" }
        if ($hasPip) { Write-Success "   ✓ pip - Python package installer" }
        if ($hasNpm) { Write-Success "   ✓ NPM - Node.js package manager" }
        if ($hasCargo) { Write-Success "   ✓ Cargo - Rust package manager" }

        Write-Info @"

🌟 SYSTEM INTEGRATION:
   ✓ Windows System Updates (requires Administrator privileges)
   ✓ Microsoft Store Apps (automatic detection and updates)  
   ✓ Cross-manager package installation (tries all available managers)
   ✓ Intelligent error handling with automatic fallback mechanisms
   ✓ Detailed system health monitoring and performance recommendations

🚀 Finally - Linux-style package management that actually works on Windows!

💡 TIPS:
   • Run as Administrator for Windows Updates and system-level packages
   • Use quotes for multi-word package names: "visual studio code"
   • Regular maintenance: wupm update && wupm upgrade
   • System health check: wupm status (shows hardware, disk space, recommendations)

🌐 More information: https://github.com/yourusername/wupm
"@
    }
    
    default {
        if ($cmd) {
            Write-Warning "Unknown command: '$cmd'"
            Write-Info "Use 'wupm help' to see all available commands"
        } else {
            Write-Info "WUPM - Windows Universal Package Manager v1.3"
            Write-Info "Finally, Linux-style package management for Windows! 🚀"
        }
        Write-Info ""
        Write-Info "Quick start:"
        Write-Info "   wupm status                # Complete system analysis"
        Write-Info "   wupm search firefox        # Search for software"
        Write-Info "   wupm install firefox       # Install software"
        Write-Info "   wupm update && wupm upgrade  # Update everything"
        Write-Info "   wupm help                  # Show detailed help"
        Write-Info ""
        Write-Info "🌐 Documentation: https://github.com/yourusername/wupm"
    }
}
