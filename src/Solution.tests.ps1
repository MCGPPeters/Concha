#
# This is a PowerShell Unit Test file.
# You need a unit test framework such as Pester to run PowerShell Unit tests. 
# You can download Pester from http://go.microsoft.com/fwlink/?LinkID=534084
#

Import-Module .\src\Solution.psm1

Describe "Creating the .NET folder structure" {

	$projectName = "GreenField"
	$path = 'TestDrive:\'

	Context "When the structure does not exist" {

		New-DotNetProjectStructure -ProjectName $projectName -Path $path

		function Assert-ThatProjectFolderExists{
			param(
				[Parameter(Mandatory = $true)]
				[string] $ProjectFolder
			)
			Join-Path -Path "$path\$projectName" -ChildPath $ProjectFolder | Should Exist
		}
	
		It "should create a root folder named after the project name"{
			Join-Path -Path $path -ChildPath $projectName | Should Exist
		}

		It "creates a docs subfolder" {
			Assert-ThatProjectFolderExists "docs"
		}

		It "creates a src subfolder" {
			Assert-ThatProjectFolderExists "src"
		}

		It "creates a samples subfolder" {			
			Assert-ThatProjectFolderExists "samples"
		}

		It "creates a build subfolder" {
			Assert-ThatProjectFolderExists "build"
		}

		It "creates a tools subfolder" {
			Assert-ThatProjectFolderExists "tools"
		}

		It "creates a packages subfolder" {
			Assert-ThatProjectFolderExists "packages"
		}
	}
}

Remove-Module Solution