#
# Solution.psm1
#

function New-DotNetProjectStructure {
	[CmdletBinding()]
	param(
		[Parameter(Mandatory = $true)]
		[string] $ProjectName,
		[Parameter(Mandatory = $true)]
		[string] $Path
	)
	Begin {
		
	}
	Process	{
		
		New-Item -ItemType Directory -Path $Path -Name $ProjectName -Verbose

		$projectPath = Join-Path -Path $Path -ChildPath $ProjectName
												   
		Push-Location $projectPath
										   
		New-Item -ItemType Directory -Path $projectPath -Name "docs" -Verbose
		New-Item -ItemType Directory -Path $projectPath -Name "src" -Verbose
		New-Item -ItemType Directory -Path $projectPath -Name "samples" -Verbose
		New-Item -ItemType Directory -Path $projectPath -Name "build" -Verbose
		New-Item -ItemType Directory -Path $projectPath -Name "tools" -Verbose
		New-Item -ItemType Directory -Path $projectPath -Name "packages" -Verbose

		Pop-Location
	}
	End {

	}
}