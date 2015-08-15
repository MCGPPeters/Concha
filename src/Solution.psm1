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
												   										   
		New-Item -ItemType Directory -Path $projectPath -Name "docs" -Verbose
		New-Item -ItemType Directory -Path $projectPath -Name "src" -Verbose
		New-Item -ItemType Directory -Path $projectPath -Name "samples" -Verbose
		New-Item -ItemType Directory -Path $projectPath -Name "build" -Verbose
		New-Item -ItemType Directory -Path $projectPath -Name "tools" -Verbose | Resolve-Path -OutVariable toolsPath	
		New-Item -ItemType Directory -Path $toolsPath -Name ".NuGet" -Verbose | Resolve-Path -OutVariable NuGetPath
		
		Invoke-WebRequest "https://nuget.org/nuget.exe" -OutFile "$NuGetPath\NuGet.exe" -Verbose

		$NuGetConfig = "<?xml version='1.0' encoding='utf-8'?>
						<configuration>
						  <solution>
							<add key='disableSourceControlIntegration' value='true' />
						  </solution>
						  <packageSources>
							<add key='nuget.org' value='https://www.nuget.org/api/v2/' />
						  </packageSources>
						</configuration>"
		New-Item -ItemType File -Path "$NuGetPath\NuGet.Config" -Value $NuGetConfig -Verbose

	}
	End {

	}
}