#
# This is a PowerShell Unit Test file.
# You need a unit test framework such as Pester to run PowerShell Unit tests. 
# You can download Pester from http://go.microsoft.com/fwlink/?LinkID=534084
#

Describe "Initialize-GitHubRepository" {
	Context "When the repository does not exist" {
		It "creates the repository locally in the current folder" {
			$actual | Should Be $null
		}
	}
}