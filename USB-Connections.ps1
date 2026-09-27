Write-Host "`nUSB-Connections by NameLessF0" -ForegroundColor Black
Write-Host "`nGitHub: https://github.com/NameLess0" -ForegroundColor White
Write-Host "`nDiscord: https://discord.gg/k7hcQKRXQt" -ForegroundColor Blue
Write-Host "`nRunning the script..." -ForegroundColor Red

$previous = @{}

while ($true) {
    try {
        $current = @{}

        Get-PnpDevice -ErrorAction SilentlyContinue |
            Where-Object {
                $_.InstanceId -match 'USB' -and
                $_.Status -eq 'OK'
            } |
            ForEach-Object {
                $current[$_.InstanceId] = $_.FriendlyName
            }

        foreach ($id in $current.Keys) {
            if (-not $previous.ContainsKey($id)) {
                Write-Host "$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss') [CONNECTED] $($current[$id])"
            }
        }

        foreach ($id in $previous.Keys) {
            if (-not $current.ContainsKey($id)) {
                Write-Host "$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss') [DISCONNECTED] $($previous[$id])"
            }
        }

        $previous = $current
    }
    catch {
        Write-Host "$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss') [ERROR] $($_.Exception.Message)"
    }

    Start-Sleep -Milliseconds 500
}
