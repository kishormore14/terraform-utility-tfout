# Automatic Windows binary resolver for tfout Terraform module
param (
    [string]$Version = "v0.1.0",
    [string]$Prefix = "https://github.com/tfout/tfout/releases/download"
)

$ErrorActionPreference = "Stop"

# Check if tfout is in PATH
$existing = Get-Command "tfout.exe" -ErrorAction SilentlyContinue
if ($existing) {
    @{ binary_path = $existing.Path } | ConvertTo-Json
    exit 0
}

$BinDir = ".tfout\bin"
if (-not (Test-Path $BinDir)) {
    New-Item -ItemType Directory -Path $BinDir | Out-Null
}

$Arch = "amd64"
if ($env:PROCESSOR_ARCHITECTURE -eq "ARM64") {
    $Arch = "arm64"
}

$BinaryName = "tfout_${Version}_windows_${Arch}.exe"
$TargetPath = Join-Path $BinDir "tfout_${Version}.exe"

if (-not (Test-Path $TargetPath)) {
    $Url = "${Prefix}/${Version}/${BinaryName}"
    try {
        Invoke-WebRequest -Uri $Url -OutFile $TargetPath -UseBasicParsing -ErrorAction SilentlyContinue
    } catch {
        # Fallback to local execution
    }
}

if (Test-Path $TargetPath) {
    @{ binary_path = (Resolve-Path $TargetPath).Path } | ConvertTo-Json
} else {
    @{ binary_path = "tfout" } | ConvertTo-Json
}
