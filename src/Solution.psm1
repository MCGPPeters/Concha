#
# A solution is a combination of projects that have a common lifecycle. That means all projects within it
# share a GitHub repository, development workflow, release strategy, SemVer versioning etc...
#

Set-Variable -Name SourceFolderName       -Value 'src'       -Option Constant
Set-Variable -Name DocsFolderName         -Value 'docs' 	 -Option Constant
Set-Variable -Name TestFolderName         -Value 'tests' 	 -Option Constant
Set-Variable -Name SamplesFolderName      -Value 'samples'   -Option Constant
Set-Variable -Name BuildFolderName        -Value 'build' 	 -Option Constant
Set-Variable -Name ArtifactsFolderName    -Value 'artifacts' -Option Constant
Set-Variable -Name NugetFolderName        -Value '.nuget'    -Option Constant
Set-Variable -Name NugetPackageFolderName -Value 'packages'  -Option Constant

Import-Module -Name GitHubShell			    
Import-Module -Name GitFlowShell
Import-Module -Name SolutionShell

Function New-Solution 
{
	[CmdletBinding(DefaultParameterSetName='user')]
	Param
	(
		[Parameter(Mandatory = $true)]
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
	Begin 
	{
	}
	Process	
	{
		$solutionFolderStructure = New-SolutionFolderStructure -SolutionName $SolutionName -Path $Path      
		$useNuGetOrg = 
		@{
			Source = nuget.org;
			ProviderName = NuGet;
			Destination = $solutionFolderStructure.NuGetPackagesFolderPath;
			Force = $true
		}

		Install-Package -Name psake -MinimumVersion 4.4.2 -MaximumVersion 4.9.9 @useNuGetOrg
		Install-Package -Name nuget.commandline -MinimumVersion 2.8.6 -MaximumVersion 2.9.9 @useNuGetOrg
		Install-Package -Name GitVersion.CommandLine -MinimumVersion 3.1.2 -MaximumVersion 3.9.9 @useNuGetOrg
		Install-Package -Name gitreleasemanager -MinimumVersion 0.3.0 -MaximumVersion 1.0.0 @useNuGetOrg
		Install-Package -Name xunit.runner.console -MinimumVersion 2.0.0 -MaximumVersion 2.9.9 @useNuGetOrg
		Install-Package -Name ILRepack -MinimumVersion 1.25.0 -MaximumVersion 1.9.9 @useNuGetOrg

		Initialize-GitFlow -Path $Path
				
		New-GitHubRepository -Name $SolutionName

	}
	End 
	{

	}
}

Function Join-Solution 
{
	[CmdletBinding()]
	Param (
		[Parameter(Mandatory = $true, Position = 0)]
		[string] $GitHubAccessToken,
		[Parameter(Mandatory = $true)]
		[string] $SolutionName,
		[Parameter(Mandatory = $true)]
		[string] $Owner,
		[Parameter(Mandatory = $false)]
		[switch] $UseSSH	
	)
	Begin 
	{
	}
	Process	
	{		
		if($UseSSH.ToBool() -eq $true) 
		{
			$cloneUrl = gitHubRepository.ssh_url
		}
		else 
		{
			$cloneUrl = gitHubRepository.clone_url
		}	
	}
	End 
	{

	}
}

Function Rename-Solution 
{
	[CmdletBinding()]
	Param 
	(
		[Parameter(Mandatory = $true, Position = 0)]
		[string] $GitHubAccessToken,
		[Parameter(Mandatory = $true)]
		[string] $SolutionName
	)
	Begin 
	{
	}
	Process	
	{
				
				
	}
	End 
	{

	}
}

Function Add-License 
{
	[CmdletBinding()]
	Param 
	(
		[Parameter(Mandatory = $true, Position = 0)]
		[string] $GitHubAccessToken,
		[Parameter(Mandatory = $true)]
		[string] $SolutionName
	)
	Begin 
	{
	}
	Process	
	{
				
				
	}
	End 
	{

	}
}

Function New-SolutionFolderStructure 
{
	[CmdletBinding()]
	param(
		[Parameter(Mandatory = $true)]
		[string] $SolutionName,
		[Parameter(Mandatory = $true)]
		[string] $Path
	)
	Process	
	{	
		$solutionFolderStructure = 
		@{	
			Name = New-Item -ItemType Directory -Path $Path -Name $SolutionName -Verbose | Resolve-Path -OutVariable SolutionFolderPath;											   										   
			DocumentationFolderPath = New-Item -ItemType Directory -Path $SolutionFolderPath -Name $DocumentationFolderPath -Verbose | Resolve-Path -OutVariable DocumentationFolderPath;
			SourceFolderPath = New-Item -ItemType Directory -Path $SolutionFolderPath -Name $SourceFolderPath 	-Verbose | Resolve-Path -OutVariable SourceFolderPath;
			TestsFolderPath = New-Item -ItemType Directory -Path $SolutionFolderPath	-Name $TestsFolderPath -Verbose | Resolve-Path -OutVariable TestsFolderPath;
			SamplesFolderPath = New-Item -ItemType Directory -Path $SolutionFolderPath -Name $SamplesFolderPath -Verbose | Resolve-Path -OutVariable SamplesFolderPath;
			BuildFolderPath = New-Item -ItemType Directory -Path $SolutionFolderPath -Name $BuildFolderPath -Verbose | Resolve-Path -OutVariable BuildFolderPath;
			ArtifactsFolderPath = New-Item -ItemType Directory -Path $SolutionFolderPath -Name $ArtifactsFolderPath -Verbose | Resolve-Path -OutVariable ArtifactsFolderPath;
			NuGetFolderPath = New-Item -ItemType Directory -Path $SourceFolderPath 	-Name $NuGetFolderPath -Verbose | Resolve-Path -OutVariable NuGetFolderPath;
			NuGetPackagesFolderPath = New-Item -ItemType Directory -Path $NuGetFolderPath -Name $NuGetPackagesFolderPath -Verbose | Resolve-Path -OutVariable NuGetPackagesFolderPath;
		}
		New-Object -Type PSObject -Property $solutionFolderStructure
	}
}