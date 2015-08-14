#
# This is a PowerShell Unit Test file.
# You need a unit test framework such as Pester to run PowerShell Unit tests. 
# You can download Pester from http://go.microsoft.com/fwlink/?LinkID=534084
#

Import-Module .\src\GitHub.psm1

$accessToken =  [Environment]::GetEnvironmentVariable('github_access_token', 'User')
$organizationName = "GitHubAPITesting"
$repositoryNameForUser = "integrationTestRepositoryUsingGitHubAPIForUser"
$repositoryNameForOrganization = "integrationTestRepositoryUsingGitHubAPIForOrganization"

Describe "Creating a new GitHub repository" {
	
	Context "For a user" {

		New-GitHubRepository -AccessToken $accessToken -Name $repositoryNameForUser -AutoInit -OutVariable  result

		$login = $result.owner.login

		It "creates the repository on GitHub" {
			$result.clone_url | Should Be "https://github.com/$login/$repositoryNameForUser.git"
		}
	}
	
	Context "For an organization" {
	
		New-GitHubRepository -AccessToken $accessToken -Name $repositoryNameForOrganization -OrganizationName $organizationName -AutoInit -OutVariable result
	
		It "Creates the repository on GitHub" {
			$result.clone_url | Should Be "https://github.com/$organizationName/$repositoryNameForOrganization.git"
		}
	}
}

Describe "Forking a GitHub repository" {
	
	Context "From an existing repository" {

		New-GitHubFork -AccessToken $accessToken -Owner $organizationName -RepositoryName $repositoryNameForOrganization -OutVariable result

		$login = $result.owner.login

		It "Creates a fork on GitHub" {
			$result.clone_url | Should Be "https://github.com/$login/$repositoryNameForOrganization.git"
		}
	}

	Context "From an existing repository into an organization" {

		$organizationNameForForking = ($organizationName + "Forks")

		New-GitHubFork -AccessToken $accessToken -Owner $organizationName -RepositoryName $repositoryNameForOrganization -OrganizationName $organizationNameForForking  -OutVariable result

		It "Creates a fork on GitHub into the organization" {
			$result.clone_url | Should Be "https://github.com/$organizationNameForForking/$repositoryNameForOrganization.git"
		}
	}
}

Remove-Module GitHub