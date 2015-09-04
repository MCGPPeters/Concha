Set-Variable -Name BaseUri -Value "https://api.github.com" -Option Constant
Set-Variable -Name Headers -Value @{"Accept" = "application/vnd.github.v3+json"} -Option Constant

<#
.Synopsis
   Set the OAuth access token that will be used for authentication when using the GitHub API using this module.
   The access token will be stored using a hashing algorithm in a machine level environment variable named "GitHubAccessTokenHash"
.DESCRIPTION
   Long description
.EXAMPLE
   Set-GitHubAccessToken -SecuredAccessToken ed4abf7da4ae1091161c89819f19326129a6a2be
.INPUTS
   Inputs to this cmdlet (if any)
.NOTES
   General notes
.COMPONENT
   The component this cmdlet belongs to
.ROLE
   The role this cmdlet belongs to
.FUNCTIONALITY
   The functionality that best describes this cmdlet
#>
Function Set-GitHubAccessToken
{
    [CmdletBinding(PositionalBinding=$false)]
    Param
    (
        # The personal access token that can be obtained from GitHub (https://github.com/settings/tokens) for authentication (OAuth)  
        [Parameter(Mandatory=$true, 
                   ValueFromPipeline=$true)]
        [ValidateNotNullOrEmpty()]
        [System.Security.SecureString]
		$SecuredAccessToken
    )

    Begin
    {
    }
    Process
    {
		$tokenHash = ConvertFrom-SecureString $SecuredAccessToken
        [Environment]::SetEnvironmentVariable("GitHubAccessTokenHash", $tokenHash, "Machine")
    }
    End
    {
    }
}

Function Get-GitHubAccessToken
{
	[CmdletBinding(PositionalBinding=$false)]
	Param()
	
	Begin
	{
		
	}
	
	Process
	{
		$securedAccessToken = ConvertTo-SecureString -String ([Environment]::GetEnvironmentVariable("GitHubAccessTokenHash", "Machine"))
		$accessToken = New-Object System.Management.Automation.PSCredential('UserName', $securedAccessToken)
		$accessToken.GetNetworkCredential().Password
	}
	
	End
	{
		
	}
}

<#
	New-GitHubRepository

	Creates a new repository 
#>
function New-GitHubRepository {
	[CmdletBinding(DefaultParameterSetName='user')]
	param(
		[Parameter(Mandatory = $true)]
		[string] $AccessToken = {Get-GitHubAccessToken},
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
		$bodyAsJSON = (ConvertTo-Json -InputObject $body -Compress)
	}
	Process	{
		try {
			Invoke-RestMethod -Method Post -Uri $uri -Headers $Headers -Body $bodyAsJSON -Verbose
		}
		catch {
			Format-Response -Response $_.Exception.Response | Out-Host
		}
	}
}

function New-GitHubFork {
	[CmdletBinding(DefaultParameterSetName='user')]
	param(
		[Parameter(Mandatory = $true, Position = 0)]
		[string] $AccessToken,
		[Parameter(Mandatory = $true, Position = 1)]
		[string] $Owner,
		[Parameter(Mandatory = $true, Position = 1)]
		[string] $RepositoryName,
		[Parameter(Mandatory = $true, ParameterSetName='organization')]
		[string] $OrganizationName
	)
	Begin {
		$uri = "$BaseURI/repos/$Owner/$RepositoryName/forks"

		switch ($PsCmdlet.ParameterSetName) {
			'organization' {
				$uri += "?organization=$OrganizationName"			
			}
		}

		$Headers.Authorization = "token $AccessToken"
	}
	Process {
		try {
			Invoke-RestMethod -Method Post -Uri $uri -Headers $Headers -Verbose
		}
		catch {
			Format-Response -Response $_.Exception.Response | Out-Host
		}
	}
}

function Remove-GitHubRepository {
	[CmdletBinding(DefaultParameterSetName='user')]
	param(
		[Parameter(Mandatory = $true, Position = 0)]
		[string] $AccessToken,
		[Parameter(Mandatory = $true, Position = 1)]
		[string] $Owner,
		[Parameter(Mandatory = $true, Position = 1)]
		[string] $RepositoryName
	)
	Begin {
		$uri = "$BaseURI/repos/$Owner/$RepositoryName"

		$Headers.Authorization = "token $AccessToken"
	}
	Process {
		try {
			Invoke-WebRequest -Method Delete -Uri $uri -Headers $Headers -Verbose
		}
		catch {
			Format-Response -Response $_.Exception.Response | Out-Host
		}
	}
}

Function Get-GitHubIssue 
{
	param(
		[Parameter(Mandatory = $true, Position = 0)]
		[string] $AccessToken = {Get-GitHubAccessToken},
		[Parameter(Mandatory = $true, Position = 1)]
		[string] $Owner,
		[Parameter(Mandatory = $true, Position = 2)]
		[string] $RepositoryName,
		[Parameter(Mandatory = $False, Default = "open")]
		[ValidateSetAttribute("open", "closed", "all")]
		[string] $State,
		[Parameter(Mandatory = $False)]
		[string] $Milestone,
		[Parameter(Mandatory = $False)]
		# Can be the name of a user. Pass in none for issues with no assigned user, and * for issues assigned to any user.
		[Parameter(Mandatory = $False)]
		[string] $Assignee,
		[Parameter(Mandatory = $False)]
		[string] $Creator,
		[Parameter(Mandatory = $False)]
		[string] $Mentioned,
		[Parameter(Mandatory = $False)]
		[string[]] $Labels,
		[Parameter(Mandatory = $False, Default = "created")]
		[ValidateSetAttribute("updated", "comments", "created")]
		[string] $Sort,
		[Parameter(Mandatory = $False, Default = "desc")]
		[ValidateSetAttribute("asc", "desc")]
		[string] $Direction,
        # Only issues updated at or after this time are returned. This is a timestamp in ISO 8601 format: YYYY-MM-DDTHH:MM:SSZ.
		[Parameter(Mandatory = $False, Default = "desc")]
		[ValidateSetAttribute("asc", "desc")]
		[string] $Since
	)
	Begin {
		$uri = "$BaseURI/repos/$Owner/$RepositoryName/issues"

		$Headers.Authorization = "token $AccessToken"
	}
	Process {
		try {
			
			$body = Get-AllBoundParameters -CommandName $MyInvocation.MyCommand.Name
			
		
			Invoke-WebRequest -Method Get -Uri $uri -Headers $Headers -Verbose
		}
		catch {
			Format-Response -Response $_.Exception.Response | Out-Host
		}
	}
}

function Get-SplattingHashTable 
{
    <#
    .Synopsis
    Gets PowerShell Splatting HashTables for a command invocation including Default values and filters out non provided optional parameters
	Inspired by http://www.briantist.com/how-to/splatting-psboundparameters-default-values-optional-parameters/
    .Parameter CommandName
    The name of the command that will have PowerShell Splatting HashTables generated for
    .Example
    Get-AllBoundParameters -CommandName Add-AzureAccount
    #>
    [CmdletBinding()]
    param (
        [System.Management.Automation.CommandInfo] 
		$CommandInfo
    )
	foreach($h in $CommandInfo.Parameters.GetEnumerator()) 
	{
		try 
		{
			$key = $h.Key
			$val = Get-Variable -Name $key -ErrorAction Stop | Select-Object -ExpandProperty Value -ErrorAction Stop
			if (([String]::IsNullOrEmpty($val) -and (!$PSBoundParameters.ContainsKey($key)))) {
				throw "A blank value that wasn't supplied by the user."
			}
			$params[$key] = $val
		} 
		catch {}
	}
}

function Format-Response {
	param(
		[Parameter(Mandatory = $true, Position = 0)]
		[PSObject] $Response
	)
	Begin {
		"StatusCode :" + $_.Exception.Response.StatusCode.value__ 
		"StatusDescription :" + $_.Exception.Response.StatusDescription
			
		$result = $_.Exception.Response.GetResponseStream()
		$reader = New-Object -TypeName System.IO.StreamReader($result)
		$reader.BaseStream.Position = 0
		$reader.DiscardBufferedData()
		$responseBody = $reader.ReadToEnd();	 	
			
		"Body :" + $responseBody
	}
}

## create private fork of eVisionSoftware/eVision.InteractivePnid
#Invoke-WebRequest -Method Post -Uri "https://api.github.com/repos/eVisionSoftware/eVision.InteractivePnid/forks" -Headers @{"Accept"="application/vnd.github.v3+json";"Authorization"="token $github_access_token"}
#
## clone private fork
#git clone git@github.com:$github_username/eVision.InteractivePnid.git
#
#Push-Location -Path eVision.InteractivePnid
#git flow init -d
#Pop-Location