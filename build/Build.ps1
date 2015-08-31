param (
	[string]
	$Configuration
)

Import-Module .\build\Build.psm1

Start-Build -Configuration $Configuration

Remove-Module Build