# ==============================================================================
#  OMNI.psm1 — Native PowerShell Module for OMNI Command & Control Fleet
#  Author: Jordan Isaac (@dragpk247)
#  License: MIT
# ==============================================================================

# Default configurations path: $env:USERPROFILE\.config\omni\config.env
$script:OmniConfigPath = Join-Path $env:USERPROFILE ".config\omni\config.env"
$script:OmniConfig = @{
    DESKTOP_IP   = "100.86.159.86"
    DESKTOP_USER = "jpi"
    LAPTOP_IP    = "100.72.213.23"
    LAPTOP_USER  = "jpi"
    PHONE_IP     = "100.118.50.88"
    PHONE_PORT   = "8022"
    PHONE_USER   = "u0_a501"
    PHONE_DOWNLOADS = "/sdcard/Download"
    DESKTOP_DOWNLOADS = "/home/jpi/Downloads"
    LAPTOP_DOWNLOADS = "/home/jpi/Downloads"
    WINDOWS_DOWNLOADS = (Join-Path $env:USERPROFILE "Downloads")
}

function Import-OmniConfig {
    if (Test-Path $script:OmniConfigPath) {
        Get-Content $script:OmniConfigPath | ForEach-Object {
            $line = $_.Trim()
            if ($line -and -not $line.StartsWith("#") -and $line.Contains("=")) {
                $parts = $line -split "=", 2
                $key = $parts[0].Trim()
                $val = $parts[1].Trim(' "''')
                $script:OmniConfig[$key] = $val
            }
        }
    }
}

Import-OmniConfig

function Get-OmniPing {
    param([string]$TargetIp)
    if (-not $TargetIp) { return "down" }
    try {
        $p = Test-Connection -ComputerName $TargetIp -Count 1 -TimeoutSeconds 1 -ErrorAction SilentlyContinue
        if ($p) {
            $rtt = [math]::Round($p.ResponseTime, 1)
            return "$($rtt)ms"
        }
    } catch {}
    return "down"
}

function Get-OmniStatus {
    [CmdletBinding()]
    param()

    Import-OmniConfig
    Write-Host "`n🌐 OMNI Fleet Telemetry (Windows Node: $env:COMPUTERNAME)" -ForegroundColor Cyan
    Write-Host "===========================================================" -ForegroundColor DarkGray

    $nodes = @(
        @{ Name = "🖥️  Desktop"; IP = $script:OmniConfig["DESKTOP_IP"]; User = $script:OmniConfig["DESKTOP_USER"] },
        @{ Name = "💻 Laptop "; IP = $script:OmniConfig["LAPTOP_IP"];  User = $script:OmniConfig["LAPTOP_USER"] },
        @{ Name = "📱 Phone  "; IP = $script:OmniConfig["PHONE_IP"];   User = $script:OmniConfig["PHONE_USER"] }
    )

    foreach ($node in $nodes) {
        $ping = Get-OmniPing -TargetIp $node.IP
        if ($ping -ne "down") {
            Write-Host ("  [ONLINE]  {0}  ({1})  RTT: {2}" -f $node.Name, $node.IP, $ping) -ForegroundColor Green
        } else {
            Write-Host ("  [OFFLINE] {0}  ({1})" -f $node.Name, $node.IP) -ForegroundColor DarkRed
        }
    }

    if (Get-Command tailscale.exe -ErrorAction SilentlyContinue) {
        $tsIp = (& tailscale.exe ip -4 2>$null)
        if ($tsIp) {
            Write-Host "`n  Tailscale IP (Local Windows): $tsIp" -ForegroundColor DarkCyan
        }
    }
    Write-Host ""
}

function Send-OmniFile {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true, Position=0)]
        [string]$Path,

        [Parameter(Position=1)]
        [ValidateSet("phone", "desktop", "laptop")]
        [string]$Target
    )

    if (-not (Test-Path $Path)) {
        Write-Error "File or directory not found: $Path"
        return
    }

    Import-OmniConfig
    $resolved = (Resolve-Path $Path).Path
    $fileName = Split-Path $resolved -Leaf

    if (-not $Target) {
        Write-Host "`nSending '$fileName'... Choose destination:" -ForegroundColor Cyan
        Write-Host "  [1] 📱 Phone" -ForegroundColor Green
        Write-Host "  [2] 🖥️  Desktop" -ForegroundColor Green
        Write-Host "  [3] 💻 Laptop" -ForegroundColor Green
        $choice = Read-Host "Select [1-3]"
        switch ($choice) {
            "1" { $Target = "phone" }
            "2" { $Target = "desktop" }
            "3" { $Target = "laptop" }
            default { Write-Host "Cancelled." -ForegroundColor Yellow; return }
        }
    }

    switch ($Target) {
        "phone" {
            $ip = $script:OmniConfig["PHONE_IP"]
            $user = $script:OmniConfig["PHONE_USER"]
            $port = $script:OmniConfig["PHONE_PORT"]
            $dest = $script:OmniConfig["PHONE_DOWNLOADS"]
            Write-Host "[*] Transferring '$fileName' to Phone ($ip)..." -ForegroundColor Cyan
            & scp.exe -P $port -r "$resolved" "${user}@${ip}:${dest}/"
            if ($LASTEXITCODE -eq 0) {
                Write-Host "[✓] Sent successfully to Phone Downloads!" -ForegroundColor Green
                & ssh.exe -p $port "${user}@${ip}" "termux-notification --title 'OMNI File Received' --content '$fileName saved from Windows' 2>/dev/null" 2>$null
            } else {
                Write-Host "[!] Failed to transfer file." -ForegroundColor Red
            }
        }
        "desktop" {
            $ip = $script:OmniConfig["DESKTOP_IP"]
            $user = $script:OmniConfig["DESKTOP_USER"]
            $dest = $script:OmniConfig["DESKTOP_DOWNLOADS"]
            Write-Host "[*] Transferring '$fileName' to Desktop ($ip)..." -ForegroundColor Cyan
            & scp.exe -r "$resolved" "${user}@${ip}:${dest}/"
            if ($LASTEXITCODE -eq 0) {
                Write-Host "[✓] Sent successfully to Desktop Downloads!" -ForegroundColor Green
                & ssh.exe "${user}@${ip}" "notify-send 'OMNI File Received' '$fileName saved from Windows' 2>/dev/null" 2>$null
            } else {
                Write-Host "[!] Failed to transfer file." -ForegroundColor Red
            }
        }
        "laptop" {
            $ip = $script:OmniConfig["LAPTOP_IP"]
            $user = $script:OmniConfig["LAPTOP_USER"]
            $dest = $script:OmniConfig["LAPTOP_DOWNLOADS"]
            Write-Host "[*] Transferring '$fileName' to Laptop ($ip)..." -ForegroundColor Cyan
            & scp.exe -r "$resolved" "${user}@${ip}:${dest}/"
            if ($LASTEXITCODE -eq 0) {
                Write-Host "[✓] Sent successfully to Laptop Downloads!" -ForegroundColor Green
                & ssh.exe "${user}@${ip}" "notify-send 'OMNI File Received' '$fileName saved from Windows' 2>/dev/null" 2>$null
            } else {
                Write-Host "[!] Failed to transfer file." -ForegroundColor Red
            }
        }
    }
}

function Sync-OmniClipboard {
    [CmdletBinding()]
    param(
        [Parameter(Position=0)]
        [ValidateSet("push", "pull", "broadcast")]
        [string]$Action = "broadcast",

        [Parameter(Position=1)]
        [ValidateSet("phone", "desktop", "laptop", "all")]
        [string]$Target = "all"
    )

    Import-OmniConfig

    if ($Action -in @("push", "broadcast")) {
        $text = Get-Clipboard -Raw
        if (-not $text) {
            Write-Host "[!] Windows clipboard is empty." -ForegroundColor Yellow
            return
        }

        $targets = if ($Target -eq "all") { @("phone", "desktop", "laptop") } else { @($Target) }

        foreach ($t in $targets) {
            switch ($t) {
                "phone" {
                    $ip = $script:OmniConfig["PHONE_IP"]
                    $user = $script:OmniConfig["PHONE_USER"]
                    $port = $script:OmniConfig["PHONE_PORT"]
                    $escaped = $text -replace "'", "'\''"
                    & ssh.exe -p $port "${user}@${ip}" "printf '%s' '$escaped' | termux-clipboard-set 2>/dev/null" 2>$null
                    if ($LASTEXITCODE -eq 0) { Write-Host "[✓] Clipboard synced to Phone!" -ForegroundColor Green }
                }
                "desktop" {
                    $ip = $script:OmniConfig["DESKTOP_IP"]
                    $user = $script:OmniConfig["DESKTOP_USER"]
                    $escaped = $text -replace "'", "'\''"
                    & ssh.exe "${user}@${ip}" "printf '%s' '$escaped' | wl-copy 2>/dev/null || xclip -selection clipboard 2>/dev/null" 2>$null
                    if ($LASTEXITCODE -eq 0) { Write-Host "[✓] Clipboard synced to Desktop!" -ForegroundColor Green }
                }
                "laptop" {
                    $ip = $script:OmniConfig["LAPTOP_IP"]
                    $user = $script:OmniConfig["LAPTOP_USER"]
                    $escaped = $text -replace "'", "'\''"
                    & ssh.exe "${user}@${ip}" "printf '%s' '$escaped' | wl-copy 2>/dev/null || xclip -selection clipboard 2>/dev/null" 2>$null
                    if ($LASTEXITCODE -eq 0) { Write-Host "[✓] Clipboard synced to Laptop!" -ForegroundColor Green }
                }
            }
        }
    } elseif ($Action -eq "pull") {
        if ($Target -eq "all") { $Target = "phone" }
        $pulled = ""
        switch ($Target) {
            "phone" {
                $ip = $script:OmniConfig["PHONE_IP"]
                $user = $script:OmniConfig["PHONE_USER"]
                $port = $script:OmniConfig["PHONE_PORT"]
                $pulled = (& ssh.exe -p $port "${user}@${ip}" "termux-clipboard-get 2>/dev/null")
            }
            "desktop" {
                $ip = $script:OmniConfig["DESKTOP_IP"]
                $user = $script:OmniConfig["DESKTOP_USER"]
                $pulled = (& ssh.exe "${user}@${ip}" "wl-paste 2>/dev/null || xclip -selection clipboard -o 2>/dev/null")
            }
            "laptop" {
                $ip = $script:OmniConfig["LAPTOP_IP"]
                $user = $script:OmniConfig["LAPTOP_USER"]
                $pulled = (& ssh.exe "${user}@${ip}" "wl-paste 2>/dev/null || xclip -selection clipboard -o 2>/dev/null")
            }
        }
        if ($pulled) {
            Set-Clipboard -Value $pulled
            Write-Host "[✓] Successfully pulled clipboard from $Target into Windows clipboard!" -ForegroundColor Green
            $preview = if ($pulled.Length -gt 60) { $pulled.Substring(0, 60) + "..." } else { $pulled }
            Write-Host "    Preview: $preview" -ForegroundColor DarkGray
        } else {
            Write-Host "[!] Could not pull clipboard from $Target (node offline or clipboard empty)." -ForegroundColor Red
        }
    }
}

function Connect-OmniSsh {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true, Position=0)]
        [ValidateSet("phone", "desktop", "laptop")]
        [string]$Target
    )

    Import-OmniConfig
    switch ($Target) {
        "phone" {
            $ip = $script:OmniConfig["PHONE_IP"]
            $user = $script:OmniConfig["PHONE_USER"]
            $port = $script:OmniConfig["PHONE_PORT"]
            & ssh.exe -p $port "${user}@${ip}"
        }
        "desktop" {
            $ip = $script:OmniConfig["DESKTOP_IP"]
            $user = $script:OmniConfig["DESKTOP_USER"]
            & ssh.exe "${user}@${ip}"
        }
        "laptop" {
            $ip = $script:OmniConfig["LAPTOP_IP"]
            $user = $script:OmniConfig["LAPTOP_USER"]
            & ssh.exe "${user}@${ip}"
        }
    }
}

function Start-OmniDashboard {
    [CmdletBinding()]
    param()

    Import-OmniConfig
    while ($true) {
        Clear-Host
        Write-Host "================================================================================" -ForegroundColor Cyan
        Write-Host " 🌐 OMNI — Windows Command & Control Center ($env:COMPUTERNAME)" -ForegroundColor White
        Write-Host "================================================================================" -ForegroundColor Cyan

        Get-OmniStatus

        Write-Host "Fleet Actions:" -ForegroundColor DarkCyan
        Write-Host "  [1] 📋 Sync Windows Clipboard -> Fleet (Broadcast)" -ForegroundColor Green
        Write-Host "  [2] 📥 Pull Clipboard from Phone" -ForegroundColor Green
        Write-Host "  [3] 📥 Pull Clipboard from Desktop / Laptop" -ForegroundColor Green
        Write-Host "  [4] 📁 Send File / Folder to Fleet" -ForegroundColor Green
        Write-Host "  [5] 🖥️  SSH into Desktop" -ForegroundColor Green
        Write-Host "  [6] 💻 SSH into Laptop" -ForegroundColor Green
        Write-Host "  [7] 📱 SSH into Phone (Termux)" -ForegroundColor Green
        Write-Host "  [8] 🎮 Sunshine / Moonlight Status" -ForegroundColor Green
        Write-Host "  [q] Quit to PowerShell" -ForegroundColor DarkGray
        Write-Host ""

        $ans = Read-Host "Select an option [1-8, q]"
        switch ($ans) {
            "1" { Sync-OmniClipboard -Action broadcast; Start-Sleep -Seconds 1 }
            "2" { Sync-OmniClipboard -Action pull -Target phone; Start-Sleep -Seconds 1 }
            "3" {
                $sub = Read-Host "Pull from Desktop (d) or Laptop (l)?"
                if ($sub -match "^d") { Sync-OmniClipboard -Action pull -Target desktop }
                else { Sync-OmniClipboard -Action pull -Target laptop }
                Start-Sleep -Seconds 1
            }
            "4" {
                $filePath = Read-Host "Enter path to file or folder to send"
                if ($filePath) { Send-OmniFile -Path $filePath }
                Start-Sleep -Seconds 1
            }
            "5" { Connect-OmniSsh -Target desktop }
            "6" { Connect-OmniSsh -Target laptop }
            "7" { Connect-OmniSsh -Target phone }
            "8" {
                Write-Host "Checking Sunshine service..." -ForegroundColor Cyan
                Get-Service -Name "Sunshine" -ErrorAction SilentlyContinue | Format-Table -AutoSize
                Read-Host "Press Enter to continue"
            }
            "q" { break }
        }
    }
}

# Main command dispatcher: `omni <command>`
function Invoke-Omni {
    [CmdletBinding()]
    param(
        [Parameter(Position=0)]
        [string]$Command,

        [Parameter(ValueFromRemainingArguments=$true)]
        [string[]]$Args
    )

    switch ($Command) {
        { $_ -in @("status", "ping") } { Get-OmniStatus }
        { $_ -in @("send", "share", "push-file") } {
            $filePath = $Args[0]
            $target = $Args[1]
            Send-OmniFile -Path $filePath -Target $target
        }
        { $_ -in @("clip", "clipboard") } {
            $act = if ($Args[0]) { $Args[0] } else { "broadcast" }
            $tar = if ($Args[1]) { $Args[1] } else { "all" }
            Sync-OmniClipboard -Action $act -Target $tar
        }
        { $_ -in @("ssh", "connect") } {
            $tar = if ($Args[0]) { $Args[0] } else { "desktop" }
            Connect-OmniSsh -Target $tar
        }
        default {
            Start-OmniDashboard
        }
    }
}

Set-Alias -Name omni -Value Invoke-Omni -Scope Global
Export-ModuleMember -Function Get-OmniStatus, Send-OmniFile, Sync-OmniClipboard, Connect-OmniSsh, Start-OmniDashboard, Invoke-Omni -Alias omni
