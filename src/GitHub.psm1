$BaseUri = "https://api.github.com"
$Headers = @{"Accept" = "application/vnd.github.v3+json"}

<#
	New-GitHubRepository

	Creates a new repository 
#>
function New-GitHubRepository {
	[CmdletBinding(DefaultParameterSetName='user')]
	param(
		[Parameter(Mandatory = $true, Position = 0)]
		[string] $AccessToken,
		[Parameter(Mandatory = $true, Position = 1)]
		[string] $Name,
		[Parameter(Mandatory = $true, ParameterSetName='organization')]
		[string] $OrganizationName,
		[Parameter(Mandatory = $false)]
		[string] $Description = '',
		[Parameter(Mandatory = $false)]
		[string] $Homepage = '',
		[Parameter(Mandatory = $false)]
		[switch] $IsPrivate = $false,
		[Parameter(Mandatory = $false)]
		[switch] $HasIssues = $true,
		[Parameter(Mandatory = $false)]
		[switch] $HasWiki = $true,
		[Parameter(Mandatory = $false)]
		[switch] $HasDownloads = $true,
		[Parameter(Mandatory = $false, ParameterSetName='organization')]
		[int] $TeamId,
		[Parameter(Mandatory = $false)]
		[switch] $AutoInit = $false,
		[Parameter(Mandatory = $false)]
		[string] $GitIgnoreTemplate,
		[Parameter(Mandatory = $false)]
		[string] $LicenseTemplate		
	)
	Begin {
		$body = @{
			name = $Name;
			description = $Description;
			homepage = $Homepage;
			private = $IsPrivate.ToBool();
			has_issues = $HasIssues.ToBool();
			has_wiki = $HasWiki.ToBool();
			has_downloads = $HasDownloads.ToBool();
			auto_init = $AutoInit.ToBool();
			gitignore_template = $GitIgnoreTemplate;
			license_template = $LicenseTemplate
		}

		switch ($PsCmdlet.ParameterSetName) {
			'organization' {
					if ($TeamId -eq $null)	{ 
						$requestBody.team_id = $TeamId;
						
					}
					$uri = "$BaseUri/orgs/$OrganizationName/repos"
			}
			'user' {
				$uri = "$BaseUri/user/repos"
			}
		}

		$Headers.Authorization = "token $AccessToken"
		$bodyAsJSON = (ConvertTo-Json $body -Compress)

		Write-Host $bodyAsJSON
		Write-Host $body
	}
	Process	{
		try{
			Invoke-RestMethod -Method Post -Uri $uri -Headers $Headers -Body $bodyAsJSON -Verbose
		}
		catch {
			Write-Host -ForegroundColor Red "StatusCode:" $_.Exception.Response.StatusCode.value__ 
			Write-Host -ForegroundColor Red "StatusDescription:" $_.Exception.Response.StatusDescription
		}
	}

}

#$VersionMediaType = "application/vnd.github.v3+json"
#Invoke-WebRequest -Method Post -Uri "https://api.github.com/repos/eVisionSoftware/eVision.InteractivePnid/forks" -Headers @{"Accept"="application/vnd.github.v3+json";"Authorization"="token $github_access_token"}
## create private fork of eVisionSoftware/eVision.InteractivePnid
#Invoke-WebRequest -Method Post -Uri "https://api.github.com/repos/eVisionSoftware/eVision.InteractivePnid/forks" -Headers @{"Accept"="application/vnd.github.v3+json";"Authorization"="token $github_access_token"}
#
## clone private fork
#git clone git@github.com:$github_username/eVision.InteractivePnid.git
#
#Push-Location -Path eVision.InteractivePnid
#git flow init -d
#Pop-Location