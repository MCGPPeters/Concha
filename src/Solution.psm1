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

enum DevelopmentWorkflow
{
	GitFlow
}

class SolutionName
{
	[String]$Name;
	
	SolutionName([String] $Name)
	{
		$this.Name = $Name
	}
}

class SolutionFolderStructure
{
	[System.IO.DirectoryInfo]$SolutionFolderDirectoryInfo;
	[System.IO.DirectoryInfo]$DocumentationFolderDirectoryInfo;
	[System.IO.DirectoryInfo]$SourcesFolderDirectoryInfo;
	[System.IO.DirectoryInfo]$TestsFolderDirectoryInfo;
	[System.IO.DirectoryInfo]$SamplesFolderDirectoryInfo;
	[System.IO.DirectoryInfo]$BuildFolderDirectoryInfo;
	[System.IO.DirectoryInfo]$ArtifactsFolderDirectoryInfo;
	[System.IO.DirectoryInfo]$NuGetFolderDirectoryInfo;
	[System.IO.DirectoryInfo]$NuGetPackagesFolderDirectoryInfo;
}

Function New-Solution 
{
	[CmdletBinding()]
	Param
	(
		[Parameter(Mandatory = $true)]
		[string] $SolutionName,
		[Parameter(Mandatory = $true)]
		[System.IO.DirectoryInfo] $Path,
		[Parameter(Mandatory = $true)]
		[DevelopmentWorkflow] $DevelopmentWorkflow,
		[Parameter(Mandatory = $false)]
		[System.Func[[System.IO.DirectoryInfo], [string], [SolutionFolderStructure]]] $SolutionStructureFactory = {New-SolutionFolderStructure -SolutionName $SolutionName -Path $Path}
 	)
	Process	
	{
		$solutionFolderStructure = $SolutionStructureFactory.Invoke($SolutionName, $Path)
			     
		$useNuGetOrg = 
		@{
			Source = 'nuget.org';
			ProviderName = 'NuGet';
			Destination = $solutionFolderStructure.NuGetPackagesFolderDirectoryInfo;
			Force = $true
		}

		Install-Package -Name psake -MinimumVersion 4.4.2 -MaximumVersion 4.9.9 @useNuGetOrg
		Install-Package -Name nuget.commandline -MinimumVersion 2.8.6 -MaximumVersion 2.9.9 @useNuGetOrg
		Install-Package -Name GitVersion.CommandLine -MinimumVersion 3.1.2 -MaximumVersion 3.9.9 @useNuGetOrg
		Install-Package -Name gitreleasemanager -MinimumVersion 0.3.0 -MaximumVersion 1.0.0 @useNuGetOrg
		Install-Package -Name xunit.runner.console -MinimumVersion 2.0.0 -MaximumVersion 2.9.9 @useNuGetOrg
		Install-Package -Name ILRepack -MinimumVersion 2.0.5 -MaximumVersion 2.9.9 @useNuGetOrg
		Install-Package -Name JetBrains.dotCover.CommandLineTools -MinimumVersion 3.2.2 -MaximumVersion 3.9.9 @useNuGetOrg

		Invoke-WebRequest -Uri 'https://nuget.org/nuget.exe' -OutFile (Join-Path -Path $solutionFolderStructure.NuGetFolderDirectoryInfo.FullName -ChildPath 'nuget.exe') -Verbose
		Initialize-GitFlow -Path $Path
				
		New-GitHubRepository -Name $SolutionName

	}
}

Function Join-Solution 
{
	[CmdletBinding()]
	Param (
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
			SolutionFolderDirectoryInfo = New-Item -ItemType Directory -Path $Path.FullName -Name $SolutionName -Verbose -Force -OutVariable SolutionFolderPath;
			DocumentationFolderDirectoryInfo = New-Item -ItemType Directory -Path $SolutionFolderPath.FullName -Name $DocsFolderName -Verbose -Force;
			SourcesFolderDirectoryInfo = New-Item -ItemType Directory -Path $SolutionFolderPath.FullName -Name $SourcesFolderName -Verbose -Force -OutVariable SourcesFolderPath;
			TestsFolderDirectoryInfo = New-Item -ItemType Directory -Path $SolutionFolderPath.FullName -Name $TestsFolderName -Verbose -Force;
			SamplesFolderDirectoryInfo = New-Item -ItemType Directory -Path $SolutionFolderPath.FullName -Name $SamplesFolderName -Verbose -Force;
			BuildFolderDirectoryInfo = New-Item -ItemType Directory -Path $SolutionFolderPath.FullName -Name $BuildFolderName -Verbose -Force;
			ArtifactsFolderDirectoryInfo = New-Item -ItemType Directory -Path $SolutionFolderPath.FullName -Name $ArtifactsFolderName -Verbose -Force;
			NuGetFolderDirectoryInfo = New-Item -ItemType Directory -Path $SourcesFolderPath.FullName -Name $NuGetFolderName -Verbose -Force;
			NuGetPackagesFolderDirectoryInfo = New-Item -ItemType Directory -Path $SolutionFolderPath.FullName -Name $NuGetPackagesFolderName -Verbose -Force;
		}
	}
}