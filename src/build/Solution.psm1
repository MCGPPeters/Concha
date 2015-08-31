#
# A solution is a combination of projects that have a common lifecycle. That means all projects within it
# share a GitHub repository, development workflow, release strategy, SemVer versioning etc...
#

function New-Solution {
	[CmdletBinding(DefaultParameterSetName='user')]
	param(
		[Parameter(Mandatory = $true, Position = 0)]
		[string] $GitHubAccessToken,
		[Parameter(Mandatory = $true)]
		[string] $SolutionName,
		[Parameter(Mandatory = $true)]
		[string] $Path,
		[Parameter(Mandatory = $true)]
		[ValidateSetAttribute("gitflow")]
		[string] $DevelopmentWorkflow,
		[Parameter(Mandatory = $true, ParameterSetName='organization')]
		[string] $OrganizationName
 	)
	Begin {
	}
	Process	{


		New-SolutionStructure -SolutionName $SolutionName -Path $Path
		
		Initialize-GitFlow
				
		New-GitHubRepository -Name

	}
	End {

	}
}

function Join-Solution {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory = $true, Position = 0)]
		[string] $GitHubAccessToken,
		[Parameter(Mandatory = $true)]
		[string] $SolutionName,
		[Parameter(Mandatory = $true)]
		[string] $Owner
		[Parameter(Mandatory = $false)]
		[switch] $UseSSH	
	)
	Begin {
	}
	Process	{
		
		
		
		if($UseSSH.ToBool() -eq $true) {
			$cloneUrl = gitHubRepository.ssh_url
		}
		else {
			$cloneUrl = gitHubRepository.clone_url
		}	
	}
	End {

	}
}

function Rename-Solution {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory = $true, Position = 0)]
		[string] $GitHubAccessToken,
		[Parameter(Mandatory = $true)]
		[string] $SolutionName
	)
	Begin {
	}
	Process	{
				
				
	}
	End {

	}
}

function Add-License {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory = $true, Position = 0)]
		[string] $GitHubAccessToken,
		[Parameter(Mandatory = $true)]
		[string] $SolutionName
	)
	Begin {
	}
	Process	{
				
				
	}
	End {

	}
}



function New-SolutionStructure {
	[CmdletBinding()]
	param(
		[Parameter(Mandatory = $true)]
		[string] $SolutionName,
		[Parameter(Mandatory = $true)]
		[string] $Path
	)
	Begin {
		
	}
	Process	{
		
		New-Item -ItemType Directory -Path $Path -Name $SolutionName -Verbose

		$SolutionPath = Join-Path -Path $Path -ChildPath $SolutionName
												   										   
		New-Item -ItemType Directory -Path $SolutionPath -Name "docs" -Verbose
		New-Item -ItemType Directory -Path $SolutionPath -Name "src" -Verbose
		New-Item -ItemType Directory -Path $SolutionPath -Name "tests" -Verbose
		New-Item -ItemType Directory -Path $SolutionPath -Name "samples" -Verbose
		New-Item -ItemType Directory -Path $SolutionPath -Name "build" -Verbose
		New-Item -ItemType Directory -Path $SolutionPath -Name "artifacts" -Verbose
		New-Item -ItemType Directory -Path $SolutionPath -Name ".NuGet" -Verbose | Resolve-Path -OutVariable NuGetPath
		
		Invoke-WebRequest -Uri "https://nuget.org/nuget.exe" -OutFile "$NuGetPath\NuGet.exe" -Verbose

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