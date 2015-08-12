$GitHubApiBaseUri = "https://api.github.com/"
$RepoApiPath = "/user/repos"

<#
	New-GitHubRepository

	Creates a new repository 
#>
function New-GitHubRepository {
	[CmdletBinding()]
	param(
		[Parameter(Mandatory = $true)]
		[string] $AccessToken,
		[Parameter(Mandatory = $true)]
		[string] $Name
	)
	Process
	{

	}
}

Invoke-WebRequest -Method Post -Uri "https://api.github.com/repos/eVisionSoftware/eVision.InteractivePnid/forks" -Headers @{"Accept"="application/vnd.github.v3+json";"Authorization"="token $github_access_token"}
# create private fork of eVisionSoftware/eVision.InteractivePnid
Invoke-WebRequest -Method Post -Uri "https://api.github.com/repos/eVisionSoftware/eVision.InteractivePnid/forks" -Headers @{"Accept"="application/vnd.github.v3+json";"Authorization"="token $github_access_token"}

# clone private fork
git clone git@github.com:$github_username/eVision.InteractivePnid.git

Push-Location -Path eVision.InteractivePnid
git flow init -d
Pop-Location