<#
.SYNOPSIS
    Smoke test to validate external collector connectivity over TLS.
#>

param(
    [string]$Url = "https://collector.example/ingest"
)

try {
    $resp = Invoke-WebRequest -Method POST -Uri $Url -Body '{"health":"ping"}' -ContentType "application/json" -TimeoutSec 10
    Write-Host "HTTP $($resp.StatusCode) from $Url"
} catch {
    Write-Error $_
    exit 1
}
