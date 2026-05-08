param(
  [string]$EnvPath = ".env"
)

$ErrorActionPreference = "Stop"

if (!(Test-Path $EnvPath)) {
  throw "Missing $EnvPath. Add GOOGLE_MAPS_API_KEY to your local .env first."
}

$envLines = Get-Content $EnvPath
$apiKeyLine = $envLines | Where-Object { $_ -match "^\s*GOOGLE_MAPS_API_KEY\s*=" } | Select-Object -First 1
if (-not $apiKeyLine) {
  throw "GOOGLE_MAPS_API_KEY is missing in $EnvPath."
}

$apiKey = ($apiKeyLine -split "=", 2)[1].Trim().Trim('"').Trim("'")
if ([string]::IsNullOrWhiteSpace($apiKey)) {
  throw "GOOGLE_MAPS_API_KEY in $EnvPath is empty."
}

$target = "ios\Flutter\Secrets.xcconfig"
# iOS build settings require this file before compile, so we generate it from local env.
"GOOGLE_MAPS_API_KEY=$apiKey" | Set-Content -Path $target -Encoding UTF8
Write-Host "Generated $target"
