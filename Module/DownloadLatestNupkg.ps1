param (
    [string]$githubRepo = "owner/repo",
    [string]$packageName = "UAI_ONNX",
    [string]$outputPath = "./packages",
    [string]$projectPath = "UAI_ONNX.csproj",
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

# Download the .nupkg only if there is a new version
if ($shouldDownload) {
    # Find the asset matching the .nupkg pattern with version numbers
    $asset = $response.assets | Where-Object { $_.name -match "$packageName\.\d+\.\d+\.\d+\.nupkg" }

    
    # Debugging: Check the assets to ensure we find the expected .nupkg file
    Write-Output "Assets found in latest release:"
    $response.assets | ForEach-Object { Write-Output $_.name }

    # Ensure asset exists before proceeding
    if ($null -eq $asset) {
        Write-Output "Package $packageName not found in the latest release of $githubRepo."
        exit 1
    }

    # Download the .nupkg file
    $outputFile = Join-Path -Path $outputPath -ChildPath $asset.name
    Invoke-WebRequest -Uri $asset.browser_download_url -OutFile $outputFile

    # Save the latest version to the version file
    Set-Content -Path $versionFilePath -Value $latestVersion

    Write-Output "Downloaded $asset.name (version $latestVersion) to $outputFile"
    
    # Install the .nupkg package using dotnet CLI
    # Write-Output "$projectPath package $packageName --version 1.0.2 --source LocalPackages"
    # dotnet restore $projectPath
    # dotnet add $projectPath package $packageName  --source "LocalPackages"
   #  dotnet restore $projectPath
   

}
else {
    Write-Output "No new version to download."
}
