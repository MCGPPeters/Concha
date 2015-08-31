#
# This is a PowerShell Unit Test file.
# You need a unit test framework such as Pester to run PowerShell Unit tests. 
# You can download Pester from http://go.microsoft.com/fwlink/?LinkID=534084
#


$scriptPath = $MyInvocation.MyCommand.Path
$currentFolder = Split-Path $scriptPath

Import-Module $currentFolder\Solution.psm1
Import-Module $currentFolder\GitHub.psm1


$SolutionName = "GreenField"
$path = 'TestDrive:\'

Describe "Create the .NET Solution structure" {
	
	$expectedSolutionPath = Join-Path -Path $path -ChildPath $SolutionName
	
	$expectedDocumentationPath = Join-Path -Path $expectedSolutionPath -ChildPath "docs"
	$expectedSourceFolderPath = Join-Path -Path $expectedSolutionPath -ChildPath "src"
	$expectedSamplesFolderPath = Join-Path -Path $expectedSolutionPath -ChildPath "samples"
	$expectedBuildFolderPath = Join-Path -Path $expectedSolutionPath -ChildPath "build"
	$expectedArtifactsFolderPath = Join-Path -Path $expectedSolutionPath -ChildPath "artifacts"
	$expectedTestsFolderPath = Join-Path -Path $expectedSolutionPath -ChildPath "tests"
	$expectedNuGetFolderPath = Join-Path -Path $expectedSolutionPath -ChildPath ".nuget"
	$expectedPackagesFolderPath = Join-Path -Path $expectedSolutionPath -ChildPath "packages"
	$expectedNuGetConfigPath = Join-Path -Path $expectedNuGetFolderPath -ChildPath  "NuGet.Config"
	$absoluteNuGetConfigPath = Join-Path -Path $TestDrive -ChildPath (Split-Path -Path $expectedNuGetConfigPath -noQualifier)

	Context "When the structure does not exist" {

		New-DotNetSolutionStructure -SolutionName $SolutionName -Path $path

		It "should create a root Path named after the Solution name"{
			$expectedSolutionPath | Should Exist
		}

		It "creates a docs sub folder" {
			$expectedDocumentationPath | Should Exist
		}

		It "creates a src sub folder" {
			$expectedSourceFolderPath | Should Exist
		}

		It "creates a samples sub folder" {			
			$expectedSamplesFolderPath | Should Exist
		}

		It "creates a build sub folder" {
			$expectedBuildFolderPath | Should Exist
		}

		It "creates a tests sub folder" {
			$expectedTestsFolderPath | Should Exist
		}
		
		It "creates a artifacts sub folder" {
			$expectedArtifactsFolderPath | Should Exist
		}

		It "creates a .NuGet sub folder in de src path" {
			$expectedNuGetFolderPath | Should Exist
		}

		It "creates a packages sub folder in de src path" {
			$expectedPackagesFolderPath | Should Exist
		}

		It "should ensure that a NuGet.Config is present" {
			$expectedNuGetConfigPath | Should Exist
		}

		It "should ensure that sourcecontrol integration for NuGet is disabled" {
			$NuGetConfig = New-Object XML
			$NuGetConfig.Load($absoluteNuGetConfigPath)

			$isSourceControlEnabled = -Not (($NuGetConfig.configuration.solution.add | Where-Object { $_.GetAttribute("key") -match "disableSourceControlIntegration" }).value)

			$isSourceControlEnabled | Should be $false
		}
		
		It "should ensure that NuGet.org is added as a package source" {
			$NuGetConfig = New-Object XML
			$NuGetConfig.Load($absoluteNuGetConfigPath)

			$NugetOrgPackageSource = ($NuGetConfig.configuration.packageSources.add | Where-Object { $_.GetAttribute("key") -match "nuget.org" }).value

			$NugetOrgPackageSource | Should be "https://www.nuget.org/api/v2/"
		}
	}
}

Describe "Start a open source .NET Solution" {

	$dotNetSolution = New-Solution -SolutionName $SolutionName -Path $path -BranchingModel gitflow


	Remove-GitHubRepository -AccessToken $accessToken -Owner $login -RepositoryName $temporaryRepositoryName -OutVariable result
}

Remove-Module GitHub
Remove-Module Solution