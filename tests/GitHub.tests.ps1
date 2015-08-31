#
# This is a PowerShell Unit Test file.
# You need a unit test framework such as Pester to run PowerShell Unit tests. 
# You can download Pester from http://go.microsoft.com/fwlink/?LinkID=534084
#

$scriptpath = $MyInvocation.MyCommand.Path
$dir = Split-Path $scriptpath

Import-Module $dir\GitHub.psm1

$accessToken =  [Environment]::GetEnvironmentVariable('github_access_token', 'User')
$organizationName = "GitHubAPITesting"
$repositoryNameForUser = "integrationTestRepositoryUsingGitHubAPIForUser"
$repositoryNameForOrganization = "integrationTestRepositoryUsingGitHubAPIForOrganization"

Describe "Creating a new GitHub repository" {
	
	Context "For a user" {

		New-GitHubRepository -AccessToken $accessToken -Name $repositoryNameForUser -AutoInit -OutVariable gitHubRepository -Verbose

		$login = $gitHubRepository.owner.login

		It "creates the repository on GitHub" {
			$gitHubRepository.clone_url | Should Be "https://github.com/$login/$repositoryNameForUser.git"
		}

		Remove-GitHubRepository -AccessToken $accessToken -Owner $login -RepositoryName $repositoryNameForUser
	}
	
	Context "For an organization" {
	
		New-GitHubRepository -AccessToken $accessToken -Name $repositoryNameForOrganization -OrganizationName $organizationName -AutoInit -OutVariable gitHubRepository
	
		It "Creates the repository on GitHub" {
			$gitHubRepository.clone_url | Should Be "https://github.com/$organizationName/$repositoryNameForOrganization.git"
		}

		Remove-GitHubRepository -AccessToken $accessToken -Owner $organizationName -RepositoryName $repositoryNameForOrganization
	}
}

Describe "Forking a GitHub repository" {
	
	Context "From an existing repository" {

		New-GitHubRepository -AccessToken $accessToken -Name $repositoryNameForOrganization -OrganizationName $organizationName -AutoInit
		New-GitHubFork -AccessToken $accessToken -Owner $organizationName -RepositoryName $repositoryNameForOrganization -OutVariable gitHubFork

		$login = $gitHubFork.owner.login

		It "Creates a fork on GitHub" {
			$gitHubFork.clone_url | Should Be "https://github.com/$login/$repositoryNameForOrganization.git"
		}

		Remove-GitHubRepository -AccessToken $accessToken -Owner $login -RepositoryName $repositoryNameForOrganization
	}

	Context "From an existing repository into an organization" {

		$organizationNameForForking = ($organizationName + "Forks")

		New-GitHubRepository -AccessToken $accessToken -Name $repositoryNameForOrganization -OrganizationName $organizationName -AutoInit
		New-GitHubFork -AccessToken $accessToken -Owner $organizationName -RepositoryName $repositoryNameForOrganization -OrganizationName $organizationNameForForking  -OutVariable gitHubFork

		It "Creates a fork on GitHub into the organization" {
			$gitHubFork.clone_url | Should Be "https://github.com/$organizationNameForForking/$repositoryNameForOrganization.git"
		}

		Remove-GitHubRepository -AccessToken $accessToken -Owner $organizationName -RepositoryName $repositoryNameForOrganization
		Remove-GitHubRepository -AccessToken $accessToken -Owner $organizationNameForForking -RepositoryName $repositoryNameForOrganization
	}
}

Describe "Deleting a GitHub repository" {
	
	$temporaryRepositoryName = "temporaryRepositoryForTestingTheGitHubAPI"
	New-GitHubRepository -AccessToken $accessToken -Name $temporaryRepositoryName -OutVariable gitHubRepository
	$login = $gitHubRepository.owner.login

	Context "When the repository exists" {

		Remove-GitHubRepository -AccessToken $accessToken -Owner $login -RepositoryName $temporaryRepositoryName -OutVariable result

		It "Deletes the repository from GitHub" {
			$result.StatusCode | Should Be 204
		}
	}
}

Remove-Module GitHub