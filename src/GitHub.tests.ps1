#
# This is a PowerShell Unit Test file.
# You need a unit test framework such as Pester to run PowerShell Unit tests. 
# You can download Pester from http://go.microsoft.com/fwlink/?LinkID=534084
#

Import-Module .\src\GitHub.psm1

$accessToken =  [Environment]::GetEnvironmentVariable('github_access_token', 'User')
$organizationName = "GitHubAPITesting"
$name = "integrationTestRepositoryUsingGitHubAPI"

Describe "Creating a new GitHub repository" {
	
	Context "For a user" {

		New-GitHubRepository -AccessToken $accessToken -Name $name -OutVariable repository

		$login = $repository.owner.login

		It "creates the repository on GitHub" {
			$repository.clone_url | Should Be "https://github.com/$login/$name.git"
		}
	}
	
	Context "For an organization" {
	
		New-GitHubRepository -AccessToken $accessToken -Name $name -OrganizationName $organizationName -OutVariable repository
	
		It "creates the repository on GitHub" {
			$repository.clone_url | Should Be "https://github.com/$organizationName/$name.git"
		}
	}
}

Remove-Module GitHub