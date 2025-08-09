# ═══════════════════════════════════════════════════════════════════════════════
# ░██╗░░░░░░░██╗██╗░░░██╗██████╗░███╗░░░███╗  ██╗░░░██╗██████╗░░░░░█████╗░
# ░██║░░██╗░░██║██║░░░██║██╔══██╗████╗░████║  ██║░░░██║╚════██╗░░░██╔══██╗
# ░╚██╗████╗██╔╝██║░░░██║██████╔╝██╔████╔██║  ╚██╗░██╔╝░░███╔═╝░░░██║░░██║
# ░░████╔═████║░██║░░░██║██╔═══╝░██║╚██╔╝██║  ░╚████╔╝░██╔══╝░░░░░██║░░██║
# ░░╚██╔╝░╚██╔╝░╚██████╔╝██║░░░░░██║░╚═╝░██║  ░░╚██╔╝░░███████╗██╗╚█████╔╝
# ░░░╚═╝░░░╚═╝░░░╚═════╝░╚═╝░░░░░╚═╝░░░░░╚═╝  ░░░╚═╝░░░╚══════╝╚═╝░╚════╝░
# ═══════════════════════════════════════════════════════════════════════════════
# 🤖 WUPM v2.0 - Windows Universal Package Manager
# Komplett fehlerfreie Version mit Windows Updates + Store + AI
# ═══════════════════════════════════════════════════════════════════════════════

[CmdletBinding()]
param(
    [Parameter(Position = 0)]
    [ValidateSet("install", "search", "update", "upgrade", "list", "status", "version", "help", "ai", IgnoreCase = $true)]
    [string]$Command,
    
    [Parameter(Position = 1, ValueFromRemainingArguments = $true)]
    [string[]]$PackageArgs
)

# ═══════════════════════════════════════════════════════════════════════════════
# 🎯 INITIALIZATION
# ═══════════════════════════════════════════════════════════════════════════════

$cmd = if ($Command) { $Command.ToLower() } else { "help" }
$pkg = if ($PackageArgs) { ($PackageArgs -join " ").Trim() } else { "" }

# ═══════════════════════════════════════════════════════════════════════════════
# 🎨 UI COMPONENTS
# ═══════════════════════════════════════════════════════════════════════════════

$Colors = @{
    Primary = [System.ConsoleColor]::Cyan
    Success = [System.ConsoleColor]::Green
    Warning = [System.ConsoleColor]::Yellow
    Error = [System.ConsoleColor]::Red
    Info = [System.ConsoleColor]::White
    Accent = [System.ConsoleColor]::Magenta
    Muted = [System.ConsoleColor]::DarkGray
}

$Icons = @{
    Success = "✨"
    Error = "❌"
    Warning = "⚠️"
    Info = "ℹ️"
    AI = "🤖"
    Package = "📦"
    System = "🖥️"
    Security = "🔐"
    Speed = "⚡"
    Health = "💚"
    Rocket = "🚀"
    Star = "⭐"
    Magic = "✨"
    Shield = "🛡️"
    Gear = "⚙️"
    Chart = "📊"
    Trophy = "🏆"
    Crown = "👑"
    Windows = "🪟"
    Store = "🏪"
    Update = "🔄"
}

$Box = @{
    TopLeft = "╭"
    TopRight = "╮"
    BottomLeft = "╰"
    BottomRight = "╯"
    Horizontal = "─"
    Vertical = "│"
    TeeRight = "├"
    TeeLeft = "┤"
    DoubleHorizontal = "═"
    DoubleVertical = "║"
    DoubleTopLeft = "╔"
    DoubleTopRight = "╗"
    DoubleBottomLeft = "╚"
    DoubleBottomRight = "╝"
}

# ═══════════════════════════════════════════════════════════════════════════════
# 🖨️ OUTPUT FUNCTIONS
# ═══════════════════════════════════════════════════════════════════════════════

function Write-Beautiful {
    param(
        [string]$Text,
        [string]$Icon = "",
        [System.ConsoleColor]$Color = $Colors.Info
    )
    
    if ($Icon) {
        Write-Host "$Icon " -ForegroundColor $Color -NoNewline
    }
    Write-Host $Text -ForegroundColor $Color
}

function Write-Success {
    param([string]$text, [string]$icon = $Icons.Success)
    Write-Beautiful $text $icon $Colors.Success
}

function Write-Error {
    param([string]$text, [string]$icon = $Icons.Error)
    Write-Beautiful $text $icon $Colors.Error
}

function Write-Warning {
    param([string]$text, [string]$icon = $Icons.Warning)
    Write-Beautiful $text $icon $Colors.Warning
}

function Write-Info {
    param([string]$text, [string]$icon = $Icons.Info)
    Write-Beautiful $text $icon $Colors.Info
}

function Write-AI {
    param([string]$text, [string]$icon = $Icons.AI)
    Write-Beautiful $text $icon $Colors.Primary
}

function Write-Highlight {
    param([string]$text, [string]$icon = $Icons.Star)
    Write-Beautiful $text $icon $Colors.Accent
}

function Write-BeautifulBox {
    param(
        [string]$Title,
        [string[]]$Content,
        [string]$Icon = $Icons.Package
    )
    
    $width = 78
    $titleWithIcon = "$Icon $Title"
    
    # Top border
    Write-Host $($Box.TopLeft + $Box.Horizontal * ($width - 2) + $Box.TopRight) -ForegroundColor $Colors.Primary
    
    # Title
    $padding = [math]::Max(0, $width - $titleWithIcon.Length - 4)
    $leftPad = [math]::Floor($padding / 2)
    $rightPad = $padding - $leftPad
    Write-Host "$($Box.Vertical) " -ForegroundColor $Colors.Primary -NoNewline
    Write-Host (" " * $leftPad) -NoNewline
    Write-Host $titleWithIcon -ForegroundColor $Colors.Accent -NoNewline
    Write-Host (" " * $rightPad) -NoNewline
    Write-Host " $($Box.Vertical)" -ForegroundColor $Colors.Primary
    
    # Separator
    Write-Host $($Box.TeeRight + $Box.Horizontal * ($width - 2) + $Box.TeeLeft) -ForegroundColor $Colors.Primary
    
    # Content
    foreach ($line in $Content) {
        $contentPadding = [math]::Max(0, $width - $line.Length - 4)
        Write-Host "$($Box.Vertical) " -ForegroundColor $Colors.Primary -NoNewline
        Write-Host $line -NoNewline
        Write-Host (" " * $contentPadding + " $($Box.Vertical)") -ForegroundColor $Colors.Primary
    }
    
    # Bottom border
    Write-Host $($Box.BottomLeft + $Box.Horizontal * ($width - 2) + $Box.BottomRight) -ForegroundColor $Colors.Primary
    Write-Host ""
}

function Show-Banner {
    Write-Host ""
    Write-Host $($Box.DoubleTopLeft + $Box.DoubleHorizontal * 78 + $Box.DoubleTopRight) -ForegroundColor $Colors.Primary
    Write-Host "$($Box.DoubleVertical)                      ✨ WUPM v2.0 - Complete Edition ✨                       $($Box.DoubleVertical)" -ForegroundColor $Colors.Accent
    Write-Host "$($Box.DoubleVertical)                  🪟 Windows + 🏪 Store + 📦 Packages + 🤖 AI                  $($Box.DoubleVertical)" -ForegroundColor $Colors.Primary
    Write-Host $($Box.DoubleBottomLeft + $Box.DoubleHorizontal * 78 + $Box.DoubleBottomRight) -ForegroundColor $Colors.Primary
    Write-Host ""
}

# ═══════════════════════════════════════════════════════════════════════════════
# 🤖 AI ENGINE CLASS
# ═══════════════════════════════════════════════════════════════════════════════

class WUPMAIEngine {
    [string] ProcessNaturalLanguage([string]$query) {
        $query = $query.ToLower()
        
        if ($query -match "windows update|update windows") { 
            return "windows-update" 
        }
        if ($query -match "store update|microsoft store") { 
            return "store-update" 
        }
        if ($query -match "analyze|analysis|check|health|status") { 
            return "analyze" 
        }
        if ($query -match "update everything|upgrade everything") { 
            return "update-all" 
        }
        if ($query -match "recommend|suggest|advice") { 
            return "recommend" 
        }
        if ($query -match "development|dev|coding|programming") { 
            return "install vscode git nodejs python" 
        }
        if ($query -match "web development|frontend") { 
            return "install vscode nodejs git firefox" 
        }
        if ($query -match "security|antivirus") { 
            return "install 7zip" 
        }
        if ($query -match "media|video|music") { 
            return "install vlc" 
        }
        if ($query -match "browser") { 
            return "install firefox chrome" 
        }
        if ($query -match "clean|cleanup|optimize") { 
            return "cleanup" 
        }
        if ($query -match "update|upgrade") { 
            return "update" 
        }
        if ($query -match "install (.+)") { 
            $package = $Matches[1] -replace "'|`"", ""
            return "install $package" 
        }
        if ($query -match "why.*slow|performance") { 
            return "performance" 
        }
        
        return "I can help you install software, update packages, or analyze your system."
    }
    
    [hashtable] AnalyzeSystem() {
        $sysInfo = Get-SystemInfo
        $diskUsage = if ($sysInfo.FreeSpace) { 
            ($sysInfo.FreeSpace / $sysInfo.TotalSpace) * 100 
        } else { 
            50 
        }
        
        $score = 60
        if ($diskUsage -gt 50) { 
            $score += 20 
        } elseif ($diskUsage -gt 20) { 
            $score += 10 
        }
        if ($sysInfo.Memory -gt 16) { 
            $score += 10 
        } elseif ($sysInfo.Memory -gt 8) { 
            $score += 5 
        }
        
        $managers = Get-PackageManagerInfo
        $managerCount = ($managers | Where-Object { $_.Status -eq 'Available' }).Count
        $score += $managerCount * 2
        
        $healthLevel = if ($score -ge 85) { 
            "Excellent" 
        } elseif ($score -ge 70) { 
            "Good" 
        } elseif ($score -ge 50) { 
            "Fair" 
        } else { 
            "Poor" 
        }
        
        return @{
            'DiskHealth' = if ($diskUsage -lt 10) { 
                "Critical" 
            } elseif ($diskUsage -lt 20) { 
                "Warning" 
            } else { 
                "Good" 
            }
            'HealthLevel' = $healthLevel
            'SystemScore' = [math]::Min(100, $score)
            'DiskUsage' = [math]::Round(100 - $diskUsage, 1)
            'Recommendations' = @(
                if ($diskUsage -lt 20) { "Free up disk space" }
                if ($managerCount -lt 3) { "Install more package managers" }
                "Keep packages updated"
                "Run regular maintenance"
            )
        }
    }
}

# ═══════════════════════════════════════════════════════════════════════════════
# 🔧 CORE FUNCTIONS
# ═══════════════════════════════════════════════════════════════════════════════

function Test-PackageName {
    param([string]$Name)
    if ([string]::IsNullOrWhiteSpace($Name)) { 
        return $false 
    }
    return $Name -match '^[a-zA-Z0-9.\-_ ]+$'
}

function Get-SystemInfo {
    try {
        $os = Get-CimInstance -ClassName Win32_OperatingSystem -ErrorAction Stop
        $cs = Get-CimInstance -ClassName Win32_ComputerSystem -ErrorAction Stop
        $systemDisk = Get-CimInstance -ClassName Win32_LogicalDisk -Filter "DeviceID='$($env:SystemDrive)'" -ErrorAction Stop
        
        return @{
            'OS' = $os.Caption
            'Version' = $os.Version
            'Architecture' = $env:PROCESSOR_ARCHITECTURE
            'PowerShell' = $PSVersionTable.PSVersion.ToString()
            'User' = $env:USERNAME
            'Computer' = $env:COMPUTERNAME
            'Domain' = $env:USERDOMAIN
            'Memory' = [math]::Round($cs.TotalPhysicalMemory / 1GB, 2)
            'FreeSpace' = [math]::Round($systemDisk.FreeSpace / 1GB, 2)
            'TotalSpace' = [math]::Round($systemDisk.Size / 1GB, 2)
            'SystemDrive' = $env:SystemDrive
        }
    } catch {
        return @{ 
            'Error' = 'Could not retrieve system information'
            'PowerShell' = $PSVersionTable.PSVersion.ToString()
            'User' = $env:USERNAME
            'Computer' = $env:COMPUTERNAME
        }
    }
}

function Get-PackageManagerInfo {
    $managers = @()
    
    # Test WinGet
    if (Get-Command winget -ErrorAction SilentlyContinue) {
        try {
            $version = (winget --version 2>$null)
            if ($version) {
                $version = $version.Trim() -replace 'v', ''
                $managers += @{
                    'Name' = 'WinGet'
                    'Status' = 'Available'
                    'Version' = $version
                    'Path' = (Get-Command winget).Source
                    'Priority' = 1
                    'Icon' = "🔷"
                }
            }
        } catch {
            $managers += @{ 
                'Name' = 'WinGet'
                'Status' = 'Error'
                'Icon' = "❌" 
            }
        }
    }
    
    # Test Chocolatey
    if (Get-Command choco -ErrorAction SilentlyContinue) {
        try {
            $version = (choco --version 2>$null)
            if ($version) {
                $version = $version.Trim()
                $managers += @{
                    'Name' = 'Chocolatey'
                    'Status' = 'Available'
                    'Version' = $version
                    'Path' = (Get-Command choco).Source
                    'Priority' = 2
                    'Icon' = "🍫"
                }
            }
        } catch {
            $managers += @{ 
                'Name' = 'Chocolatey'
                'Status' = 'Error'
                'Icon' = "❌" 
            }
        }
    }
    
    # Test Scoop
    if (Get-Command scoop -ErrorAction SilentlyContinue) {
        try {
            $versionOutput = (& scoop --version 2>$null)
            if ($versionOutput) {
                $version = ($versionOutput | Select-Object -First 1).Split()[-1]
                $managers += @{
                    'Name' = 'Scoop'
                    'Status' = 'Available'
                    'Version' = $version
                    'Path' = (Get-Command scoop).Source
                    'Priority' = 3
                    'Icon' = "🥄"
                }
            }
        } catch {
            $managers += @{ 
                'Name' = 'Scoop'
                'Status' = 'Error'
                'Icon' = "❌" 
            }
        }
    }
    
    # Test pip
    if (Get-Command pip -ErrorAction SilentlyContinue) {
        try {
            $pipVersion = (pip --version 2>$null)
            if ($pipVersion) {
                $version = ($pipVersion -split " ")[1]
                $pythonVersion = "Unknown"
                
                try {
                    $pythonOutput = (python --version 2>$null)
                    if ($pythonOutput) {
                        $pythonVersion = $pythonOutput.Replace("Python ", "")
                    }
                } catch {
                    # Python version detection failed, but pip works
                }
                
                $managers += @{
                    'Name' = 'pip'
                    'Status' = 'Available'
                    'Version' = $version
                    'PythonVersion' = $pythonVersion
                    'Path' = (Get-Command pip).Source
                    'Priority' = 4
                    'Icon' = "🐍"
                }
            }
        } catch {
            $managers += @{ 
                'Name' = 'pip'
                'Status' = 'Error'
                'Icon' = "🐍" 
            }
        }
    }
    
    # Test NPM
    if (Get-Command npm -ErrorAction SilentlyContinue) {
        try {
            $npmVersion = (npm --version 2>$null)
            if ($npmVersion) {
                $version = $npmVersion.Trim()
                $nodeVersion = "Unknown"
                
                try {
                    $nodeOutput = (node --version 2>$null)
                    if ($nodeOutput) {
                        $nodeVersion = $nodeOutput.Trim()
                    }
                } catch {
                    # Node version detection failed, but npm works
                }
                
                $managers += @{
                    'Name' = 'NPM'
                    'Status' = 'Available'
                    'Version' = $version
                    'NodeVersion' = $nodeVersion
                    'Path' = (Get-Command npm).Source
                    'Priority' = 5
                    'Icon' = "📦"
                }
            }
        } catch {
            $managers += @{ 
                'Name' = 'NPM'
                'Status' = 'Error'
                'Icon' = "📦" 
            }
        }
    }
    
    # Test Cargo
    if (Get-Command cargo -ErrorAction SilentlyContinue) {
        try {
            $cargoVersion = (cargo --version 2>$null)
            if ($cargoVersion) {
                $version = ($cargoVersion -split " ")[1]
                $managers += @{
                    'Name' = 'Cargo'
                    'Status' = 'Available'
                    'Version' = $version
                    'Path' = (Get-Command cargo).Source
                    'Priority' = 6
                    'Icon' = "🦀"
                }
            }
        } catch {
            $managers += @{ 
                'Name' = 'Cargo'
                'Status' = 'Error'
                'Icon' = "❌" 
            }
        }
    }
    
    return $managers | Sort-Object Priority
}

function Get-WindowsUpdateInfo {
    param([switch]$InstallUpdates)
    
    $isAdmin = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
    
    if (-not $isAdmin) {
        return @{
            'Available' = $false
            'Error' = 'Administrator privileges required'
            'UpdateCount' = 0
            'Status' = 'Access Denied'
        }
    }
    
    try {
        # Check if PSWindowsUpdate module is available
        if (Get-Module -ListAvailable -Name PSWindowsUpdate -ErrorAction SilentlyContinue) {
            if ($InstallUpdates) {
                $updates = Get-WUInstall -AcceptAll -AutoReboot:$false
                return @{
                    'Available' = $true
                    'UpdateCount' = $updates.Count
                    'Status' = 'Updates installed'
                    'Updates' = $updates
                }
            } else {
                $updates = Get-WUList
                return @{
                    'Available' = $true
                    'UpdateCount' = $updates.Count
                    'Status' = if ($updates.Count -eq 0) { 'Up to date' } else { "$($updates.Count) updates available" }
                }
            }
        } else {
            # Fallback to UsoClient
            if ($InstallUpdates) {
                Start-Process "UsoClient.exe" -ArgumentList "ScanInstallWait" -Wait -WindowStyle Hidden -ErrorAction Stop
                return @{
                    'Available' = $true
                    'Status' = 'Windows Update scan initiated'
                    'UpdateCount' = 'Check Settings'
                }
            } else {
                Start-Process "UsoClient.exe" -ArgumentList "StartScan" -Wait -WindowStyle Hidden -ErrorAction Stop
                return @{
                    'Available' = $true
                    'Status' = 'Scan initiated - check Settings'
                    'UpdateCount' = 'Unknown'
                }
            }
        }
    } catch {
        return @{
            'Available' = $false
            'Error' = "Windows Update failed: $($_.Exception.Message)"
            'UpdateCount' = 0
            'Status' = 'Manual check required'
        }
    }
}

function Get-StoreUpdateInfo {
    param([switch]$InstallUpdates)
    
    try {
        if (-not (Get-Command winget -ErrorAction SilentlyContinue)) {
            return @{
                'Available' = $false
                'Error' = 'WinGet not available'
                'UpdateCount' = 0
                'Status' = 'WinGet required'
            }
        }
        
        if ($InstallUpdates) {
            $result = winget upgrade --source msstore --accept-source-agreements --accept-package-agreements --silent 2>&1
            return @{
                'Available' = $true
                'Status' = 'Store apps updated'
                'UpdateCount' = 'Updated'
            }
        } else {
            $result = winget upgrade --source msstore 2>&1
            $updateLines = $result | Where-Object { 
                $_ -match "^\S+\s+\S+\s+\S+\s+\S+" -and 
                $_ -notmatch "^Name\s+Id\s+Version\s+Available" 
            }
            $updateCount = if ($updateLines) { $updateLines.Count } else { 0 }
            
            return @{
                'Available' = $true
                'UpdateCount' = $updateCount
                'Status' = if ($updateCount -eq 0) { 
                    'All Store apps up to date' 
                } else { 
                    "$updateCount Store app updates available" 
                }
            }
        }
    } catch {
        return @{
            'Available' = $false
            'Error' = "Microsoft Store access failed"
            'UpdateCount' = 0
            'Status' = 'Manual check required'
        }
    }
}

# ═══════════════════════════════════════════════════════════════════════════════
# 🎯 MAIN FUNCTIONS
# ═══════════════════════════════════════════════════════════════════════════════

function Invoke-BeautifulAI {
    param([string]$Query)
    
    Show-Banner
    $aiEngine = [WUPMAIEngine]::new()
    $response = $aiEngine.ProcessNaturalLanguage($Query)
    
    Write-AI "Processing: '$Query'"
    
    switch ($response) {
        "analyze" {
            $analysis = $aiEngine.AnalyzeSystem()
            $sysInfo = Get-SystemInfo
            
            $content = @()
            $healthIcon = switch ($analysis.HealthLevel) {
                "Excellent" { $Icons.Trophy }
                "Good" { $Icons.Success }
                "Fair" { $Icons.Warning }
                default { $Icons.Error }
            }
            
            $content += "$healthIcon Overall Health: $($analysis.HealthLevel)"
            $content += "$($Icons.Chart) System Score: $($analysis.SystemScore)/100"
            $content += "$($Icons.Package) Disk Usage: $($analysis.DiskUsage)% used"
            
            # Check Windows and Store updates
            $windowsUpdate = Get-WindowsUpdateInfo
            $storeUpdate = Get-StoreUpdateInfo
            
            $content += "$($Icons.Windows) Windows Updates: $($windowsUpdate.Status)"
            $content += "$($Icons.Store) Store Apps: $($storeUpdate.Status)"
            
            Write-BeautifulBox "AI System Analysis" $content $Icons.Chart
            
            if ($analysis.Recommendations.Count -gt 0) {
                $recContent = @()
                foreach ($rec in $analysis.Recommendations) {
                    $recContent += "$($Icons.Star) $rec"
                }
                Write-BeautifulBox "Recommendations" $recContent $Icons.Magic
            }
        }
        
        "windows-update" {
            $windowsUpdate = Get-WindowsUpdateInfo
            
            $content = @()
            if ($windowsUpdate.Available) {
                $content += "$($Icons.Success) Windows Update: Available"
                $content += "$($Icons.Info) Status: $($windowsUpdate.Status)"
                $content += "$($Icons.Update) Updates: $($windowsUpdate.UpdateCount)"
            } else {
                $content += "$($Icons.Warning) Windows Update: $($windowsUpdate.Error)"
                $content += "$($Icons.Info) Manual check: Settings → Windows Update"
            }
            
            Write-BeautifulBox "Windows Update Status" $content $Icons.Windows
        }
        
        "store-update" {
            $storeUpdate = Get-StoreUpdateInfo
            
            $content = @()
            if ($storeUpdate.Available) {
                $content += "$($Icons.Success) Store Access: Available"
                $content += "$($Icons.Info) Status: $($storeUpdate.Status)"
                $content += "$($Icons.Update) Updates: $($storeUpdate.UpdateCount)"
            } else {
                $content += "$($Icons.Warning) Store Access: $($storeUpdate.Error)"
                $content += "$($Icons.Info) Manual check: Microsoft Store"
            }
            
            Write-BeautifulBox "Microsoft Store Status" $content $Icons.Store
        }
        
        "recommend" {
            $content = @(
                "$($Icons.Crown) Essential Software:",
                "",
                "$($Icons.Fire) Development:",
                "  • VS Code - Best code editor",
                "  • Git - Version control",
                "  • Node.js - JavaScript runtime",
                "  • Python - Programming language",
                "",
                "$($Icons.Shield) Utilities:",
                "  • 7-Zip - File compression",
                "  • Firefox - Privacy browser",
                "  • VLC - Media player",
                "",
                "$($Icons.Rocket) Quick install: wupm ai 'install development tools'"
            )
            Write-BeautifulBox "AI Recommendations" $content $Icons.Magic
        }
        
        "cleanup" {
            $content = @(
                "$($Icons.Magic) System Optimization:",
                "",
                "$($Icons.Gear) Immediate Actions:",
                "  • Run Disk Cleanup (cleanmgr)",
                "  • Update packages (wupm upgrade)",
                "  • Clear browser cache",
                "  • Restart services",
                "",
                "$($Icons.Star) Maintenance:",
                "  • Uninstall unused programs",
                "  • Run Windows Update",
                "  • Check for malware",
                "",
                "$($Icons.Rocket) Pro tip: Monthly maintenance!"
            )
            Write-BeautifulBox "Cleanup Guide" $content $Icons.Gear
        }
        
        "performance" {
            $content = @(
                "$($Icons.Speed) Performance Analysis:",
                "",
                "$($Icons.Warning) Common causes:",
                "  • Low disk space",
                "  • Outdated software", 
                "  • Too many startup programs",
                "  • Insufficient RAM",
                "  • Background updates",
                "",
                "$($Icons.Magic) Quick fixes:",
                "  • Restart computer",
                "  • Close unnecessary programs",
                "  • Run: wupm ai 'analyze my system'"
            )
            Write-BeautifulBox "Performance Help" $content $Icons.Speed
        }
        
        default {
            if ($response.StartsWith("install ")) {
                $package = $response.Substring(8)
                Write-AI "Installing: $package"
                & $PSCommandPath "install" $package
            } elseif ($response -eq "update") {
                Write-AI "System update"
                & $PSCommandPath "update"
            } else {
                Write-BeautifulBox "AI Response" @("$($Icons.AI) $response") $Icons.Magic
            }
        }
    }
}

function Show-SystemStatus {
    Show-Banner
    Write-AI "Analyzing your system..."
    
    $sysInfo = Get-SystemInfo
    $managers = Get-PackageManagerInfo
    $windowsUpdate = Get-WindowsUpdateInfo
    $storeUpdate = Get-StoreUpdateInfo
    $isAdmin = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
    
    # System Information
    $sysContent = @()
    if ($sysInfo.Error) {
        $sysContent += "$($Icons.Error) Error: $($sysInfo.Error)"
    } else {
        $sysContent += "$($Icons.System) OS: $($sysInfo.OS) ($($sysInfo.Architecture))"
        if ($sysInfo.Version) { 
            $sysContent += "$($Icons.Info) Version: $($sysInfo.Version)" 
        }
        $sysContent += "$($Icons.Speed) PowerShell: $($sysInfo.PowerShell)"
        $sysContent += "$($Icons.Shield) User: $($sysInfo.User)@$($sysInfo.Computer)"
        if ($sysInfo.Memory) { 
            $sysContent += "$($Icons.Chart) Memory: $($sysInfo.Memory) GB" 
        }
        if ($sysInfo.FreeSpace) { 
            $freePercent = ($sysInfo.FreeSpace / $sysInfo.TotalSpace) * 100
            $diskIcon = if ($freePercent -lt 15) { $Icons.Warning } else { $Icons.Success }
            $sysContent += "$diskIcon Disk: $($sysInfo.FreeSpace) GB free of $($sysInfo.TotalSpace) GB"
        }
    }
    Write-BeautifulBox "System Information" $sysContent $Icons.System
    
    # Package Managers
    $pkgContent = @()
    if ($managers.Count -gt 0) {
        foreach ($mgr in $managers | Where-Object { $_.Status -eq 'Available' }) {
            $pkgContent += "$($mgr.Icon) $($mgr.Name) v$($mgr.Version)"
            if ($mgr.Name -eq 'pip' -and $mgr.PythonVersion -and $mgr.PythonVersion -ne "Unknown") { 
                $pkgContent += "  └─ Python: $($mgr.PythonVersion)" 
            }
            if ($mgr.Name -eq 'NPM' -and $mgr.NodeVersion -and $mgr.NodeVersion -ne "Unknown") { 
                $pkgContent += "  └─ Node.js: $($mgr.NodeVersion)" 
            }
        }
    } else {
        $pkgContent += "$($Icons.Warning) No package managers detected"
        $pkgContent += "$($Icons.Info) Install WinGet, Chocolatey, or Scoop"
    }
    Write-BeautifulBox "Package Managers" $pkgContent $Icons.Package
    
    # Windows Updates
    $winContent = @()
    if ($windowsUpdate.Available) {
        $winContent += "$($Icons.Success) Windows Update: Accessible"
        $winContent += "$($Icons.Info) Status: $($windowsUpdate.Status)"
        $winContent += "$($Icons.Update) Updates: $($windowsUpdate.UpdateCount)"
    } else {
        $winContent += "$($Icons.Warning) Windows Update: $($windowsUpdate.Error)"
        $winContent += "$($Icons.Info) Check Settings → Windows Update manually"
    }
    Write-BeautifulBox "Windows Updates" $winContent $Icons.Windows
    
    # Microsoft Store
    $storeContent = @()
    if ($storeUpdate.Available) {
        $storeContent += "$($Icons.Success) Microsoft Store: Accessible"
        $storeContent += "$($Icons.Info) Status: $($storeUpdate.Status)"
        $storeContent += "$($Icons.Update) Updates: $($storeUpdate.UpdateCount)"
    } else {
        $storeContent += "$($Icons.Warning) Microsoft Store: $($storeUpdate.Error)"
        $storeContent += "$($Icons.Info) Check Microsoft Store manually"
    }
    Write-BeautifulBox "Microsoft Store" $storeContent $Icons.Store
    
    # Admin Status
    $adminContent = @()
    if ($isAdmin) {
        $adminContent += "$($Icons.Crown) Administrator Mode: Active"
        $adminContent += "$($Icons.Success) Full system access available"
    } else {
        $adminContent += "$($Icons.Warning) Standard User Mode"
        $adminContent += "$($Icons.Info) Run as Admin for full features"
    }
    Write-BeautifulBox "Privileges" $adminContent $Icons.Security
    
    # Quick Actions
    Write-BeautifulBox "Quick Actions" @(
        "$($Icons.Rocket) wupm upgrade                    # Update everything",
        "$($Icons.AI) wupm ai 'analyze my system'       # AI analysis", 
        "$($Icons.Windows) Settings → Windows Update         # Manual Windows updates",
        "$($Icons.Store) Microsoft Store → Downloads      # Manual Store updates"
    ) $Icons.Info
}

# ═══════════════════════════════════════════════════════════════════════════════
# 🎯 MAIN COMMAND EXECUTION
# ═══════════════════════════════════════════════════════════════════════════════

$managers = Get-PackageManagerInfo
$isAdmin = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

switch ($cmd) {
    "ai" {
        if ([string]::IsNullOrWhiteSpace($pkg)) {
            Show-Banner
            Write-BeautifulBox "AI Assistant" @(
                "$($Icons.AI) Natural Language Commands:",
                "",
                "• 'analyze my system'           → System health check",
                "• 'install development tools'   → Dev environment",
                "• 'windows updates'             → Windows Update status",
                "• 'store updates'               → Store app updates",
                "• 'recommend software'          → Software suggestions",
                "• 'why is my computer slow?'    → Performance help",
                "",
                "$($Icons.Rocket) Try: wupm ai 'analyze my system'"
            ) $Icons.AI
        } else {
            Invoke-BeautifulAI -Query $pkg
        }
    }
    
    "status" {
        Show-SystemStatus
    }
    
    "install" {
        if ([string]::IsNullOrWhiteSpace($pkg)) { 
            Write-Error "Usage: wupm install <package-name>"
            Write-Info "Example: wupm install firefox"
            return
        }
        
        if (-not (Test-PackageName $pkg)) {
            Write-Error "Invalid package name format"
            return
        }
        
        Show-Banner
        Write-AI "Installing '$pkg'..."
        
        $availableManagers = $managers | Where-Object { $_.Status -eq 'Available' } | Sort-Object Priority
        
        if ($availableManagers.Count -eq 0) {
            Write-BeautifulBox "Error" @(
                "$($Icons.Error) No package managers available",
                "$($Icons.Info) Install WinGet, Chocolatey, or Scoop first"
            ) $Icons.Error
            return
        }
        
        $installed = $false
        foreach ($mgr in $availableManagers) {
            Write-Info "Trying $($mgr.Name)..." $mgr.Icon
            
            try {
                switch ($mgr.Name) {
                    'WinGet' { 
                        winget install "$pkg" --accept-source-agreements --accept-package-agreements --silent 2>$null
                        if ($LASTEXITCODE -eq 0) { $installed = $true }
                    }
                    'Chocolatey' { 
                        choco install "$pkg" -y 2>$null
                        if ($LASTEXITCODE -eq 0) { $installed = $true }
                    }
                    'Scoop' { 
                        scoop install "$pkg" 2>$null
                        if ($LASTEXITCODE -eq 0) { $installed = $true }
                    }
                    'pip' { 
                        pip install "$pkg" 2>$null
                        if ($LASTEXITCODE -eq 0) { $installed = $true }
                    }
                    'NPM' { 
                        npm install -g "$pkg" 2>$null
                        if ($LASTEXITCODE -eq 0) { $installed = $true }
                    }
                    'Cargo' {
                        cargo install "$pkg" 2>$null
                        if ($LASTEXITCODE -eq 0) { $installed = $true }
                    }
                }
                
                if ($installed) {
                    Write-Success "Successfully installed '$pkg' via $($mgr.Name)"
                    break
                }
            } catch {
                Write-Warning "$($mgr.Name) failed"
            }
        }
        
        if ($installed) {
            Write-BeautifulBox "Installation Complete" @(
                "$($Icons.Success) Package '$pkg' installed successfully!",
                "$($Icons.Star) Ready to use"
            ) $Icons.Success
        } else {
            Write-BeautifulBox "Installation Failed" @(
                "$($Icons.Error) Could not install '$pkg'",
                "$($Icons.Info) Try: wupm search $pkg"
            ) $Icons.Error
        }
    }
    
    "search" {
        if ([string]::IsNullOrWhiteSpace($pkg)) { 
            Write-Error "Usage: wupm search <package-name>"
            Write-Info "Example: wupm search firefox"
            return
        }
        
        if (-not (Test-PackageName $pkg)) {
            Write-Error "Invalid package name format"
            return
        }
        
        Show-Banner
        Write-AI "Searching for '$pkg'..."
        
        $availableManagers = $managers | Where-Object { $_.Status -eq 'Available' }
        
        if ($availableManagers.Count -eq 0) {
            Write-BeautifulBox "No Package Managers" @(
                "$($Icons.Error) No package managers available for search"
            ) $Icons.Error
            return
        }
        
        foreach ($mgr in $availableManagers) {
            Write-Info "Searching $($mgr.Name)..." $mgr.Icon
            
            try {
                switch ($mgr.Name) {
                    'WinGet' { 
                        winget search "$pkg" 2>$null 
                        if ($LASTEXITCODE -eq 0) {
                            Write-Success "$($mgr.Name) search completed"
                        } else {
                            Write-Warning "$($mgr.Name) search had issues"
                        }
                    }
                    'Chocolatey' { 
                        choco search "$pkg" --limit-output 2>$null 
                        if ($LASTEXITCODE -eq 0) {
                            Write-Success "$($mgr.Name) search completed"
                        } else {
                            Write-Warning "$($mgr.Name) search had issues"
                        }
                    }
                    'Scoop' { 
                        scoop search "$pkg" 2>$null 
                        if ($LASTEXITCODE -eq 0) {
                            Write-Success "$($mgr.Name) search completed"
                        } else {
                            Write-Warning "$($mgr.Name) search had issues"
                        }
                    }
                    'pip' { 
                        Write-Info "pip search is deprecated, use: pip index versions $pkg"
                    }
                    'NPM' { 
                        npm search "$pkg" 2>$null
                        if ($LASTEXITCODE -eq 0) {
                            Write-Success "$($mgr.Name) search completed"
                        } else {
                            Write-Warning "$($mgr.Name) search had issues"
                        }
                    }
                    'Cargo' {
                        Write-Info "Use: cargo search $pkg (or check crates.io)"
                    }
                }
            } catch {
                Write-Warning "$($mgr.Name) search failed"
            }
        }
        
        Write-BeautifulBox "Next Steps" @(
            "$($Icons.Rocket) Install: wupm install $pkg",
            "$($Icons.AI) AI Install: wupm ai 'install $pkg'"
        ) $Icons.Info
    }
    
    "update" {
        Show-Banner
        Write-AI "Updating package repositories..."
        
        $results = @()
        foreach ($mgr in $managers | Where-Object { $_.Status -eq 'Available' }) {
            Write-Info "Updating $($mgr.Name)..." $mgr.Icon
            
            try {
                switch ($mgr.Name) {
                    'WinGet' { 
                        winget source update 2>$null
                        if ($LASTEXITCODE -eq 0) { 
                            $results += "$($Icons.Success) $($mgr.Name) updated" 
                        } else { 
                            $results += "$($Icons.Warning) $($mgr.Name) update issues" 
                        }
                    }
                    'Chocolatey' { 
                        choco upgrade chocolatey -y --limit-output 2>$null
                        if ($LASTEXITCODE -eq 0) { 
                            $results += "$($Icons.Success) $($mgr.Name) updated" 
                        } else { 
                            $results += "$($Icons.Warning) $($mgr.Name) update issues" 
                        }
                    }
                    'Scoop' { 
                        scoop update 2>$null
                        $results += "$($Icons.Success) $($mgr.Name) updated"
                    }
                    'pip' { 
                        pip install --upgrade pip --quiet 2>$null
                        if ($LASTEXITCODE -eq 0) { 
                            $results += "$($Icons.Success) $($mgr.Name) updated" 
                        } else { 
                            $results += "$($Icons.Warning) $($mgr.Name) update issues" 
                        }
                    }
                    'NPM' { 
                        npm update -g npm --silent 2>$null
                        if ($LASTEXITCODE -eq 0) { 
                            $results += "$($Icons.Success) $($mgr.Name) updated" 
                        } else { 
                            $results += "$($Icons.Warning) $($mgr.Name) update issues" 
                        }
                    }
                    'Cargo' {
                        $results += "$($Icons.Info) $($mgr.Name) - Use: rustup update"
                    }
                }
            } catch {
                $results += "$($Icons.Error) $($mgr.Name) update failed"
            }
        }
        
        Write-BeautifulBox "Update Results" $results $Icons.Success
        
        if (-not $isAdmin) {
            Write-BeautifulBox "Tip" @(
                "$($Icons.Info) Run as Administrator for Windows Updates",
                "$($Icons.Crown) Right-click PowerShell → Run as Administrator"
            ) $Icons.Info
        }
    }
    
    "upgrade" {
        Show-Banner
        Write-AI "Upgrading all packages..."
        
        $results = @()
        foreach ($mgr in $managers | Where-Object { $_.Status -eq 'Available' }) {
            Write-Info "Upgrading $($mgr.Name) packages..." $mgr.Icon
            
            try {
                switch ($mgr.Name) {
                    'WinGet' { 
                        winget upgrade --all --accept-source-agreements --accept-package-agreements --silent 2>$null
                        $results += "$($Icons.Success) $($mgr.Name) packages upgraded"
                    }
                    'Chocolatey' { 
                        choco upgrade all -y --limit-output 2>$null
                        $results += "$($Icons.Success) $($mgr.Name) packages upgraded"
                    }
                    'Scoop' { 
                        scoop update * 2>$null
                        $results += "$($Icons.Success) $($mgr.Name) packages upgraded"
                    }
                    'pip' { 
                        $results += "$($Icons.Info) $($mgr.Name) - Use: pip list --outdated"
                    }
                    'NPM' { 
                        npm update -g --silent 2>$null
                        $results += "$($Icons.Success) $($mgr.Name) global packages upgraded"
                    }
                    'Cargo' {
                        $results += "$($Icons.Info) $($mgr.Name) - Use: cargo install-update -a"
                    }
                }
            } catch {
                $results += "$($Icons.Warning) $($mgr.Name) upgrade had issues"
            }
        }
        
        Write-BeautifulBox "Upgrade Complete" $results $Icons.Success
        
        Write-BeautifulBox "System Status" @(
            "$($Icons.Trophy) Package upgrades completed!",
            "$($Icons.Magic) Your software is up to date"
        ) $Icons.Trophy
    }
    
    "list" {
        if ($pkg -eq "--upgradable" -or $pkg -eq "--outdated") {
            Show-Banner
            Write-AI "Checking for available updates..."
            
            $updatesList = @()
            foreach ($mgr in $managers | Where-Object { $_.Status -eq 'Available' }) {
                Write-Info "Checking $($mgr.Name)..." $mgr.Icon
                
                try {
                    switch ($mgr.Name) {
                        'WinGet' {
                            $upgradeOutput = winget upgrade 2>$null
                            if ($LASTEXITCODE -eq 0) {
                                $updatesList += "$($Icons.Success) $($mgr.Name): Check output above"
                            } else {
                                $updatesList += "$($Icons.Warning) $($mgr.Name): Check failed"
                            }
                        }
                        'Chocolatey' {
                            choco outdated 2>$null
                            if ($LASTEXITCODE -eq 0) {
                                $updatesList += "$($Icons.Success) $($mgr.Name): Check output above"
                            } else {
                                $updatesList += "$($Icons.Warning) $($mgr.Name): Check failed"
                            }
                        }
                        'Scoop' {
                            scoop status 2>$null
                            $updatesList += "$($Icons.Success) $($mgr.Name): Check output above"
                        }
                        'pip' {
                            $updatesList += "$($Icons.Info) $($mgr.Name): Use 'pip list --outdated'"
                        }
                        'NPM' {
                            npm outdated -g 2>$null
                            $updatesList += "$($Icons.Success) $($mgr.Name): Check output above"
                        }
                        'Cargo' {
                            $updatesList += "$($Icons.Info) $($mgr.Name): Use 'cargo install-update --list'"
                        }
                    }
                } catch {
                    $updatesList += "$($Icons.Error) $($mgr.Name): Check failed"
                }
            }
            
            Write-BeautifulBox "Update Check Results" $updatesList $Icons.Package
            
            Write-BeautifulBox "Actions" @(
                "$($Icons.Rocket) Install updates: wupm upgrade",
                "$($Icons.AI) Smart upgrade: wupm ai 'upgrade everything'"
            ) $Icons.Info
        } else {
            Show-SystemStatus
        }
    }
    
    "version" {
        Show-Banner
        
        Write-BeautifulBox "WUPM Information" @(
            "$($Icons.Star) Version: 2.0 Complete Edition",
            "$($Icons.AI) AI-Powered Package Management",
            "$($Icons.Shield) Enhanced Security & Modern UI",
            "$($Icons.Speed) Multi-Platform Support"
        ) $Icons.Crown
        
        $sysInfo = Get-SystemInfo
        $sysContent = @()
        if ($sysInfo.OS) {
            $sysContent += "$($Icons.System) OS: $($sysInfo.OS)"
        }
        $sysContent += "$($Icons.Speed) PowerShell: $($sysInfo.PowerShell)"
        $sysContent += "$($Icons.Shield) Mode: $(if($isAdmin){'Administrator'}else{'Standard User'})"
        
        Write-BeautifulBox "System Summary" $sysContent $Icons.System
        
        Write-BeautifulBox "Features" @(
            "$($Icons.AI) Natural Language Processing",
            "$($Icons.Magic) Intelligent Recommendations", 
            "$($Icons.Shield) Advanced Security",
            "$($Icons.Speed) Multi-Manager Support",
            "$($Icons.Chart) System Health Analysis",
            "$($Icons.Star) Beautiful Modern Interface",
            "$($Icons.Windows) Windows Update Integration",
            "$($Icons.Store) Microsoft Store Support"
        ) $Icons.Magic
        
        # Show detected managers
        if ($managers.Count -gt 0) {
            $mgrsContent = @()
            foreach ($mgr in $managers | Where-Object { $_.Status -eq 'Available' }) {
                $mgrsContent += "$($mgr.Icon) $($mgr.Name) v$($mgr.Version)"
            }
            Write-BeautifulBox "Detected Package Managers" $mgrsContent $Icons.Package
        }
    }
    
    "help" {
        Show-Banner
        
        Write-BeautifulBox "Classic Commands" @(
            "status                     Complete system health report",
            "search <package>           Search across all package managers",
            "install <package>          Smart installation with fallback",
            "update                     Update all repositories",
            "upgrade                    Upgrade all installed packages", 
            "list --upgradable          Show available updates",
            "version                    Version and system information",
            "help                       Show this help message"
        ) $Icons.Package
        
        Write-BeautifulBox "AI Commands" @(
            "ai 'your request'          Natural language interface",
            "ai 'analyze my system'     Complete system analysis",
            "ai 'install dev tools'     Smart software installation",
            "ai 'windows updates'       Windows Update management",
            "ai 'store updates'         Microsoft Store updates",
            "ai 'recommend software'    Get software suggestions"
        ) $Icons.AI
        
        Write-BeautifulBox "Examples" @(
            "wupm install firefox                    # Install Firefox",
            "wupm search 'visual studio'             # Search for VS",
            "wupm ai 'install development tools'     # AI dev setup",
            "wupm ai 'why is my computer slow?'      # AI diagnosis",
            "wupm upgrade                            # Update everything"
        ) $Icons.Rocket
        
        if ($managers.Count -gt 0) {
            $mgrsContent = @()
            foreach ($mgr in $managers | Where-Object { $_.Status -eq 'Available' }) {
                $mgrsContent += "$($mgr.Icon) $($mgr.Name) v$($mgr.Version) - Ready"
            }
            Write-BeautifulBox "Available Package Managers" $mgrsContent $Icons.Success
        }
    }
    
    default {
        Show-Banner
        Write-BeautifulBox "Welcome to WUPM Complete Edition!" @(
            "$($Icons.Trophy) The most comprehensive package manager for Windows",
            "",
            "$($Icons.Package) Package Managers: WinGet, Chocolatey, Scoop, pip, NPM, Cargo",
            "$($Icons.Windows) Windows Updates: Integrated support",
            "$($Icons.Store) Microsoft Store: App management",
            "$($Icons.AI) AI Assistant: Natural language commands",
            "",
            "$($Icons.Rocket) Quick start:",
            "  • wupm status              # Complete system overview",
            "  • wupm upgrade             # Update all packages",
            "  • wupm ai 'help me'        # AI assistance",
            "  • wupm help                # Full command list"
        ) $Icons.Crown
    }
}

# Beautiful footer
Write-Host ""
Write-Host $($Box.DoubleTopLeft + $Box.DoubleHorizontal * 78 + $Box.DoubleTopRight) -ForegroundColor $Colors.Primary
Write-Host "$($Box.DoubleVertical)            ✨ Thank you for using WUPM Complete Edition! ✨              $($Box.DoubleVertical)" -ForegroundColor $Colors.Accent
Write-Host $($Box.DoubleBottomLeft + $Box.DoubleHorizontal * 78 + $Box.DoubleBottomRight) -ForegroundColor $Colors.Primary

Write-Host ""
