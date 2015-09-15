using namespace System

Set-Variable -Name BaseUri -Value "https://api.github.com" -Option Constant
Set-Variable -Name Headers -Value @{"Accept" = "application/vnd.github.v3+json"} -Option AllScope

class GitHubOwner
{
	[Int]$Id;
	[String]$Login;
    [Uri]$AvatarUrl;
    [String]$GravatarId;
    [Uri]$Url;
    [Uri]$HTMLUrl;
    [Uri]$FollowersUrl;
    [Uri]$FollowingUrl;
    [Uri]$GistsUrl;
    [Uri]$StarredUrl;
    [Uri]$SubscriptionsUrl;
    [Uri]$OrganizationsUrl;
    [Uri]$ReposUrl;
    [Uri]$EventsUrl;
    [Uri]$ReceivedEventsUrl;
    [String]$Type;
    [Bool]$IsSiteAdmin;
}

class GitHubRepository
{
	[Int]$Id;
	[GitHubOwner]$Owner;
	[String]$Name;
	[String]$FullName;
	[String]$Description;
	[String]$Private;
	[String]$Fork;
	[Uri]$Url;
	[Uri]$HtmlUrl;
	[Uri]$ArchiveUrl;
	[Uri]$AssigneesUrl;
	[Uri]$BlobsUrl;
	[Uri]$BranchesUrl;
	[Uri]$CloneUrl;
	[Uri]$CollaboratorsUrl;
	[Uri]$CommentsUrl;
	[Uri]$CommitsUrl;
	[Uri]$CompareUrl;
	[Uri]$ContentsUrl;
	[Uri]$ContributorsUrl;
	[Uri]$DownloadsUrl;
	[Uri]$EventsUrl;
	[Uri]$ForksUrl;
	[Uri]$GitCommitsUrl;
	[Uri]$GitRefsUrl;
	[Uri]$GitTagsUrl;
	[Uri]$GitUrl;
	[Uri]$HooksUrl;
	[Uri]$IssueCommentUrl;
	[Uri]$IssueEventsUrl;
	[Uri]$IssuesUrl;
	[Uri]$KeysUrl;
	[Uri]$LabelsUrl;
	[Uri]$LanguagesUrl;
	[Uri]$MergesUrl;
	[Uri]$MilestonesUrl;
	[Uri]$MirrorUrl;
	[Uri]$NotificationsUrl;
	[Uri]$PullsUrl;
	[Uri]$ReleasesUrl;
	[String]$SshUrl;
	[Uri]$StargazersUrl;
	[Uri]$StatusesUrl;
	[Uri]$SubscribersUrl;
	[Uri]$SubscriptionUrl;
	[Uri]$SvnUrl;
	[Uri]$TagsUrl;
	[Uri]$TeamsUrl;
	[Uri]$TreesUrl;
	[Uri]$HomepageUrl;
	[String]$Language;
	[Int]$ForksCount;
	[Int]$StargazersCount;
	[Int]$WatchersCount;
	[Int]$Size;
	[Bool]$DefaultBranch;
	[Int]$OpenIssuesCount;
	[Bool]$HasIssues;
	[Bool]$HasWiki;
	[Bool]$HasPages;
	[Bool]$HasDownloads;
	[DateTime]$PushedAt;
	[DateTime]$CreatedAt;
	[DateTime]$UpdatedAt;
	[Bool]$HasAdminPermission;
    [Bool]$HasPullPermission;
    [Bool]$HasPushPermission;     

	GitHubRepository([PSCustomObject] $GitHubResponse)
	{
		$this.Id = $GitHubResponse.id;
		$this.Owner = [GitHubOwner]::New();
		$this.Owner.Id = $GitHubResponse.owner.id
		$this.Owner.Login = $GitHubResponse.owner.login
		$this.Owner.AvatarUrl = ConvertTo-Url -String $GitHubResponse.owner.avatar_url            
		$this.Owner.GravatarId = ConvertTo-Url -String $GitHubResponse.owner.gravatar_id
		$this.Owner.Url = ConvertTo-Url -String $GitHubResponse.owner.url
		$this.Owner.HTMLUrl = ConvertTo-Url -String $GitHubResponse.owner.html_url
		$this.Owner.FollowersUrl = ConvertTo-Url -String $GitHubResponse.owner.followers_url
		$this.Owner.FollowingUrl = ConvertTo-Url -String $GitHubResponse.owner.following_url
		$this.Owner.GistsUrl = ConvertTo-Url -String $GitHubResponse.owner.gists_url
		$this.Owner.StarredUrl = ConvertTo-Url -String $GitHubResponse.owner.starred_url
		$this.Owner.SubscriptionsUrl = ConvertTo-Url -String $GitHubResponse.owner.subscriptions_url
		$this.Owner.OrganizationsUrl = ConvertTo-Url -String $GitHubResponse.owner.organizations_url
		$this.Owner.ReposUrl = ConvertTo-Url -String $GitHubResponse.owner.repos_url
		$this.Owner.EventsUrl = ConvertTo-Url -String $GitHubResponse.owner.events_url
		$this.Owner.ReceivedEventsUrl = ConvertTo-Url -String $GitHubResponse.owner.received_events_url
		$this.Owner.Type = $GitHubResponse.owner.type
		$this.Owner.IsSiteAdmin = $GitHubResponse.owner.site_admin
		$this.Name = $GitHubResponse.name
		$this.FullName = $GitHubResponse.full_name
		$this.Description = $GitHubResponse.description
		$this.Private = $GitHubResponse.private
		$this.Fork = $GitHubResponse.fork
		$this.Url = ConvertTo-Url -String $GitHubResponse.url
		$this.HtmlUrl = ConvertTo-Url -String $GitHubResponse.html_url
		$this.ArchiveUrl = ConvertTo-Url -String $GitHubResponse.archive_url
		$this.AssigneesUrl = ConvertTo-Url -String $GitHubResponse.assignees_url
		$this.BlobsUrl = ConvertTo-Url -String $GitHubResponse.blobs_url
		$this.BranchesUrl = ConvertTo-Url -String $GitHubResponse.branches_url
		$this.CloneUrl = ConvertTo-Url -String $GitHubResponse.clone_url
		$this.CollaboratorsUrl = ConvertTo-Url -String $GitHubResponse.collaborators_url
		$this.CommentsUrl = ConvertTo-Url -String $GitHubResponse.comments_url
		$this.CommitsUrl = ConvertTo-Url -String $GitHubResponse.commits_url
		$this.CompareUrl = ConvertTo-Url -String $GitHubResponse.compare_url
		$this.ContentsUrl = ConvertTo-Url -String $GitHubResponse.contents_url
		$this.ContributorsUrl = ConvertTo-Url -String $GitHubResponse.contributors_url
		$this.DownloadsUrl = ConvertTo-Url -String $GitHubResponse.downloads_url
		$this.EventsUrl = ConvertTo-Url -String $GitHubResponse.events_url
		$this.ForksUrl = ConvertTo-Url -String $GitHubResponse.forks_url
		$this.GitCommitsUrl = ConvertTo-Url -String $GitHubResponse.git_commits_url
		$this.GitRefsUrl = ConvertTo-Url -String $GitHubResponse.git_refs_url
		$this.GitTagsUrl = ConvertTo-Url -String $GitHubResponse.git_tags_url
		$this.GitUrl = [Uri]::New($GitHubResponse.git_url)
		$this.HooksUrl = ConvertTo-Url -String $GitHubResponse.hooks_url
		$this.IssueCommentUrl = ConvertTo-Url -String $GitHubResponse.issue_comment_url
		$this.IssueEventsUrl = ConvertTo-Url -String $GitHubResponse.issue_events_url
		$this.IssuesUrl = ConvertTo-Url -String $GitHubResponse.issues_url
		$this.KeysUrl = ConvertTo-Url -String $GitHubResponse.keys_url
		$this.LabelsUrl = ConvertTo-Url -String $GitHubResponse.labels_url
		$this.LanguagesUrl = ConvertTo-Url -String $GitHubResponse.languages_url
		$this.MergesUrl = ConvertTo-Url -String $GitHubResponse.merges_url
		$this.MilestonesUrl = ConvertTo-Url -String $GitHubResponse.milestones_url
		$this.MirrorUrl = if (-not [String]::IsNullOrEmpty($GitHubResponse.mirror_url)) {[Uri]::New($GitHubResponse.mirror_url)}
		$this.NotificationsUrl = ConvertTo-Url -String $GitHubResponse.notifications_url
		$this.PullsUrl = ConvertTo-Url -String $GitHubResponse.pulls_url
		$this.ReleasesUrl = ConvertTo-Url -String $GitHubResponse.releases_url
		$this.SshUrl = $GitHubResponse.ssh_url
		$this.StargazersUrl = ConvertTo-Url -String $GitHubResponse.stargazers_url
		$this.StatusesUrl = ConvertTo-Url -String $GitHubResponse.statuses_url
		$this.SubscribersUrl = ConvertTo-Url -String $GitHubResponse.subscribers_url
		$this.SubscriptionUrl = ConvertTo-Url -String $GitHubResponse.subscription_url
		$this.SvnUrl = ConvertTo-Url -String $GitHubResponse.svn_url
		$this.TagsUrl = ConvertTo-Url -String $GitHubResponse.tags_url
		$this.TeamsUrl = ConvertTo-Url -String $GitHubResponse.teams_url
		$this.TreesUrl = ConvertTo-Url -String $GitHubResponse.trees_url
		$this.HomepageUrl = ConvertTo-Url -String $GitHubResponse.homepage
		$this.Language = $GitHubResponse.language
		$this.ForksCount = $GitHubResponse.forks_count
		$this.StargazersCount = $GitHubResponse.stargazers_count
		$this.WatchersCount = $GitHubResponse.watchers_count
		$this.Size = $GitHubResponse.size
		$this.DefaultBranch = $GitHubResponse.default_branch
		$this.OpenIssuesCount = $GitHubResponse.open_issues_count
		$this.HasIssues = $GitHubResponse.has_issues
		$this.HasWiki = $GitHubResponse.has_wiki
		$this.HasPages = $GitHubResponse.has_pages
		$this.HasDownloads = $GitHubResponse.has_downloads
		$this.PushedAt = [DateTime]::Parse($GitHubResponse.pushed_at)
		$this.CreatedAt = [DateTime]::Parse($GitHubResponse.created_at)
		$this.UpdatedAt = [DateTime]::Parse($GitHubResponse.updated_at)
		$this.HasAdminPermission = $GitHubResponse.permissions.admin
        $this.HasPullPermission = $GitHubResponse.permissions.pull
        $this.HasPushPermission = $GitHubResponse.permissions.push
	}
}

Function ConvertTo-Url
{
    [OutputType([Uri])]
    [CmdletBinding(PositionalBinding=$false)]
    param
    (
        [Parameter(Mandatory=$true, ValueFromPipeline=$true)]
        [AllowEmptyString()]
        [string]$String
    )
    Process
    {
        [Uri]$Uri = [Uri]::Empty;
        switch ([Uri]::TryCreate($String, [UriKind]::RelativeOrAbsolute, [ref]$Uri))
        {
            $true 
            {
                switch(($Uri.Scheme -eq [Uri]::UriSchemeHttp) -or ($Uri.Scheme -eq [Uri]::UriSchemeHttps))
                {
                    $true {$Uri; break}
                    $false {[Uri]::Empty; break}
                }
                break
            }
            $false { [Uri]::Empty; break }
        }
    }
}

enum Permission
{
	Admin;
	Push;
	Pull;
}  

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
        [Security.SecureString]
		$SecuredAccessToken
    )

    Begin
    {
    }
    Process
    {
		$tokenHash = ConvertFrom-SecureString -Secure $SecuredAccessToken
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
	
	Process
	{
		$securedAccessToken = ConvertTo-SecureString -String ([Environment]::GetEnvironmentVariable("GitHubAccessTokenHash", "Machine"))
		$accessToken = New-Object -TypeName Management.Automation.PSCredential -ArgumentList 'UserName', $securedAccessToken
		$accessToken.GetNetworkCredential().Password
	}
}

<#
.Synopsis
    Short description
.DESCRIPTION
    Long description
.EXAMPLE
    Example of how to use this cmdlet
.EXAMPLE
    Another example of how to use this cmdlet
#>
Function Get-GitHubAuthenticatedUser
{
    [CmdletBinding()]
    #[OutputType([GitHubUser])]
    Param
    (
        [Parameter(Mandatory = $false, ValueFromPipeline = $true)]
		[string] $AccessToken = (Get-GitHubAccessToken)
    )

    Begin 
    {
		
	}

	Process 
    {
		try 
        {
            $uri = "$BaseURI/user"

		    $Headers.Authorization = "token $AccessToken"
			Invoke-RestMethod -Method Get -Uri $uri -Headers $Headers -Verbose
		}
		catch 
        {
			Format-Response -Response $_.Exception.Response | Write-Error
		}
	}
}

Function Get-GitHubRepository 
{
	[OutputType([GitHubRepository])]
	[CmdletBinding(DefaultParameterSetName='user')]
	Param
    (
	    [Parameter(Mandatory = $false)]
		[string] $AccessToken = {Get-GitHubAccessToken}.Invoke(),
		[Parameter(Mandatory = $true)]
		[string] $Owner,
		[Parameter(Mandatory = $true)]
		[string] $RepositoryName
    )
    Begin 
    {
		$uri = "$BaseURI/repos/$Owner/$RepositoryName"

		$Headers.Authorization = "token $AccessToken"
	}
    Process
    {
	    try 
        {
			$response = Invoke-RestMethod -Method Get -Uri $uri -Headers $Headers -Verbose
		}
		catch 
        {
			Format-Response -Response $_.Exception.Response | Write-Error
		}
        
        return [GitHubRepository]::New($response)
    }
}

<#
	New-GitHubRepository

	Creates a new repository 
#>
Function New-GitHubRepository 
{
	[OutputType([GitHubRepository])]
	[CmdletBinding(DefaultParameterSetName='user')]
	Param
    (
		[Parameter(Mandatory = $false)]
		[string] $AccessToken = {Get-GitHubAccessToken}.Invoke(),
		[Parameter(Mandatory = $true)]
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
	Begin 
    {
		$body = 
        @{
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

		switch ($PsCmdlet.ParameterSetName) 
        {
			'organization' 
            {
					if ($TeamId -eq $null)	
                    { 
						$requestBody.team_id = $TeamId;
					}
					$uri = "$BaseUri/orgs/$OrganizationName/repos"
			}
			
            'user' 
            {
				$uri = "$BaseUri/user/repos"
			}
		}

		$Headers.Authorization = "token $AccessToken"
		$bodyAsJSON = (ConvertTo-Json -InputObject $body -Compress)
	}
	Process	
    {
		try 
        {
			$response = Invoke-RestMethod -Method Post -Uri $uri -Headers $Headers -Body $bodyAsJSON -Verbose
		}
		catch 
        {
			Format-Response -Response $_.Exception.Response | Write-Error
		}
        
        return [GitHubRepository]::New($response)
	}
}

Function New-GitHubFork 
{
	[CmdletBinding(DefaultParameterSetName='user')]
	param
	(
		[Parameter(Mandatory = $false)]
		[string] $AccessToken = {Get-GitHubAccessToken}.Invoke(),
		[Parameter(Mandatory = $true)]
		[string] $Owner,
		[Parameter(Mandatory = $true)]
		[string] $RepositoryName
	)
	Begin 
	{
		$uri = "$BaseURI/repos/$Owner/$RepositoryName/forks"

		switch ($PsCmdlet.ParameterSetName) 
		{
			'organization' 
			{
				$uri += "?organization=$OrganizationName"			
			}
		}

		$Headers.Authorization = "token $AccessToken"
	}
	Process 
	{
		try 
        {
			Invoke-RestMethod -Method Post -Uri $uri -Headers $Headers -Verbose
		}
		catch 
		{
			Format-Response -Response $_.Exception.Response | Write-Error
		}
	}
}

Function Remove-GitHubRepository 
{
	[CmdletBinding()]
    Param
    (
		[Parameter(Mandatory = $false)]
		[string] $AccessToken = {Get-GitHubAccessToken}.Invoke(),
		[Parameter(Mandatory = $true)]
		[string] $Owner,
		[Parameter(Mandatory = $true)]
		[string] $RepositoryName
	)
	Begin 
    {
		$uri = "$BaseURI/repos/$Owner/$RepositoryName"

		$Headers.Authorization = "token $AccessToken"
	}
	Process 
    {
		try 
        {
			Invoke-RestMethod -Method Delete -Uri $uri -Headers $Headers -Verbose
		}
		catch 
        {
			Format-Response -Response $_.Exception.Response | Write-Error
		}
	}
}

Function Get-GitHubIssue 
{
	[CmdletBinding()]
	Param
	(
		[Parameter(Mandatory = $false)]
		[string] $AccessToken = {Get-GitHubAccessToken}.Invoke(),
		[Parameter(Mandatory = $true)]
		[string] $Owner,
		[Parameter(Mandatory = $true)]
		[string] $RepositoryName,
		[Parameter(Mandatory = $False)]
		[ValidateSet("open", "closed", "all")]
		[string] $State = "open",
		[Parameter(Mandatory = $False)]
		[string] $Milestone,
		# Can be the name of a user. Pass in none for issues with no assigned user, and * for issues assigned to any user.
		[Parameter(Mandatory = $False)]
		[string] $Assignee,
		[Parameter(Mandatory = $False)]
		[string] $Creator,
		[Parameter(Mandatory = $False)]
		[string] $Mentioned,
		[Parameter(Mandatory = $False)]
		[string[]] $Labels,
		[Parameter(Mandatory = $False)]
		[ValidateSet("updated", "comments", "created")]
		[string] $Sort = "created",
		[Parameter(Mandatory = $False)]
		[ValidateSet("asc", "desc")]
		[string] $Direction = "desc",
        # Only issues updated at or after this time are returned. 
        #This is a timestamp in ISO 8601 format: YYYY-MM-DDTHH:MM:SSZ.
		[Parameter(Mandatory = $False)]
		[ValidatePattern("^(-?(?:[1-9][0-9]*)?[0-9]{4})-(1[0-2]|0[1-9])-(3[01]|0[1-9]|[12][0-9])T(2[0-3]|[01][0-9]):([0-5][0-9]):([0-5][0-9])(\.[0-9]+)?(Z|[+-](?:2[0-3]|[01][0-9]):[0-5][0-9])?$")]
		[string] $Since
	)
	Begin 
    {
		$uri = "$BaseURI/repos/$Owner/$RepositoryName/issues"

		$Headers.Authorization = "token $AccessToken"
	}
	Process 
    {
		try 
        {
			$nameValueCollection = ConvertTo-HashTable -CommandInfo $MyInvocation.MyCommand

			Invoke-RestMethod -Method Get -Uri $uri -Headers $Headers -Body $nameValueCollection -Verbose
		}
		catch 
        {
			Format-Response -Response $_.Exception.Response | Write-Error
		}
	}
}

Function Get-ParameterWithValue
{
    [OutputType([Management.Automation.ParameterMetadata[]])]
    [CmdletBinding()]
	Param
	(
        [Parameter(Mandatory = $true)]
        [Management.Automation.ParameterMetadata[]]
        $InvocationParameters
    )

    Begin
    {
        
    }

    Process
    {
        $InvocationParameters | 
        Where-Object -Value -NE 
    }
        
}

Function ConvertTo-HashTable 
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
    [OutputType([Collections.Hashtable])]
    Param 
	(
        [Management.Automation.CommandInfo] 
		$CommandInfo
    )
	Begin
	{
		
	}
	Process
	{
        $hash = $null
        $hash = @{}



		foreach($parameter in $CommandInfo.Parameters.GetEnumerator()) 
		{
			try 
			{
				$key = $parameter.Key
				$val = Get-Variable -Name $key -ErrorAction Stop | Select-Object -ExpandProperty Value -ErrorAction Stop
				if (([String]::IsNullOrEmpty($val) -and (!$PSBoundParameters.ContainsKey($key)))) 
				{
					throw "A blank value that wasn't supplied by the user."
				}
				$hash[$key] = $val
			} 
			catch {}
		}
	}
	
	End 
	{
		return $hash
	}
}

function Format-Response 
{
	param(
		[Parameter(Mandatory = $true, Position = 0)]
		[PSObject] $Response
	)
	Begin {
		"StatusCode :" + $_.Exception.Response.StatusCode.value__ 
		"StatusDescription :" + $_.Exception.Response.StatusDescription
			
		$result = $_.Exception.Response.GetResponseStream()
		$reader = New-Object -TypeName IO.StreamReader($result)
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
