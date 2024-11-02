param (
    [string]$sourcePath = "../GUI/bin/Release/net8.0-windows",
    [string]$templateWix = "./ProductTemplate.xs",
    [string]$templateOutWix = "./ProductTemplateOut.wxs"
)

# Get the full paths
$baseDir = (Get-Location).Path
$absPath = [System.IO.Path]::GetFullPath((Join-Path -Path $baseDir -ChildPath $sourcePath))
$templateWixPath = [System.IO.Path]::GetFullPath((Join-Path -Path $baseDir -ChildPath $templateWix))
$templateOutWixPath = [System.IO.Path]::GetFullPath((Join-Path -Path $baseDir -ChildPath $templateOutWix))

# Function to generate a unique Component entry with a GUID
function Generate-Entry {
    param (
        [string]$filePath
    )

    $fileName = [System.IO.Path]::GetFileName($filePath) -replace " ", "_" -replace "-", "_"
    $isolatedName = $filePath -replace [Regex]::Escape($absPath), ""
    $guid = [guid]::NewGuid().ToString()

    return "<Component Id=""GUI.$fileName"" Guid=""$guid"">
    <File Id=""GUI.$fileName"" Name=""GUI.$fileName"" Source=""$(var.GUI_TargetDir)$isolatedName"" />
</Component>"
}

# Function to get all files in a directory recursively
function Get-AllFiles {
    param (
        [string]$sourceDirectory
    )

    $allFiles = Get-ChildItem -Path $sourceDirectory -Recurse -File | ForEach-Object { $_.FullName }
    return $allFiles
}

# Read the template WiX file
$templateWixData = Get-Content -Path $templateWixPath -Raw

# Get all files in the source directory
$files = Get-AllFiles -sourceDirectory $absPath

# Generate component entries for each file
$componentEntries = $files | ForEach-Object { Generate-Entry -filePath $_ }

# Replace the placeholder with the generated entries in the template
$outputData = $templateWixData -replace "<EXTRA/>", ($componentEntries -join "`n")

# Write the modified XML to the output file
Set-Content -Path "$baseDir\Product.wxs" -Value $outputData -Encoding UTF8
Write-Output "Generated Product.wxs with component entries."
