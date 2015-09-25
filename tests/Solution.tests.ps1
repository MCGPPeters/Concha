#
# This is a PowerShell Unit Test file.
# You need a unit test framework such as Pester to run PowerShell Unit tests. 
# You can download Pester from http://go.microsoft.com/fwlink/?LinkID=534084
#


$scriptPath = $MyInvocation.MyCommand.Path
$currentDirectory = Split-Path $scriptPath

Import-Module $currentDirectory\Solution.psm1

$SolutionName = "GreenField"
$path = 'TestDrive:\'

Describe "Create a new solution" {
	
	$expectedSolutionPath = Join-Path -Path $path -ChildPath $SolutionName
	
	$expectedDocumentationPath = Join-Path -Path $expectedSolutionPath -ChildPath "docs"
	$expectedSourceDirectoryPath = Join-Path -Path $expectedSolutionPath -ChildPath "src"
	$expectedSamplesDirectoryPath = Join-Path -Path $expectedSolutionPath -ChildPath "samples"
	$expectedBuildDirectoryPath = Join-Path -Path $expectedSolutionPath -ChildPath "build"
	$expectedArtifactsDirectoryPath = Join-Path -Path $expectedSolutionPath -ChildPath "artifacts"
	$expectedTestsDirectoryPath = Join-Path -Path $expectedSolutionPath -ChildPath "tests"
	$expectedNuGetDirectoryPath = Join-Path -Path $expectedSolutionPath -ChildPath ".nuget"
	$expectedPackagesDirectoryPath = Join-Path -Path $expectedSolutionPath -ChildPath "packages"
	$expectedNuGetConfigPath = Join-Path -Path $expectedNuGetDirectoryPath -ChildPath  "NuGet.Config"
	$absoluteNuGetConfigPath = Join-Path -Path $TestDrive -ChildPath (Split-Path -Path $expectedNuGetConfigPath -noQualifier)

	Context "When the structure does not exist" {

		New-DotNetSolutionStructure -SolutionName $SolutionName -Path $path

		It "should create a root Path named after the Solution name"{
			$expectedSolutionPath | Should Exist
		}

		It "creates a docs sub directory" {
			$expectedDocumentationPath | Should Exist
		}

		It "creates a src sub directory" {
			$expectedSourceDirectoryPath | Should Exist
		}

		It "creates a samples sub directory" {			
			$expectedSamplesirectoryPath | Should Exist
		}

		It "creates a build sub directory" {
			$expectedBuildDirectoryPath | Should Exist
		}

		It "creates a tests sub directory" {
			$expectedTestsDirectoryPath | Should Exist
		}
		
		It "creates a artifacts sub directory" {
			$expectedArtifactsDirectoryPath | Should Exist
		}

		It "creates a .NuGet sub directory in de src path" {
			$expectedNuGetDirectoryPath | Should Exist
		}

		It "creates a packages sub directory in de src path" {
			$expectedPackagesDirectoryPath | Should Exist
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

Remove-Module Solution