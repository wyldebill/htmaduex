param(
  [string]$EnvPath = ".env"
)

$ErrorActionPreference = "Stop"

if (!(Test-Path $EnvPath)) {
  throw "Missing $EnvPath. Add required Maps/Firebase keys to your local .env first."
}

$envLines = Get-Content $EnvPath
function Read-Secret([string]$Name) {
  $line = $envLines | Where-Object { $_ -match "^\s*$Name\s*=" } | Select-Object -First 1
  if (-not $line) {
    throw "$Name is missing in $EnvPath."
  }

  $value = ($line -split "=", 2)[1].Trim().Trim('"').Trim("'")
  if ([string]::IsNullOrWhiteSpace($value)) {
    throw "$Name in $EnvPath is empty."
  }
  return $value
}

$apiKey = Read-Secret "GOOGLE_MAPS_API_KEY"
$firebaseApiKey = Read-Secret "FIREBASE_API_KEY"
$firebaseAppId = Read-Secret "FIREBASE_APP_ID"
$firebaseSenderId = Read-Secret "FIREBASE_MESSAGING_SENDER_ID"
$firebaseProjectId = Read-Secret "FIREBASE_PROJECT_ID"
$firebaseAuthDomain = Read-Secret "FIREBASE_AUTH_DOMAIN"
$firebaseStorageBucket = Read-Secret "FIREBASE_STORAGE_BUCKET"
$firebaseIosBundleId = Read-Secret "FIREBASE_IOS_BUNDLE_ID"

$target = "ios\Flutter\Secrets.xcconfig"
# iOS build settings require this file before compile, so we generate it from local env.
$lines = @(
  "GOOGLE_MAPS_API_KEY=$apiKey"
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
