echo "Downloading requirements"
call C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe -ExecutionPolicy Bypass -File "%cd%\DownloadLatestNupkg.ps1" -githubRepo "vltmedia/UAI_ONNX" -packageName "UAI_ONNX" -outputPath "%cd%" -versionFilePath "%cd%\version.txt" -projectPath "%cd%\UAI_ONNX_FaceParse.csproj"
echo "Downloaded requirements"

