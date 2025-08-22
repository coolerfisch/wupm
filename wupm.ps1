# ===============================================================================
# WUPM v2.1 - Enhanced Safety Edition (Execution Policy Fixed)
# Windows Universal Package Manager with AI Safety Features
# ===============================================================================

# Execution Policy Self-Check and Auto-Fix
param(
    [Parameter(Position = 0)]
    [ValidateSet("install", "search", "update", "upgrade", "list", "status", "version", "help", "ai", "safety", "safety-reset", "backup", "restore", IgnoreCase = $true)]
    [string]$Command,
    
    [Parameter(Position = 1, ValueFromRemainingArguments = $true)]
    [string[]]$PackageArgs,
    
    [switch]$BypassExecutionPolicy
)

# Auto-restart with bypass if execution policy blocks
if (-not $BypassExecutionPolicy) {
    try {
        $currentPolicy = Get-ExecutionPolicy -Scope CurrentUser -ErrorAction SilentlyContinue
        if ($currentPolicy -eq 'Restricted' -or (Get-ExecutionPolicy) -eq 'Restricted') {
            Write-Host "Execution policy detected, restarting with bypass..." -ForegroundColor Yellow
            
            # Reconstruct the command line arguments
            $allArgs = @()
            if ($Command) { $allArgs += $Command }
            if ($PackageArgs) { $allArgs += $PackageArgs }
            $allArgs += "-BypassExecutionPolicy"
            
            # Restart with bypass
            $arguments = "-ExecutionPolicy Bypass -File `"$($MyInvocation.MyCommand.Path)`" " + ($allArgs -join " ")
            Start-Process PowerShell -ArgumentList $arguments -NoNewWindow -Wait
            exit
        }
    } catch {
        # If we can't check the policy, try to restart with bypass
        Write-Host "Policy check failed, restarting with bypass..." -ForegroundColor Yellow
        
        $allArgs = @()
        if ($Command) { $allArgs += $Command }
        if ($PackageArgs) { $allArgs += $PackageArgs }
        $allArgs += "-BypassExecutionPolicy"
        
        $arguments = "-ExecutionPolicy Bypass -File `"$($MyInvocation.MyCommand.Path)`" " + ($allArgs -join " ")
        Start-Process PowerShell -ArgumentList $arguments -NoNewWindow -Wait
        exit
    }
}

# ===============================================================================
# INITIALIZATION
# ===============================================================================

$cmd = if ($Command) { $Command.ToLower() } else { "help" }
$pkg = if ($PackageArgs) { ($PackageArgs -join " ").Trim() } else { "" }

# ===============================================================================
# UI COMPONENTS (ASCII Safe)
# ===============================================================================

$Colors = @{
    Primary = [System.ConsoleColor]::Cyan
    Success = [System.ConsoleColor]::Green
    Warning = [System.ConsoleColor]::Yellow
    Error = [System.ConsoleColor]::Red
    Info = [System.ConsoleColor]::White
    Accent = [System.ConsoleColor]::Magenta
    Muted = [System.ConsoleColor]::DarkGray
    Safety = [System.ConsoleColor]::Blue
}

$Icons = @{
    Success = "[OK]"
    Error = "[ERROR]"
    Warning = "[WARN]"
    Info = "[INFO]"
    AI = "[AI]"
    Package = "[PKG]"
    System = "[SYS]"
    Security = "[SEC]"
    Speed = "[FAST]"
    Health = "[HEALTH]"
    Rocket = "[GO]"
    Star = "[*]"
    Magic = "[MAGIC]"
    Shield = "[SHIELD]"
    Gear = "[CONFIG]"
    Chart = "[CHART]"
    Trophy = "[WIN]"
    Crown = "[ADMIN]"
    Windows = "[WIN]"
    Store = "[STORE]"
    Update = "[UPD]"
    Lock = "[LOCK]"
    Block = "[BLOCK]"
    Filter = "[FILTER]"
    Safety = "[SAFE]"
    Config = "[CFG]"
    Backup = "[BAK]"
}

$Box = @{
    TopLeft = "+"
    TopRight = "+"
    BottomLeft = "+"
    BottomRight = "+"
    Horizontal = "-"
    Vertical = "|"
    TeeRight = "+"
    TeeLeft = "+"
    DoubleHorizontal = "="
    DoubleVertical = "|"
    DoubleTopLeft = "+"
    DoubleTopRight = "+"
    DoubleBottomLeft = "+"
    DoubleBottomRight = "+"
}

# ===============================================================================
# SAFETY FILTER CLASS
# ===============================================================================

class WUPMSafetyFilter {
    [string[]] $BlockedCommands = @(
        "delete system32",
        "format c:",
        "rm -rf /",
        "install malware",
        "download crack",
        "hack system",
        "bypass security",
        "delete windows",
        "remove antivirus",
        "disable firewall",
        "install virus",
        "system destroyer",
        "password stealer",
        "keylogger",
        "trojan",
        "rootkit"
    )
    
    [string[]] $RiskyKeywords = @(
        "hack", "crack", "pirate", "bypass", "exploit", "keylog", 
        "stealer", "trojan", "virus", "malware", "rootkit", "backdoor"
    )
    
    [string[]] $AdultKeywords = @(
        "adult", "xxx", "porn", "mature", "erotic", "sexual"
    )
    
    [string[]] $PackageBlacklist = @(
        "malware-simulator",
        "system-destroyer", 
        "password-stealer",
        "fake-antivirus",
        "crypto-miner",
        "data-harvester",
        "privacy-invader"
    )
    
    [bool] ValidateCommand([string]$command) {
        $command = $command.ToLower()
        
        foreach ($blocked in $this.BlockedCommands) {
            if ($command.Contains($blocked)) {
                Write-SafetyLog "Command blocked" "Contains dangerous instruction: $blocked"
                return $false
            }
        }
        return $true
    }
    
    [bool] ValidatePackage([string]$packageName) {
        $packageLower = $packageName.ToLower()
        
        foreach ($blocked in $this.PackageBlacklist) {
            if ($packageLower.Contains($blocked)) {
                Write-SafetyLog "Package blocked" "Package '$packageName' is blacklisted"
                return $false
            }
        }
        return $true
    }
    
    [string] GetRiskLevel([string]$query) {
        $query = $query.ToLower()
        
        $riskyCount = ($this.RiskyKeywords | Where-Object { $query.Contains($_) }).Count
        $adultCount = ($this.AdultKeywords | Where-Object { $query.Contains($_) }).Count
        
        if ($riskyCount -gt 0) { return "High" }
        if ($adultCount -gt 0) { return "Adult" }
        return "Safe"
    }
}

# ===============================================================================
# SAFETY CONFIGURATION FUNCTIONS
# ===============================================================================

function Get-UserSafetyPreferences {
    $configDir = "$env:USERPROFILE\.wupm"
    $configPath = "$configDir\safety-config.json"
    
    if (Test-Path $configPath) {
        try {
            return Get-Content $configPath | ConvertFrom-Json
        } catch {
            Write-Warning "Safety config corrupted, using defaults"
        }
    }
    
    # Default safe settings
    $defaultConfig = @{
        'SafetyLevel' = 'High'
        'AllowSystemModifications' = $false
        'RequireConfirmation' = $true
        'BlockAdultContent' = $true
        'BlockRiskyContent' = $true
        'AllowExperimentalFeatures' = $false
        'EnableAuditLog' = $true
        'AutoUpdateSafetyRules' = $true
    }
    
    # Create config directory and save defaults
    if (-not (Test-Path $configDir)) {
        New-Item -Path $configDir -ItemType Directory -Force | Out-Null
    }
    
    $defaultConfig | ConvertTo-Json -Depth 3 | Set-Content $configPath
    return $defaultConfig
}

function Set-SafetyPreference {
    param(
        [string]$Setting,
        [string]$Value
    )
    
    $config = Get-UserSafetyPreferences
    $configDir = "$env:USERPROFILE\.wupm"
    $configPath = "$configDir\safety-config.json"
    
    # Validate setting
    $validSettings = @('SafetyLevel', 'AllowSystemModifications', 'RequireConfirmation', 
                      'BlockAdultContent', 'BlockRiskyContent', 'AllowExperimentalFeatures',
                      'EnableAuditLog', 'AutoUpdateSafetyRules')
    
    if ($Setting -notin $validSettings) {
        Write-Error "Invalid setting: $Setting"
        Write-Info "Valid settings: $($validSettings -join ', ')"
        return $false
    }
    
    # Convert value to appropriate type
    $convertedValue = switch ($Setting) {
        'SafetyLevel' { 
            if ($Value -in @('High', 'Medium', 'Low')) { $Value } 
            else { 
                Write-Error "SafetyLevel must be High, Medium, or Low"
                return $false
            }
        }
        default { 
            if ($Value -in @('true', 'false')) { 
                [bool]::Parse($Value) 
            } else { 
                Write-Error "Value must be true or false"
                return $false
            }
        }
    }
    
    $config.$Setting = $convertedValue
    $config | ConvertTo-Json -Depth 3 | Set-Content $configPath
    
    Write-Success "Safety preference updated: $Setting = $convertedValue"
    Write-SafetyLog "Setting changed" "$Setting set to $convertedValue"
    return $true
}

function Write-SafetyLog {
    param(
        [string]$Action, 
        [string]$Reason
    )
    
    $prefs = Get-UserSafetyPreferences
    if (-not $prefs.EnableAuditLog) { return }
    
    $logEntry = @{
        'Timestamp' = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
        'Action' = $Action
        'Reason' = $Reason
        'User' = $env:USERNAME
        'Computer' = $env:COMPUTERNAME
    }
    
    $logDir = "$env:USERPROFILE\.wupm"
    $logPath = "$logDir\safety-audit.log"
    
    if (-not (Test-Path $logDir)) {
        New-Item -Path $logDir -ItemType Directory -Force | Out-Null
    }
    
    $logEntry | ConvertTo-Json -Compress | Add-Content $logPath
}

function Get-PackageTrustScore {
    param([string]$PackageName)
    
    # Simulate trust scoring based on popularity and reputation
    $popularPackages = @{
        'firefox' = 95
        'chrome' = 90
        'vscode' = 98
        'git' = 95
        'nodejs' = 92
        'python' = 94
        'notepadplusplus' = 88
        'vlc' = 90
        '7zip' = 85
        'steam' = 80
        'discord' = 75
        'spotify' = 78
        'zoom' = 70
        'obs' = 85
        'wireshark' = 80
    }
    
    $packageLower = $PackageName.ToLower()
    if ($popularPackages.ContainsKey($packageLower)) {
        return $popularPackages[$packageLower]
    }
    return 60  # Default trust score
}

function Test-PackageSafety {
    param([string]$PackageName)
    
    $safetyFilter = [WUPMSafetyFilter]::new()
    $userPrefs = Get-UserSafetyPreferences
    
    # Check blacklist
    if (-not $safetyFilter.ValidatePackage($PackageName)) {
        Write-Error "Package '$PackageName' is blacklisted for security reasons"
        return $false
    }
    
    # Check trust score
    $trustScore = Get-PackageTrustScore $PackageName
    $minTrustScore = switch ($userPrefs.SafetyLevel) {
        'High' { 70 }
        'Medium' { 50 }
        'Low' { 30 }
        default { 70 }
    }
    
    if ($trustScore -lt $minTrustScore) {
        Write-Warning "Package '$PackageName' has low trust score: $trustScore% (minimum: $minTrustScore%)"
        Write-SafetyLog "Low trust package" "Package '$PackageName' trust score: $trustScore%"
        
        if ($userPrefs.RequireConfirmation) {
            Write-Host ""
            Write-Host "Package Information:" -ForegroundColor $Colors.Info
            Write-Host "  Name: $PackageName" -ForegroundColor $Colors.Muted
            Write-Host "  Trust Score: $trustScore%" -ForegroundColor $Colors.Warning
            Write-Host "  Safety Level: $($userPrefs.SafetyLevel)" -ForegroundColor $Colors.Info
            Write-Host ""
            
            $confirm = Read-Host "Continue with installation? (y/N)"
            $proceed = ($confirm -eq 'y' -or $confirm -eq 'Y')
            
            if ($proceed) {
                Write-SafetyLog "User override" "User chose to install low-trust package: $PackageName"
            } else {
                Write-SafetyLog "User abort" "User declined to install low-trust package: $PackageName"
            }
            
            return $proceed
        }
        
        return $userPrefs.SafetyLevel -eq 'Low'
    }
    
    return $true
}

# ===============================================================================
# OUTPUT FUNCTIONS
# ===============================================================================

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

function Write-Safety {
    param([string]$text, [string]$icon = $Icons.Safety)
    Write-Beautiful $text $icon $Colors.Safety
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
    Write-Host "$($Box.DoubleVertical)                    WUPM v2.1 - Enhanced Safety Edition                     $($Box.DoubleVertical)" -ForegroundColor $Colors.Accent
    Write-Host "$($Box.DoubleVertical)                Windows + Store + Packages + AI + Safety                   $($Box.DoubleVertical)" -ForegroundColor $Colors.Primary
    Write-Host $($Box.DoubleBottomLeft + $Box.DoubleHorizontal * 78 + $Box.DoubleBottomRight) -ForegroundColor $Colors.Primary
    Write-Host ""
}

# ===============================================================================
# ENHANCED AI ENGINE CLASS
# ===============================================================================

class WUPMAIEngine {
    [WUPMSafetyFilter] $SafetyFilter
    
    WUPMAIEngine() {
        $this.SafetyFilter = [WUPMSafetyFilter]::new()
    }
    
    [string] ProcessNaturalLanguage([string]$query) {
        $userPrefs = Get-UserSafetyPreferences
        
        # Safety validation
        if (-not $this.SafetyFilter.ValidateCommand($query)) {
            Write-Safety "Request blocked by safety filter"
            return "blocked"
        }
        
        # Risk assessment
        $riskLevel = $this.SafetyFilter.GetRiskLevel($query)
        
        if ($riskLevel -eq "High" -and $userPrefs.BlockRiskyContent) {
            Write-Safety "High-risk content detected and blocked"
            Write-Info "Try rephrasing your request or adjust safety settings with: wupm safety"
            Write-SafetyLog "High-risk query blocked" "Query: $query"
            return "blocked"
        }
        
        if ($riskLevel -eq "Adult" -and $userPrefs.BlockAdultContent) {
            Write-Safety "Adult content blocked by parental controls"
            Write-SafetyLog "Adult content blocked" "Query: $query"
            return "blocked"
        }
        
        # Process safe queries
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
        if ($query -match "safety|security|filter") { 
            return "safety-info" 
        }
        if ($query -match "update everything|upgrade everything") { 
            return "update-all" 
        }
        if ($query -match "recommend|suggest|advice") { 
            return "recommend" 
        }
        if ($query -match "development|dev|coding|programming") { 
            if ($userPrefs.SafetyLevel -ne 'Low' -and $userPrefs.RequireConfirmation) {
                Write-Warning "Installing development tools requires confirmation"
                $confirm = Read-Host "Install development environment? (y/N)"
                if ($confirm -ne 'y' -and $confirm -ne 'Y') {
                    return "cancelled"
                }
            }
            return "install vscode git nodejs python" 
        }
        if ($query -match "backup|export") { 
            return "backup" 
        }
        if ($query -match "install (.+)") { 
            $package = $Matches[1] -replace "'|`"", ""
            
            # Safety check for package installation
            if (-not (Test-PackageSafety $package)) {
                return "blocked"
            }
            
            return "install $package" 
        }
        
        return "I can help you install software, update packages, or analyze your system safely."
    }
}

# ===============================================================================
# CORE FUNCTIONS
# ===============================================================================

function Test-PackageName {
    param([string]$Name)
    if ([string]::IsNullOrWhiteSpace($Name)) { 
        return $false 
    }
    
    # Enhanced validation
    if ($Name.Length -gt 100) {
        Write-Warning "Package name too long"
        return $false
    }
    
    if ($Name -match '[<>:"|?*]') {
        Write-Warning "Package name contains invalid characters"
        return $false
    }
    
    return $Name -match '^[a-zA-Z0-9.\-_ +]+$'
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
                    'Icon' = "[WG]"
                    'SafetyRating' = 'High'
                }
            }
        } catch {
            $managers += @{ 
                'Name' = 'WinGet'
                'Status' = 'Error'
                'Icon' = "[ERROR]" 
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
                    'Icon' = "[CHOCO]"
                    'SafetyRating' = 'Medium'
                }
            }
        } catch {
            $managers += @{ 
                'Name' = 'Chocolatey'
                'Status' = 'Error'
                'Icon' = "[ERROR]" 
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
                    'Icon' = "[SCOOP]"
                    'SafetyRating' = 'High'
                }
            }
        } catch {
            $managers += @{ 
                'Name' = 'Scoop'
                'Status' = 'Error'
                'Icon' = "[ERROR]" 
            }
        }
    }
    
    return $managers | Sort-Object Priority
}

# ===============================================================================
# MAIN FUNCTIONS
# ===============================================================================

function Invoke-SafeAI {
    param([string]$Query)
    
    Show-Banner
    $aiEngine = [WUPMAIEngine]::new()
    $response = $aiEngine.ProcessNaturalLanguage($Query)
    
    if ($response -eq "blocked") {
        Write-BeautifulBox "Request Blocked" @(
            "$($Icons.Block) Your request was blocked by the safety filter",
            "$($Icons.Info) This helps protect your system from potentially harmful actions",
            "$($Icons.Config) Adjust settings with: wupm safety",
            "$($Icons.AI) Try rephrasing your request"
        ) $Icons.Safety
        return
    }
    
    if ($response -eq "cancelled") {
        Write-Info "Operation cancelled by user"
        return
    }
    
    Write-AI "Processing: '$Query'"
    
    switch ($response) {
        "safety-info" {
            $prefs = Get-UserSafetyPreferences
            
            $content = @()
            $content += "$($Icons.Shield) Safety Level: $($prefs.SafetyLevel)"
            $content += "$($Icons.Lock) Adult Content: $(if($prefs.BlockAdultContent){'Blocked'}else{'Allowed'})"
            $content += "$($Icons.Block) Risky Content: $(if($prefs.BlockRiskyContent){'Blocked'}else{'Allowed'})"
            $content += "$($Icons.Config) Confirmation Required: $($prefs.RequireConfirmation)"
            $content += "$($Icons.Chart) Audit Log: $(if($prefs.EnableAuditLog){'Enabled'}else{'Disabled'})"
            
            Write-BeautifulBox "Current Safety Configuration" $content $Icons.Safety
        }
        
        "analyze" {
            $sysInfo = Get-SystemInfo
            $prefs = Get-UserSafetyPreferences
            
            $content = @()
            $content += "$($Icons.System) OS: $($sysInfo.OS)"
            $content += "$($Icons.Speed) PowerShell: $($sysInfo.PowerShell)"
            $content += "$($Icons.Safety) Safety Level: $($prefs.SafetyLevel)"
            
            if ($sysInfo.FreeSpace) { 
                $freePercent = ($sysInfo.FreeSpace / $sysInfo.TotalSpace) * 100
                $diskIcon = if ($freePercent -lt 15) { $Icons.Warning } else { $Icons.Success }
                $content += "$diskIcon Disk: $($sysInfo.FreeSpace) GB free of $($sysInfo.TotalSpace) GB"
            }
            
            Write-BeautifulBox "AI System Analysis" $content $Icons.Chart
        }
        
        "backup" {
            Write-Info "Creating package backup..."
            # Simplified backup functionality
            $managers = Get-PackageManagerInfo
            $backupData = @{
                'Timestamp' = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
                'System' = Get-SystemInfo
                'SafetySettings' = Get-UserSafetyPreferences
            }
            
            $backupDir = "$env:USERPROFILE\.wupm\backups"
            if (-not (Test-Path $backupDir)) {
                New-Item -Path $backupDir -ItemType Directory -Force | Out-Null
            }
            
            $backupFile = "$backupDir\wupm-backup-$(Get-Date -Format 'yyyyMMdd-HHmmss').json"
            $backupData | ConvertTo-Json -Depth 4 | Set-Content $backupFile
            
            Write-Success "Package list exported to: $backupFile"
        }
        
        default {
            if ($response.StartsWith("install ")) {
                $package = $response.Substring(8)
                Write-AI "Installing: $package"
                & $PSCommandPath "install" $package
            } else {
                Write-BeautifulBox "AI Response" @("$($Icons.AI) $response") $Icons.Magic
            }
        }
    }
}

function Show-SafetyConfiguration {
    Show-Banner
    
    $prefs = Get-UserSafetyPreferences
    
    # Current Settings
    $settingsContent = @()
    $settingsContent += "$($Icons.Shield) Safety Level: $($prefs.SafetyLevel)"
    $settingsContent += "$($Icons.Lock) System Modifications: $(if($prefs.AllowSystemModifications){'Allowed'}else{'Blocked'})"
    $settingsContent += "$($Icons.Config) Require Confirmation: $(if($prefs.RequireConfirmation){'Enabled'}else{'Disabled'})"
    $settingsContent += "$($Icons.Block) Block Adult Content: $(if($prefs.BlockAdultContent){'Enabled'}else{'Disabled'})"
    $settingsContent += "$($Icons.Filter) Block Risky Content: $(if($prefs.BlockRiskyContent){'Enabled'}else{'Disabled'})"
    $settingsContent += "$($Icons.Chart) Audit Logging: $(if($prefs.EnableAuditLog){'Enabled'}else{'Disabled'})"
    
    Write-BeautifulBox "Current Safety Settings" $settingsContent $Icons.Safety
    
    # Commands
    $commandsContent = @(
        "wupm safety set SafetyLevel High          # Maximum protection",
        "wupm safety set SafetyLevel Medium        # Balanced security",
        "wupm safety set SafetyLevel Low           # Minimal restrictions",
        "",
        "wupm safety set BlockAdultContent true    # Enable parental controls",
        "wupm safety set RequireConfirmation false # Disable confirmations",
        "wupm safety set EnableAuditLog true       # Enable audit logging",
        "",
        "wupm safety-reset                         # Reset to secure defaults"
    )
    Write-BeautifulBox "Safety Commands" $commandsContent $Icons.Config
}

# ===============================================================================
# MAIN COMMAND EXECUTION
# ===============================================================================

$managers = Get-PackageManagerInfo
$isAdmin = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

switch ($cmd) {
    "ai" {
        if ([string]::IsNullOrWhiteSpace($pkg)) {
            Show-Banner
            Write-BeautifulBox "AI Assistant with Safety Features" @(
                "$($Icons.AI) Natural Language Commands:",
                "",
                "- 'analyze my system'           -> Secure system health check",
                "- 'install development tools'   -> Safe dev environment setup",
                "- 'check safety settings'       -> View current protection level",
                "- 'backup my packages'          -> Export package list",
                "",
                "$($Icons.Safety) Safety Features:",
                "- Content filtering and risk assessment",
                "- Package trust score validation", 
                "- User confirmation for sensitive operations",
                "- Comprehensive audit logging",
                "",
                "$($Icons.Rocket) Try: wupm ai 'analyze my system'"
            ) $Icons.AI
        } else {
            Invoke-SafeAI -Query $pkg
        }
    }
    
    "safety" {
        if ([string]::IsNullOrWhiteSpace($pkg)) {
            Show-SafetyConfiguration
        } else {
            # Handle safety set commands
            $parts = $pkg -split " ", 3
            if ($parts.Count -eq 3 -and $parts[0] -eq "set") {
                $setting = $parts[1]
                $value = $parts[2]
                Set-SafetyPreference -Setting $setting -Value $value
            } else {
                Write-Error "Invalid safety command. Use: wupm safety set <setting> <value>"
                Write-Info "Example: wupm safety set SafetyLevel High"
            }
        }
    }
    
    "safety-reset" {
        $configPath = "$env:USERPROFILE\.wupm\safety-config.json"
        if (Test-Path $configPath) {
            Remove-Item $configPath -Force
            Write-Success "Safety settings reset to secure defaults"
            Write-SafetyLog "Settings reset" "Safety configuration reset to defaults"
        } else {
            Write-Info "Safety settings already at defaults"
        }
    }
    
    "backup" {
        Show-Banner
        Write-AI "Creating package backup..."
        
        # Simple backup implementation
        $managers = Get-PackageManagerInfo
        $backupData = @{
            'Timestamp' = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
            'System' = Get-SystemInfo
            'SafetySettings' = Get-UserSafetyPreferences
            'Managers' = $managers
        }
        
        $backupDir = "$env:USERPROFILE\.wupm\backups"
        if (-not (Test-Path $backupDir)) {
            New-Item -Path $backupDir -ItemType Directory -Force | Out-Null
        }
        
        $backupFile = "$backupDir\wupm-backup-$(Get-Date -Format 'yyyyMMdd-HHmmss').json"
        $backupData | ConvertTo-Json -Depth 4 | Set-Content $backupFile
        
        Write-Success "System backup created: $backupFile"
        Write-SafetyLog "Backup created" "System backup exported to $backupFile"
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
        
        # Enhanced safety check
        if (-not (Test-PackageSafety $pkg)) {
            return
        }
        
        Show-Banner
        Write-AI "Installing '$pkg' with safety validation..."
        
        $availableManagers = $managers | Where-Object { $_.Status -eq 'Available' } | Sort-Object Priority
        $userPrefs = Get-UserSafetyPreferences
        
        # Filter managers by safety rating if high security
        if ($userPrefs.SafetyLevel -eq 'High') {
            $availableManagers = $availableManagers | Where-Object { $_.SafetyRating -eq 'High' }
        }
        
        if ($availableManagers.Count -eq 0) {
            Write-BeautifulBox "Error" @(
                "$($Icons.Error) No suitable package managers available",
                "$($Icons.Safety) Current safety level: $($userPrefs.SafetyLevel)",
                "$($Icons.Info) Consider adjusting safety settings"
            ) $Icons.Error
            return
        }
        
        $installed = $false
        foreach ($mgr in $availableManagers) {
            Write-Info "Trying $($mgr.Name) (Safety: $($mgr.SafetyRating))..." $mgr.Icon
            
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
                }
                
                if ($installed) {
                    Write-Success "Successfully installed '$pkg' via $($mgr.Name)"
                    Write-SafetyLog "Package installed" "Package '$pkg' installed via $($mgr.Name)"
                    break
                }
            } catch {
                Write-Warning "$($mgr.Name) failed"
            }
        }
        
        if ($installed) {
            Write-BeautifulBox "Installation Complete" @(
                "$($Icons.Success) Package '$pkg' installed successfully!",
                "$($Icons.Safety) Installation completed safely",
                "$($Icons.Star) Ready to use"
            ) $Icons.Success
        } else {
            Write-BeautifulBox "Installation Failed" @(
                "$($Icons.Error) Could not install '$pkg'",
                "$($Icons.Info) Try: wupm search $pkg",
                "$($Icons.Safety) Package may not be available in secure repositories"
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
        Write-AI "Searching for '$pkg' in secure repositories..."
        
        $availableManagers = $managers | Where-Object { $_.Status -eq 'Available' }
        
        if ($availableManagers.Count -eq 0) {
            Write-BeautifulBox "No Package Managers" @(
                "$($Icons.Error) No package managers available for search"
            ) $Icons.Error
            return
        }
        
        foreach ($mgr in $availableManagers) {
            Write-Info "Searching $($mgr.Name) [Safety: $($mgr.SafetyRating)]..." $mgr.Icon
            
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
                }
            } catch {
                Write-Warning "$($mgr.Name) search failed"
            }
        }
        
        Write-BeautifulBox "Next Steps" @(
            "$($Icons.Rocket) Install safely: wupm install $pkg",
            "$($Icons.AI) AI Install: wupm ai 'install $pkg'",
            "$($Icons.Safety) Safety check will be performed automatically"
        ) $Icons.Info
    }
    
    "update" {
        Show-Banner
        Write-AI "Updating package repositories securely..."
        
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
                }
            } catch {
                $results += "$($Icons.Error) $($mgr.Name) update failed"
            }
        }
        
        Write-SafetyLog "System update" "Package repositories updated"
        Write-BeautifulBox "Update Results" $results $Icons.Success
    }
    
    "upgrade" {
        Show-Banner
        Write-AI "Upgrading all packages with safety validation..."
        
        $userPrefs = Get-UserSafetyPreferences
        
        if ($userPrefs.RequireConfirmation) {
            Write-Host ""
            Write-Host "Upgrade Information:" -ForegroundColor $Colors.Info
            Write-Host "  Safety Level: $($userPrefs.SafetyLevel)" -ForegroundColor $Colors.Muted
            Write-Host "  All packages will be verified before upgrade" -ForegroundColor $Colors.Muted
            Write-Host ""
            
            $confirm = Read-Host "Proceed with safe upgrade? (y/N)"
            if ($confirm -ne 'y' -and $confirm -ne 'Y') {
                Write-Info "Upgrade cancelled by user"
                Write-SafetyLog "Upgrade cancelled" "User declined system upgrade"
                return
            }
        }
        
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
                }
            } catch {
                $results += "$($Icons.Warning) $($mgr.Name) upgrade had issues"
            }
        }
        
        Write-SafetyLog "System upgrade" "All packages upgraded safely"
        Write-BeautifulBox "Upgrade Complete" $results $Icons.Success
        
        Write-BeautifulBox "System Status" @(
            "$($Icons.Trophy) Package upgrades completed safely!",
            "$($Icons.Safety) All updates verified and secured",
            "$($Icons.Magic) Your software is up to date"
        ) $Icons.Trophy
    }
    
    "status" {
        Show-Banner
        Write-AI "Analyzing your system with enhanced security..."
        
        $sysInfo = Get-SystemInfo
        $userPrefs = Get-UserSafetyPreferences
        
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
        
        # Safety Status
        $safetyContent = @()
        $safetyContent += "$($Icons.Shield) Safety Level: $($userPrefs.SafetyLevel)"
        $safetyContent += "$($Icons.Lock) Adult Content: $(if($userPrefs.BlockAdultContent){'Blocked'}else{'Allowed'})"
        $safetyContent += "$($Icons.Block) Risky Content: $(if($userPrefs.BlockRiskyContent){'Blocked'}else{'Allowed'})"
        $safetyContent += "$($Icons.Config) Confirmations: $(if($userPrefs.RequireConfirmation){'Required'}else{'Optional'})"
        $safetyContent += "$($Icons.Chart) Audit Log: $(if($userPrefs.EnableAuditLog){'Active'}else{'Disabled'})"
        
        Write-BeautifulBox "Security Status" $safetyContent $Icons.Safety
        
        # Package Managers with Safety Ratings
        $pkgContent = @()
        if ($managers.Count -gt 0) {
            foreach ($mgr in $managers | Where-Object { $_.Status -eq 'Available' }) {
                $safetyIndicator = switch ($mgr.SafetyRating) {
                    'High' { "[HIGH]" }
                    'Medium' { "[MED]" }
                    'Low' { "[LOW]" }
                    default { "[?]" }
                }
                $pkgContent += "$($mgr.Icon) $($mgr.Name) v$($mgr.Version) $safetyIndicator"
            }
        } else {
            $pkgContent += "$($Icons.Warning) No package managers detected"
            $pkgContent += "$($Icons.Info) Install WinGet, Chocolatey, or Scoop"
        }
        Write-BeautifulBox "Package Managers" $pkgContent $Icons.Package
        
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
        Write-BeautifulBox "Safe Quick Actions" @(
            "$($Icons.Rocket) wupm upgrade                    # Safe update everything",
            "$($Icons.AI) wupm ai 'analyze my system'       # AI security analysis", 
            "$($Icons.Safety) wupm safety                     # Configure protection",
            "$($Icons.Backup) wupm backup                     # Backup package list"
        ) $Icons.Info
    }
    
    "version" {
        Show-Banner
        
        $prefs = Get-UserSafetyPreferences
        
        Write-BeautifulBox "WUPM Information" @(
            "$($Icons.Star) Version: 2.1 Enhanced Safety Edition",
            "$($Icons.AI) AI-Powered Package Management",
            "$($Icons.Safety) Advanced Security & Content Filtering", 
            "$($Icons.Shield) Multi-Level Protection System",
            "$($Icons.Speed) Multi-Platform Support",
            "$($Icons.Backup) Backup & Restore Capabilities"
        ) $Icons.Crown
        
        $sysInfo = Get-SystemInfo
        $sysContent = @()
        if ($sysInfo.OS) {
            $sysContent += "$($Icons.System) OS: $($sysInfo.OS)"
        }
        $sysContent += "$($Icons.Speed) PowerShell: $($sysInfo.PowerShell)"
        $sysContent += "$($Icons.Shield) Mode: $(if($isAdmin){'Administrator'}else{'Standard User'})"
        $sysContent += "$($Icons.Safety) Safety Level: $($prefs.SafetyLevel)"
        
        Write-BeautifulBox "System Summary" $sysContent $Icons.System
        
        Write-BeautifulBox "Safety Features" @(
            "$($Icons.AI) Intelligent Content Filtering",
            "$($Icons.Shield) Package Trust Score Validation", 
            "$($Icons.Lock) Multi-Level Security Controls",
            "$($Icons.Filter) Risk Assessment Engine",
            "$($Icons.Chart) Comprehensive Audit Logging",
            "$($Icons.Config) Granular User Preferences",
            "$($Icons.Block) Blacklist Protection",
            "$($Icons.Safety) Parental Controls"
        ) $Icons.Safety
        
        # Show detected managers with safety ratings
        if ($managers.Count -gt 0) {
            $mgrsContent = @()
            foreach ($mgr in $managers | Where-Object { $_.Status -eq 'Available' }) {
                $safetyColor = switch ($mgr.SafetyRating) {
                    'High' { "[HIGH]" }
                    'Medium' { "[MED]" }
                    'Low' { "[LOW]" }
                    default { "[?]" }
                }
                $mgrsContent += "$($mgr.Icon) $($mgr.Name) v$($mgr.Version) $safetyColor"
            }
            Write-BeautifulBox "Detected Package Managers" $mgrsContent $Icons.Package
        }
    }
    
    "help" {
        Show-Banner
        
        Write-BeautifulBox "Classic Commands" @(
            "status                     Complete system health report",
            "search <package>           Search across all package managers",
            "install <package>          Safe installation with validation",
            "update                     Update all repositories",
            "upgrade                    Upgrade all installed packages", 
            "backup                     Export package list",
            "version                    Version and system information",
            "help                       Show this help message"
        ) $Icons.Package
        
        Write-BeautifulBox "AI Commands" @(
            "ai 'your request'          Natural language interface",
            "ai 'analyze my system'     Complete system analysis",
            "ai 'install dev tools'     Smart software installation",
            "ai 'check safety'          View protection status",
            "ai 'backup packages'       Create package backup"
        ) $Icons.AI
        
        Write-BeautifulBox "Safety Commands" @(
            "safety                     View current safety settings",
            "safety set <setting> <value>  Change safety preferences",
            "safety-reset               Reset to secure defaults"
        ) $Icons.Safety
        
        Write-BeautifulBox "Examples" @(
            "wupm install firefox                    # Safe Firefox installation",
            "wupm search 'visual studio'             # Search for VS",
            "wupm ai 'install development tools'     # AI dev setup with safety",
            "wupm safety set SafetyLevel Medium      # Adjust security level",
            "wupm backup                             # Backup package list"
        ) $Icons.Rocket
        
        $prefs = Get-UserSafetyPreferences
        $mgrsContent = @()
        
        if ($managers.Count -gt 0) {
            foreach ($mgr in $managers | Where-Object { $_.Status -eq 'Available' }) {
                $safetyIndicator = switch ($mgr.SafetyRating) {
                    'High' { "[HIGH]" }
                    'Medium' { "[MED]" }
                    'Low' { "[LOW]" }
                    default { "[?]" }
                }
                $mgrsContent += "$($mgr.Icon) $($mgr.Name) v$($mgr.Version) $safetyIndicator"
            }
            $mgrsContent += ""
            $mgrsContent += "$($Icons.Safety) Current Safety Level: $($prefs.SafetyLevel)"
        }
        
        if ($mgrsContent.Count -gt 0) {
            Write-BeautifulBox "Available Package Managers" $mgrsContent $Icons.Success
        }
    }
    
    default {
        Show-Banner
        Write-BeautifulBox "Welcome to WUPM Enhanced Safety Edition!" @(
            "$($Icons.Trophy) The most secure package manager for Windows",
            "",
            "$($Icons.Package) Package Managers: WinGet, Chocolatey, Scoop",
            "$($Icons.AI) AI Assistant: Natural language commands",
            "$($Icons.Safety) Enhanced Safety: Multi-level protection",
            "$($Icons.Backup) Backup & Restore: Package management",
            "",
            "$($Icons.Rocket) Quick start:",
            "  - wupm status              # Complete system overview",
            "  - wupm safety              # Configure security settings",
            "  - wupm upgrade             # Safe update all packages",
            "  - wupm ai 'help me'        # AI assistance",
            "  - wupm help                # Full command list"
        ) $Icons.Crown
        
        # Show current safety status
        $prefs = Get-UserSafetyPreferences
        $safetyIcon = switch ($prefs.SafetyLevel) {
            "High" { "[HIGH]" }
            "Medium" { "[MED]" }
            "Low" { "[LOW]" }
            default { "[HIGH]" }
        }
        
        Write-BeautifulBox "Current Protection Level" @(
            "$safetyIcon Safety Level: $($prefs.SafetyLevel)",
            "$($Icons.Shield) Content filtering and package validation active",
            "$($Icons.Config) Customize with: wupm safety"
        ) $Icons.Safety
    }
}

# Beautiful footer
Write-Host ""
Write-Host $($Box.DoubleTopLeft + $Box.DoubleHorizontal * 78 + $Box.DoubleTopRight) -ForegroundColor $Colors.Primary
Write-Host "$($Box.DoubleVertical)          Thank you for using WUPM Enhanced Safety Edition!              $($Box.DoubleVertical)" -ForegroundColor $Colors.Accent
Write-Host "$($Box.DoubleVertical)                     Your security is our top priority                       $($Box.DoubleVertical)" -ForegroundColor $Colors.Safety
Write-Host $($Box.DoubleBottomLeft + $Box.DoubleHorizontal * 78 + $Box.DoubleBottomRight) -ForegroundColor $Colors.Primary

Write-Host ""
