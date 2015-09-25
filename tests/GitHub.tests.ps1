#
# This is a PowerShell Unit Test file.
# You need a unit test framework such as Pester to run PowerShell Unit tests. 
# You can download Pester from http://go.microsoft.com/fwlink/?LinkID=534084
#

$scriptpath = $MyInvocation.MyCommand.Path
$dir = Split-Path $scriptpath

Import-Module -Name (Join-Path -Path $PSScriptRoot\..\src -ChildPath 'GitHub.psm1')

$organizationName = "GitHubAPITesting"
$repositoryNameForUser = "integrationTestRepositoryUsingGitHubAPIForUser"
$repositoryNameForOrganization = "integrationTestRepositoryUsingGitHubAPIForOrganization"

Describe "Creating a new GitHub repository" {
	Context "For a user" {

		try {
			Remove-GitHubRepository -Owner (Get-GitHubAuthenticatedUser).login -RepositoryName $repositoryNameForUser -OutVariable result -Debug -ErrorAction SilentlyContinue

			New-GitHubRepository -Name $repositoryNameForUser -AutoInit -OutVariable gitHubRepository -Verbose

			$login = $gitHubRepository.Owner.Login

			It "creates the repository on GitHub" {
				$gitHubRepository.CloneUrl | Should Be "https://github.com/$login/$repositoryNameForUser.git"
			}
		}
		finally{
			Remove-GitHubRepository -Owner $login -RepositoryName $repositoryNameForUser
		}
	}
	
	Context "For an organization" {

		try {
			New-GitHubRepository -Name $repositoryNameForOrganization -OrganizationName $organizationName -AutoInit -OutVariable gitHubRepository
	
			It "Creates the repository on GitHub" {
				$gitHubRepository.CloneUrl | Should Be "https://github.com/$organizationName/$repositoryNameForOrganization.git"
			}
		}
		finally{
			Remove-GitHubRepository -Owner $gitHubRepository.Owner.Login -RepositoryName $repositoryNameForOrganization
		}
	}
}

Describe "Forking a GitHub repository" {
	
	Context "From an existing repository" {

		try {
			New-GitHubRepository -Name $repositoryNameForOrganization -OrganizationName $organizationName -AutoInit
			New-GitHubFork -Owner $organizationName -RepositoryName $repositoryNameForOrganization -OutVariable gitHubFork

			$login = $gitHubFork.Owner.Login

			It "Creates a fork on GitHub" {

				$gitHubFork.CloneUrl | Should Be "https://github.com/$login/$repositoryNameForOrganization.git"
			}
		}
		finally{
			Remove-GitHubRepository -Owner $organizationName -RepositoryName $repositoryNameForOrganization
			Remove-GitHubRepository -Owner $login -RepositoryName $repositoryNameForOrganization
		}
	}

	Context "From an existing repository into an organization" {

		$organizationNameForForking = ($organizationName + "Forks")

		try{
			New-GitHubRepository -Name $repositoryNameForOrganization -OrganizationName $organizationName -AutoInit
			New-GitHubFork -Owner $organizationName -RepositoryName $repositoryNameForOrganization -OrganizationName $organizationNameForForking  -OutVariable gitHubFork

			It "Creates a fork on GitHub into the organization" {

				$gitHubFork.CloneUrl | Should Be "https://github.com/$organizationNameForForking/$repositoryNameForOrganization.git"
			}
		}
		finally{
			Remove-GitHubRepository -Owner $organizationName -RepositoryName $repositoryNameForOrganization
			Remove-GitHubRepository -Owner $gitHubFork.Owner.Login -RepositoryName $repositoryNameForOrganization
		}
	}

	Context "From a repository that has no git content" {
		# New-GitHubFork : Body :{"message":"The Repository resource exists, but it conta
		# ins no Git content. Empty repositories cannot be forked.","documentation_url":"
		# https://developer.github.com/v3/repos/forks/#create-a-fork"}
		# At line:172 char:39
		# +             $ForkOfGitHubRepository = New-GitHubFork @forkParameters
		# +                                       ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
		#     + CategoryInfo          : NotSpecified: (:) [Write-Error], WriteErrorExcep 
		#    tion
		#     + FullyQualifiedErrorId : Microsoft.PowerShell.Commands.WriteErrorExceptio 
		#    n,New-GitHubFork
		# 	}
}

Describe "Deleting a GitHub repository" {
	Context "When the repository does not exists" {

		$temporaryRepositoryName = "iflkjsdlkfjsld;ak;lasdflkadlskjafpoj'sjfalkjfsalkfjslkj"

		Remove-GitHubRepository -Owner (Get-GitHubAuthenticatedUser).login -RepositoryName $temporaryRepositoryName -OutVariable result -Debug

		It "Returns the correct status code" {
			$result.StatusCode | Should Be NotFound
		}
	}
}

Remove-Module GitHub