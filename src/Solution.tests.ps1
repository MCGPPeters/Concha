#
# This is a PowerShell Unit Test file.
# You need a unit test framework such as Pester to run PowerShell Unit tests. 
# You can download Pester from http://go.microsoft.com/fwlink/?LinkID=534084
#

$scriptpath = $MyInvocation.MyCommand.Path
$dir = Split-Path $scriptpath

Import-Module $dir\Solution.psm1

Describe "Creating the .NET Path structure" {

	$projectName = "GreenField"
	$path = 'TestDrive:\'

	$expectedProjectPath = Join-Path -Path $path -ChildPath $projectName
	
	$expectedDocumentationPath = Join-Path -Path $expectedProjectPath -ChildPath "docs"
	$expectedSourcePath = Join-Path -Path $expectedProjectPath -ChildPath "src"
	$expectedSamplesPath = Join-Path -Path $expectedProjectPath -ChildPath "samples"
	$expectedBuildPath = Join-Path -Path $expectedProjectPath -ChildPath "build"
	
	$expectedToolsPath = Join-Path -Path $expectedProjectPath -ChildPath "tools"
	$expectedNuGetPath = Join-Path -Path $expectedToolsPath -ChildPath ".NuGet"
	$expectedNuGetExePath = Join-Path -Path $expectedNuGetPath -ChildPath  "NuGet.Exe"
	$expectedNuGetConfigPath = Join-Path -Path $expectedNuGetPath -ChildPath  "NuGet.Config"
	$absoluteNuGetConfigPath = Join-Path -Path $TestDrive -ChildPath (Split-Path -Path $expectedNuGetConfigPath -noQualifier)

	Context "When the structure does not exist" {

		New-DotNetProjectStructure -ProjectName $projectName -Path $path

		It "should create a root Path named after the project name"{
			$expectedProjectPath | Should Exist
		}

		It "creates a docs subPath" {
			$expectedDocumentationPath | Should Exist
		}

		It "creates a src subPath" {
			$expectedSourcePath | Should Exist
		}

		It "creates a samples subPath" {			
			$expectedSamplesPath | Should Exist
		}

		It "creates a build subPath" {
			$expectedBuildPath | Should Exist
		}

		It "creates a tools subPath" {
			$expectedToolsPath | Should Exist
		}

		It "creates a .NuGet subPath in de tools Path" {
			$expectedNuGetPath | Should Exist
		}

		It "adds NuGet.exe to the .NuGet Path" {
			$expectedNuGetExePath | Should Exist
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

Remove-Module Solution