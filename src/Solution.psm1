using namespace GitHub
using namespace DependencyManagement
using namespace System.IO
using namespace System.Collections.Generic

namespace Solution
{
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
    Import-Module .\DependencyManagement.psm1

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

    class Solution
    {
        [FolderStructure] $FolderStructure
        [SolutionName] $Name
        [Repository] $GitHubRepository
        #[List[Dependency]] $Dependencies
    }

    class FolderStructure
    {
	    [DirectoryInfo]$SolutionFolderDirectoryInfo;
	    [DirectoryInfo]$DocumentationFolderDirectoryInfo;
	    [DirectoryInfo]$SourcesFolderDirectoryInfo;
	    [DirectoryInfo]$TestsFolderDirectoryInfo;
	    [DirectoryInfo]$SamplesFolderDirectoryInfo;
	    [DirectoryInfo]$BuildFolderDirectoryInfo;
	    [DirectoryInfo]$ArtifactsFolderDirectoryInfo;
	    [DirectoryInfo]$NuGetFolderDirectoryInfo;
	    [DirectoryInfo]$NuGetPackagesFolderDirectoryInfo;
    }

    Function New-Solution 
    {
        [OutputType([Solution])]
	    [CmdletBinding()]
	    Param
	    (
		    [Parameter(Mandatory = $true)]
		    [String] $SolutionName,
		    [Parameter(Mandatory = $true)]
		    [DirectoryInfo] $Path,
		    [Parameter(Mandatory = $true)]
		    [DevelopmentWorkflow] $DevelopmentWorkflow,
		    [Parameter(Mandatory = $false)]
		    [Func[[DirectoryInfo], [String], [FolderStructure]]] $FolderStructureFactory = {New-FolderStructure -SolutionName $SolutionName -Path $Path},
            [Parameter(Mandatory = $false)]
		    [Func[[String], [GitHubRepository]]] $GitHubRepositoryFactory = {New-GitHubRepository -Name $SolutionName -GitIgnoreTemplate VisualStudio -HasWiki -HasIssues -HasDownloads -AutoInit}
 	    )
	    Process	
	    {
            $repository = $GitHubRepositoryFactory.Invoke($SolutionName)

            git clone $repository.CloneUrl $Path

		    $FolderStructure = $FolderStructureFactory.Invoke($SolutionName, $Path)

		    Initialize-GitFlow -Path $Path
			     
		    $useNuGetOrg = 
		    @{
			    Source = 'nuget.org';
			    ProviderName = 'NuGet';
			    Destination = $FolderStructure.NuGetPackagesFolderDirectoryInfo;
			    Force = $true
		    }

            # assuming semantic versioning
		    Install-Package -Name psake -MinimumVersion 4.4.2 -MaximumVersion 4.9.9 @useNuGetOrg
		    Install-Package -Name GitVersion.CommandLine -MinimumVersion 3.1.2 -MaximumVersion 3.9.9 @useNuGetOrg
		    Install-Package -Name gitreleasemanager -MinimumVersion 0.3.0 -MaximumVersion 1.0.0 @useNuGetOrg
		    Install-Package -Name xunit.runner.console -MinimumVersion 2.0.0 -MaximumVersion 2.9.9 @useNuGetOrg
		    Install-Package -Name ILRepack -MinimumVersion 2.0.5 -MaximumVersion 2.9.9 @useNuGetOrg
		    Install-Package -Name JetBrains.dotCover.CommandLineTools -MinimumVersion 3.2.2 -MaximumVersion 3.9.9 @useNuGetOrg
			        
            $solution = [Solution]::New()
            $solution.SolutionName = [SolutionName]::New($SolutionName)
            $solution.FolderStructure = $FolderStructure
            $solution.GitHubRepository = $GitHubRepositoryFactory.Invoke($SolutionName)

            return $Solution
	    }
    }

    Function Add-Dependency
    {
        [CmdletBinding()]
	    Param 
        (
            [Parameter(Mandatory = $true)]
		    [Solution] $Solution,
            [Parameter(Mandatory = $true)]
		    [Dependency] $Dependency
        )
    }

    Function Join-Solution 
    {
	    [CmdletBinding(DefaultParameterSetName='JoinAsUser')]
	    Param 
        (
		    [Parameter(Mandatory = $true)]
		    [String] $SolutionName,
            [Parameter(Mandatory = $true)]
		    [DirectoryInfo] $Path,
		    [Parameter(Mandatory = $true)]
		    [string] $GitHubOwnerName,
		    [Parameter(Mandatory = $false)]
		    [switch] $UseSSH,
            [Parameter(Mandatory = $true, ParameterSetName='JoinAsOrganization')]
            [string] $GitHubOrganizationName
	    )
	    Process	
	    {	
            $forkParameters = 
            @{
                OwnerName = $GitHubOwnerName
                RepositoryName = $SolutionName
            }

            switch ($PsCmdlet.ParameterSetName) 
		    {
			    'JoinAsOrganization' 
			    {
				    $forkParameters.Add('OrganizationName', $GitHubOrganizationName)			
			    }
		    }

            $GitHubRepository = New-GitHubFork @forkParameters

		    if($UseSSH.ToBool() -eq $true) 
		    {
			    $cloneUrl = $GitHubRepository.SshUrl
		    }
		    else 
		    {
			    $cloneUrl = $GitHubRepository.CloneUrl
		    }	
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

    Function New-FolderStructure 
    {
	    [OutputType([FolderStructure])]
	    [CmdletBinding()]
	    param(
		    [Parameter(Mandatory = $true)]
		    [string] $SolutionName,
		    [Parameter(Mandatory = $true)]
		    [DirectoryInfo] $Path
	    )
	    Process	
	    {	
		    $FolderStructure = [FolderStructure]::New() 
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
}