param(
  [string]$EnvPath = ".env"
)

$ErrorActionPreference = "Stop"
$repoRoot = Split-Path -Parent $PSScriptRoot
$resolvedEnvPath = $EnvPath

if (!(Test-Path $resolvedEnvPath) -and -not [System.IO.Path]::IsPathRooted($EnvPath)) {
  $resolvedEnvPath = Join-Path $repoRoot $EnvPath
}

if (!(Test-Path $resolvedEnvPath)) {
  throw "Missing $EnvPath. Add required Maps/Firebase keys to your local .env first."
}

$envLines = Get-Content $resolvedEnvPath
function Read-RequiredSecret([string]$Name) {
  $line = $envLines | Where-Object { $_ -match "^\s*$Name\s*=" } | Select-Object -First 1
  if (-not $line) {
    throw "$Name is missing in $resolvedEnvPath."
  }

  $value = ($line -split "=", 2)[1].Trim().Trim('"').Trim("'")
  if ([string]::IsNullOrWhiteSpace($value)) {
    throw "$Name in $resolvedEnvPath is empty."
  }
  return $value
}

function Read-OptionalSecret([string]$Name) {
  $line = $envLines | Where-Object { $_ -match "^\s*$Name\s*=" } | Select-Object -First 1
  if (-not $line) {
    return ""
  }

  return ($line -split "=", 2)[1].Trim().Trim('"').Trim("'")
}

$apiKeyIos = Read-RequiredSecret "GOOGLE_MAPS_API_KEY_IOS"
$firebaseApiKey = Read-OptionalSecret "FIREBASE_API_KEY"
$firebaseAppId = Read-OptionalSecret "FIREBASE_APP_ID"
$firebaseSenderId = Read-OptionalSecret "FIREBASE_MESSAGING_SENDER_ID"
$firebaseProjectId = Read-OptionalSecret "FIREBASE_PROJECT_ID"
$firebaseAuthDomain = Read-OptionalSecret "FIREBASE_AUTH_DOMAIN"
$firebaseStorageBucket = Read-OptionalSecret "FIREBASE_STORAGE_BUCKET"
$firebaseIosBundleId = Read-OptionalSecret "FIREBASE_IOS_BUNDLE_ID"

$target = Join-Path $repoRoot "ios/Flutter/Secrets.xcconfig"
# iOS build settings require this file before compile, so we generate it from local env.
$lines = @(
  "GOOGLE_MAPS_API_KEY_IOS=$apiKeyIos"
  "FIREBASE_API_KEY=$firebaseApiKey"
  "FIREBASE_APP_ID=$firebaseAppId"
  "FIREBASE_MESSAGING_SENDER_ID=$firebaseSenderId"
  "FIREBASE_PROJECT_ID=$firebaseProjectId"
  "FIREBASE_AUTH_DOMAIN=$firebaseAuthDomain"
  "FIREBASE_STORAGE_BUCKET=$firebaseStorageBucket"
  "FIREBASE_IOS_BUNDLE_ID=$firebaseIosBundleId"
)

$lines | Set-Content -Path $target -Encoding UTF8
Write-Host "Generated $target"
