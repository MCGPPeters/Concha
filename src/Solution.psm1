#
# A solution is a combination of projects that have a common lifecycle. That means all projects within it
# share a GitHub repository, development workflow, release strategy, SemVer versioning etc...
#

Set-Variable -Name SourcesFolderName       -Value 'src'       -Option Constant
Set-Variable -Name DocumentationFolderName -Value 'docs' 	  -Option Constant
Set-Variable -Name TestsFolderName         -Value 'tests' 	  -Option Constant
Set-Variable -Name SamplesFolderName       -Value 'samples'   -Option Constant
Set-Variable -Name BuildFolderName         -Value 'build' 	  -Option Constant
Set-Variable -Name ArtifactsFolderName     -Value 'artifacts' -Option Constant
Set-Variable -Name NugetFolderName         -Value '.nuget'    -Option Constant
Set-Variable -Name NugetPackagesFolderName -Value 'packages'  -Option Constant

#Import-Module -Name GitHubShell			    
#Import-Module -Name GitFlowShell
#Import-Module -Name SolutionShell

Import-Module .\GitHub.psm1

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
		[System.IO.DirectoryInfo] $Path,
		[Parameter(Mandatory = $true)]
		[ValidateSet('gitflow')]
		[string] $DevelopmentWorkflow,
		[Parameter(Mandatory = $false)]
		[System.Func[[System.IO.DirectoryInfo], [String], [SolutionFolderStructure]]] $CreateSolutionStructure = {New-SolutionFolderStructure -SolutionName $SolutionName -Path $Path} ,
		[Parameter(Mandatory = $true, ParameterSetName='organization')]
		[string] $OrganizationName
 	)
	Process	
	{
		$solutionFolderStructure = $CreateSolutionStructure.Invoke($SolutionName, $Path)
			     
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
		Install-Package -Name JetBrains.dotCover.CommandLineTools -MinimumVersion 3.2.2 -MaximumVersion 3.9.9 @useNuGetOrg

		Invoke-WebRequest 'https://nuget.org/nuget.exe' -OutFile (Join-Path -Path $solutionFolderStructure.NuGetFolderPath -ChildPath 'nuget.exe') -Verbose

		Initialize-GitFlow -Path $Path
				
		New-GitHubRepository -Name $SolutionName

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
	[OutputType([SolutionFolderStructure])]
	[CmdletBinding()]
	param(
		[Parameter(Mandatory = $true)]
		[string] $SolutionName,
		[Parameter(Mandatory = $true)]
		[System.IO.DirectoryInfo] $Path
	)
	Process	
	{	
		$solutionFolderStructure = [SolutionFolderStructure]::New() 
		@{	
			SolutionFolderPathInfo = New-Item -ItemType Directory -Path $Path.FullName -Name $SolutionName -Verbose -Force | Resolve-Path -OutVariable SolutionFolderPath;
			DocumentationFolderPathInfo = New-Item -ItemType Directory -Path $SolutionFolderPath -Name $DocsFolderName -Verbose -Force;
			SourcesFolderPathInfo = New-Item -ItemType Directory -Path $SolutionFolderPath -Name $SourcesFolderName -Verbose -Force | Resolve-Path -OutVariable SourcesFolderPath;
			TestsFolderPathInfo = New-Item -ItemType Directory -Path $SolutionFolderPath -Name $TestsFolderName -Verbose -Force;
			SamplesFolderPathInfo = New-Item -ItemType Directory -Path $SolutionFolderPath -Name $SamplesFolderName -Verbose -Force;
			BuildFolderPathInfo = New-Item -ItemType Directory -Path $SolutionFolderPath -Name $BuildFolderName -Verbose -Force;
			ArtifactsFolderPathInfo = New-Item -ItemType Directory -Path $SolutionFolderPath -Name $ArtifactsFolderName -Verbose -Force;
			NuGetFolderPathInfo = New-Item -ItemType Directory -Path $SourcesFolderPath -Name $NuGetFolderName -Verbose -Force;
			NuGetPackagesFolderPathInfo = New-Item -ItemType Directory -Path $SolutionFolderPath -Name $NuGetPackagesFolderName -Verbose -Force;
		}
	}
}

class SolutionFolderStructure
{
	[System.Management.Automation.PathInfo]$SolutionFolderPathInfo;
	[System.Management.Automation.PathInfo]$DocumentationFolderPathInfo;
	[System.Management.Automation.PathInfo]$SourcesFolderPathInfo;
	[System.Management.Automation.PathInfo]$TestsFolderPathInfo;
	[System.Management.Automation.PathInfo]$SamplesFolderPathInfo;
	[System.Management.Automation.PathInfo]$BuildFolderPathInfo;
	[System.Management.Automation.PathInfo]$ArtifactsFolderPathInfo;
	[System.Management.Automation.PathInfo]$NuGetFolderPathInfo;
	[System.Management.Automation.PathInfo]$NuGetPackagesFolderPathInfo;
}