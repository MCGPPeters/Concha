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
	
			It "should create a root folder named after the project name"{
				Join-Path -Path $path -ChildPath $projectName | Should Exist
			}

			It "creates a docs subfolder" {
				Join-Path -Path "$path\$projectName" -ChildPath "docs" | Should Exist
			}

			It "creates a src subfolder" {
				Join-Path -Path "$path\$projectName" -ChildPath "src" | Should Exist
			}

			It "creates a samples subfolder" {			
				Join-Path -Path "$path\$projectName" -ChildPath "samples" | Should Exist
			}

			It "creates a build subfolder" {
				Join-Path -Path "$path\$projectName" -ChildPath "build" | Should Exist
			}

			It "creates a tools subfolder" {
				Join-Path -Path "$path\$projectName" -ChildPath "tools" | Should Exist
			}

			It "creates a packages subfolder" {
				Join-Path -Path "$path\$projectName" -ChildPath "packages" | Should Exist
			}
	}
}

Remove-Module Solution