    #
    # A solution is a combination of projects that have a common lifecycle. That means all projects within it
    # share a GitHub repository, development workflow, release strategy, SemVer versioning etc...
    #

    Set-Variable -Name SourcesDirectoryName       -Value 'src'       -Option Constant
    Set-Variable -Name DocumentationDirectoryName -Value 'docs' 	  -Option Constant
    Set-Variable -Name TestsDirectoryName         -Value 'tests' 	  -Option Constant
    Set-Variable -Name SamplesDirectoryName       -Value 'samples'   -Option Constant
    Set-Variable -Name BuildDirectoryName         -Value 'build' 	  -Option Constant
    Set-Variable -Name ArtifactsDirectoryName     -Value 'artifacts' -Option Constant
    Set-Variable -Name NugetDirectoryName         -Value '.nuget'    -Option Constant
    Set-Variable -Name NugetPackagesDirectoryName -Value 'packages'  -Option Constant

    #Import-Module -Name GitHubShell			    
    #Import-Module -Name GitFlowShell
    #Import-Module -Name SolutionShell

    Import-Module -Name (Join-Path -Path $PSScriptRoot -ChildPath 'Git.psm1')
    Import-Module -Name (Join-Path -Path $PSScriptRoot -ChildPath 'GitHub.psm1')
    Import-Module -Name (Join-Path -Path $PSScriptRoot -ChildPath 'DependencyManagement.psm1')

    enum DevelopmentWorkflow
    {
	    GitFlow
    }

    class DirectoryStructure
    {
	    [System.IO.DirectoryInfo]$RootDirectoryInfo;
	    [System.IO.DirectoryInfo]$DocumentationDirectoryInfo;
	    [System.IO.DirectoryInfo]$SourcesDirectoryInfo;
	    [System.IO.DirectoryInfo]$TestsDirectoryInfo;
	    [System.IO.DirectoryInfo]$SamplesDirectoryInfo;
	    [System.IO.DirectoryInfo]$BuildDirectoryInfo;
	    [System.IO.DirectoryInfo]$ArtifactsDirectoryInfo;
	    [System.IO.DirectoryInfo]$NuGetDirectoryInfo;
	    [System.IO.DirectoryInfo]$NuGetPackagesDirectoryInfo;
    }

    Function New-eVisionSolution
    {
        [OutputType([Solution])]
	    [CmdletBinding()]
	    Param
	    (
		    [Parameter(Mandatory = $true)]
		    [String] $SolutionName,
		    [Parameter(Mandatory = $true)]
		    [System.IO.DirectoryInfo] $Path
 	    )
        $gitHibRepository = New-GitHubRepository -Name $SolutionName -OrganizationName eVisionSoftware -GitIgnoreTemplate VisualStudio -HasWiki -HasIssues -HasDownloads -AutoInit
         {New-GitHubRepository -Name $SolutionName -GitIgnoreTemplate VisualStudio -HasWiki -HasIssues -HasDownloads -AutoInit} 
         
    }

    Function Initialize-Solution 
    {
        [OutputType([Solution])]
	    [CmdletBinding()]
	    Param
	    (
		    [Parameter(Mandatory = $true)]
		    [String] $SolutionName,
		    [Parameter(Mandatory = $true)]
		    [DirectoryStructure] $DirectoryStructure,
		    [Parameter(Mandatory = $true)]
		    [DevelopmentWorkflow] $DevelopmentWorkflow
 	    )
	    Process	
	    {	
            Initialize-Git -DirectoryStructure $DirectoryStructure
            Initialize-GitFlow -Path $DirectoryStructure
            	     
		    $useNuGetOrg = 
		    @{
			    Source = 'nuget.org';
			    ProviderName = 'NuGet';
			    Destination = $DirectoryStructure.NuGetPackagesDirectoryDirectoryInfo;
			    Force = $true
		    }

			Invoke-WebRequest -Uri 'https://nuget.org/nuget.exe' -OutFile (Join-Path -Path $DirectoryStructure.NuGetFolderDirectoryInfo.FullName -ChildPath 'nuget.exe') -Verbose

            # assuming semantic versioning
		    Install-Package -Name psake -MinimumVersion 4.4.2 -MaximumVersion 4.9.9 @useNuGetOrg
		    Install-Package -Name GitVersion.CommandLine -MinimumVersion 3.1.2 -MaximumVersion 3.9.9 @useNuGetOrg
		    Install-Package -Name gitreleasemanager -MinimumVersion 0.3.0 -MaximumVersion 1.0.0 @useNuGetOrg
		    Install-Package -Name xunit.runner.console -MinimumVersion 2.0.0 -MaximumVersion 2.9.9 @useNuGetOrg
		    Install-Package -Name ILRepack -MinimumVersion 2.0.5 -MaximumVersion 2.9.9 @useNuGetOrg
		    Install-Package -Name JetBrains.dotCover.CommandLineTools -MinimumVersion 3.2.2 -MaximumVersion 3.9.9 @useNuGetOrg
            Install-Package -Name Nuget.CommandLine -MinimumVersion 2.8.6 -MaximumVersion 2.9.9 @useNugetOrg
			        
            $Solution = [Solution]::New()
            $Solution.Name = $SolutionName
            $Solution.DirectoryStructure = $DirectoryStructure
            $Solution.GitHubRepository = $GitHubRepository

            return $Solution
	    }
    }

	class Solution
    {
        [DirectoryStructure] $DirectoryStructure
        [String] $Name
        [PSCustomObject] $GitHubRepository
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
		[OutputType([Solution])]
	    [CmdletBinding(DefaultParameterSetName='JoinAsUser')]
	    Param 
        (
		    [Parameter(Mandatory = $true)]
		    [String] $SolutionName,
            [Parameter(Mandatory = $true)]
		    [System.IO.DirectoryInfo] $Path,
		    [Parameter(Mandatory = $true)]
		    [string] $GitHubOwnerName,
            [Parameter(Mandatory = $true, ParameterSetName='JoinAsOrganization')]
            [string] $GitHubOrganizationName
	    )
	    Process	
	    {	
            $forkParameters = 
            @{
                Owner = $GitHubOwnerName
                RepositoryName = $SolutionName
            }

            switch ($PsCmdlet.ParameterSetName) 
		    {
			    'JoinAsOrganization' 
			    {
				    $forkParameters.Add('OrganizationName', $GitHubOrganizationName)			
			    }
		    }

            $ForkOfGitHubRepository = New-GitHubFork @forkParameters

		    $cloneOfFork = Clone-GitHubRepository -OwnerName $GitHubOwnerName -RepositoryName $ForkOfGitHubRepository.Name
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

    Function New-DirectoryStructure 
    {
	    [OutputType([DirectoryStructure])]
	    [CmdletBinding()]
	    param(
		    [Parameter(Mandatory = $true)]
		    [string] $SolutionName,
		    [Parameter(Mandatory = $true)]
		    [System.IO.DirectoryInfo] $Path
	    )
	    Process	
	    {	
		    $DirectoryStructure = [DirectoryStructure]::New() 
		    @{	
			    SolutionDirectoryDirectoryInfo = New-Item -ItemType Directory -Path $Path.FullName -Name $SolutionName -Verbose -Force -OutVariable SolutionDirectoryPath;
			    DocumentationDirectoryDirectoryInfo = New-Item -ItemType Directory -Path $SolutionDirectoryPath.FullName -Name $DocumentationDirectoryName -Verbose -Force;
			    SourcesDirectoryDirectoryInfo = New-Item -ItemType Directory -Path $SolutionDirectoryPath.FullName -Name $SourcesDirectoryName -Verbose -Force -OutVariable SourcesDirectoryPath;
			    TestsDirectoryDirectoryInfo = New-Item -ItemType Directory -Path $SolutionDirectoryPath.FullName -Name $TestsDirectoryName -Verbose -Force;
			    SamplesDirectoryDirectoryInfo = New-Item -ItemType Directory -Path $SolutionDirectoryPath.FullName -Name $SamplesDirectoryName -Verbose -Force;
			    BuildDirectoryDirectoryInfo = New-Item -ItemType Directory -Path $SolutionDirectoryPath.FullName -Name $BuildDirectoryName -Verbose -Force;
			    ArtifactsDirectoryDirectoryInfo = New-Item -ItemType Directory -Path $SolutionDirectoryPath.FullName -Name $ArtifactsDirectoryName -Verbose -Force;
			    NuGetDirectoryDirectoryInfo = New-Item -ItemType Directory -Path $SourcesDirectoryPath.FullName -Name $NuGetDirectoryName -Verbose -Force;
			    NuGetPackagesDirectoryDirectoryInfo = New-Item -ItemType Directory -Path $SolutionDirectoryPath.FullName -Name $NuGetPackagesDirectoryName -Verbose -Force;
		    }
	    }
    }