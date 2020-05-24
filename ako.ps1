# Script to deploy AI to OpenTTD directory
# Sample execution: 
#   deploy.ps1 .\Daia
param(
    [Parameter(Mandatory)]
    [string]$aiPath
) 

# Help function to test directory
function Test-DirPath($dirPath)
{
    return (
        (Test-Path $dirPath) -and 
        ((Get-Item $dirPath) -is [System.IO.DirectoryInfo])
    )
}


# Main script

Set-Variable openTTD_path -option Constant -value 'C:\Apps\openttd'
Set-Variable ai_dir_name -option Constant -value 'ai'

if (-not (Test-DirPath $openTTD_path))
{
    Write-Error "Invalid OpenTTD path [$openTTD_path]"
    return
}

$dstPath = Join-Path $openTTD_Path $ai_dir_name
if (-not (Test-DirPath $dstPath))
{
    Write-Error "Invalid OpenTTD AI path [$dstPath]"
    return
}


if (-not (Test-DirPath $aiPath))
{
    Write-Error "Invalid source AI path [$aiPath]"
    return
}

# Copy files to new directory only if specified name is available and is a directory
# if ((Test-Path $aiPath) -and ((Get-Item $aiPath) -is [System.IO.DirectoryInfo]))
# {
#     Copy-Item -Path $aiPath -Destination $dstPath -Recurse -Force
# }

Copy-Item -Path $aiPath -Destination $dstPath -Recurse -Force
Write-Host "$((Get-Date).ToString("s")) Files deployed.`n"