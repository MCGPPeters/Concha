#
# Build.ps1
#
param(
    $task = "default",
    $gitVersionUserName = "",
    $gitVersionPassword = ""
)

$base_directory = Resolve-Path .
$src_directory = $base_directory
$tools_directory = "$base_directory\tools"

get-module psake | remove-module

& "$tools_directory\.nuget\NuGet.exe" install "$tools_directory\.nuget\packages.config" -OutputDirectory "$base_directory\src\packages"

Import-Module (Get-ChildItem "$tools_directory\.nuget\psake.*\tools\psake.psm1" | Select-Object -First 1)
Import-Module (Get-ChildItem "$tools_directory\.nuget\pester.*\tools\pester.psm1" | Select-Object -First 1)

Import-Module $tools_directory\teamcity.psm1

Invoke-Psake $base_directory\default.ps1 $task -framework "4.0x64" -properties @{ gitVersionUserName=$gitVersionUserName; gitVersionPassword=$gitVersionPassword }

Remove-Module teamcity
Remove-Module psake