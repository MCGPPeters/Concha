#
# This is a PowerShell Unit Test file.
# You need a unit test framework such as Pester to run PowerShell Unit tests. 
# You can download Pester from http://go.microsoft.com/fwlink/?LinkID=534084
#

Describe "New-GitHubRepository" {
	Context "When the repository for the user does not exist" {
		It "creates the repository on GitHub" {
			$actual | Should Be $null
		}
	}
}

Describe "New-GitHubRepositoryForOrganization" {
	Context "When the repository for the organization does not exist" {
		It "creates the repository on GitHub" {
			$actual | Should Be $null
		}
	}
}