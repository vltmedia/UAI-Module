param (
    [string]$githubRepo = "owner/repo",
    [string]$assetName = "YourLibrary.dll",
    [string]$outputPath = "./libs",
    [string]$versionFilePath = "./version.txt"
)

# Trim any extra quotes from the outputPath
$outputPath = $outputPath.Trim('"')
$versionFilePath = $versionFilePath.Trim('"')

# Ensure output directory exists
if (!(Test-Path -Path $outputPath)) {
    New-Item -ItemType Directory -Path $outputPath | Out-Null
}

# Get the latest release metadata from GitHub API
$latestReleaseUrl = "https://api.github.com/repos/$githubRepo/releases/latest"
$response = Invoke-RestMethod -Uri $latestReleaseUrl -UseBasicParsing
$latestVersion = $response.tag_name

# Check if the version file exists and read its content
$shouldDownload = $true
if (Test-Path -Path $versionFilePath) {
    $currentVersion = Get-Content -Path $versionFilePath -Raw
    if ($currentVersion -eq $latestVersion) {
        Write-Output "The latest version ($latestVersion) is already downloaded."
        $shouldDownload = $false
    }
}

# Download the asset only if there is a new version
if ($shouldDownload) {
    # Find the asset matching the specified asset name
    $asset = $response.assets | Where-Object { $_.name -eq $assetName }

    if ($null -eq $asset) {
        Write-Output "Asset $assetName not found in the latest release of $githubRepo."
        exit 1
    }

    # Download the asset
    $outputFile = Join-Path -Path $outputPath -ChildPath $assetName
    Invoke-WebRequest -Uri $asset.browser_download_url -OutFile $outputFile

    # Save the latest version to the version file
    Set-Content -Path $versionFilePath -Value $latestVersion

    Write-Output "Downloaded $assetName (version $latestVersion) to $outputFile"
}
else{
Write-Output "No new version to download."
}
