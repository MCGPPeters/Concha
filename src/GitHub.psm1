Set-Variable -Name BaseUri -Value "https://api.github.com" -Option Constant
Set-Variable -Name Headers -Value @{"Accept" = "application/vnd.github.v3+json"} -Option AllScope

class Owner
{
	[String]$Id;
	[String]$Login;
    [System.Uri]$AvatarUrl;
    [String]$GravatarId;
    [System.Uri]$Url;
    [System.Uri]$HTMLUrl;
    [System.Uri]$FollowersUrl;
    [System.Uri]$FollowingUrl;
    [System.Uri]$GistsUrl;
    [System.Uri]$StarredUrl;
    [System.Uri]$SubscriptionsUrl;
    [System.Uri]$OrganizationsUrl;
    [System.Uri]$ReposUrl;
    [System.Uri]$EventsUrl;
    [System.Uri]$ReceivedEventsUrl;
    [String]$Type;
    [Bool]$IsSiteAdmin;
}

class Repository
{
	[String]$Id;
	[Owner]$Owner;
	[String]$Name;
	[String]$FullName;
	[String]$Description;
	[String]$Private;
	[String]$Fork;
	[System.Uri]$Url;
	[System.Uri]$HtmlUrl;
	[System.Uri]$ArchiveUrl;
	[System.Uri]$AssigneesUrl;
	[System.Uri]$BlobsUrl;
	[System.Uri]$BranchesUrl;
	[System.Uri]$CloneUrl;
	[System.Uri]$CollaboratorsUrl;
	[System.Uri]$CommentsUrl;
	[System.Uri]$CommitsUrl;
	[System.Uri]$CompareUrl;
	[System.Uri]$ContentsUrl;
	[System.Uri]$ContributorsUrl;
	[System.Uri]$DownloadsUrl;
	[System.Uri]$EventsUrl;
	[System.Uri]$ForksUrl;
	[System.Uri]$Git_commitsUrl;
	[System.Uri]$Git_refsUrl;
	[System.Uri]$Git_tagsUrl;
	[System.Uri]$GitUrl;
	[System.Uri]$HooksUrl;
	[System.Uri]$Issue_commentUrl;
	[System.Uri]$Issue_eventsUrl;
	[System.Uri]$IssuesUrl;
	[System.Uri]$KeysUrl;
	[System.Uri]$LabelsUrl;
	[System.Uri]$LanguagesUrl;
	[System.Uri]$MergesUrl;
	[System.Uri]$MilestonesUrl;
	[System.Uri]$MirrorUrl;
	[System.Uri]$NotificationsUrl;
	[System.Uri]$PullsUrl;
	[System.Uri]$ReleasesUrl;
	[System.Uri]$SshUrl;
	[System.Uri]$StargazersUrl;
	[System.Uri]$StatusesUrl;
	[System.Uri]$SubscribersUrl;
	[System.Uri]$SubscriptionUrl;
	[System.Uri]$SvnUrl;
	[System.Uri]$TagsUrl;
	[System.Uri]$TeamsUrl;
	[System.Uri]$TreesUrl;
	[System.Uri]$Homepage;
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
	[System.DateTime]$PushedAt;
	[System.DateTime]$CreatedAt;
	[System.DateTime]$UpdatedAt;
	[System.Collections.Generic.List[Permission]]$Permissions;    

	Repository([PSCustomObject] $GitHubResponse)
	{
		Id = $GitHubResponse.id;
		$this.Owner = [Owner]::New()
		@{
			Id = $GitHubResponse.owner.id;
			Login = $GitHubResponse.owner.login;
			AvatarUrl = $GitHubResponse.owner.avatar_url
			GravatarId = $GitHubResponse.owner.gravatar_id
			Url = $GitHubResponse.owner.url;
			HTMLUrl = $GitHubResponse.owner.html_url;
			FollowersUrl = $GitHubResponse.owner.followers_url;
			FollowingUrl = $GitHubResponse.owner.following_url;
			GistsUrl = $GitHubResponse.owner.gists_url;
			StarredUrl = $GitHubResponse.owner.starred_url;
			SubscriptionsUrl = $GitHubResponse.owner.subscriptions_url;
			OrganizationsUrl = $GitHubResponse.owner.organizations_url;
			ReposUrl = $GitHubResponse.owner.repos_url;
			EventsUrl = $GitHubResponse.owner.events_url;
			ReceivedEventsUrl = $GitHubResponse.owner.received_events_url;
			Type = $GitHubResponse.owner.type;
			IsSiteAdmin = $GitHubResponse.owner.site_admin;
		};
		Name = $GitHubResponse.name
		FullName = $GitHubResponse.full_name
		Description = $GitHubResponse.description
		Private = $GitHubResponse.private
		Fork = $GitHubResponse.fork
		Url = $GitHubResponse.url
		HtmlUrl = $GitHubResponse.html_url
		ArchiveUrl = $GitHubResponse.archive_url
		AssigneesUrl = $GitHubResponse.assignees_url
		BlobsUrl = $GitHubResponse.blobs_url
		BranchesUrl = $GitHubResponse.branches_url
		CloneUrl = $GitHubResponse.clone_url
		CollaboratorsUrl = $GitHubResponse.collaborators_url
		CommentsUrl = $GitHubResponse.comments_url
		CommitsUrl = $GitHubResponse.commits_url
		CompareUrl = $GitHubResponse.compare_url
		ContentsUrl = $GitHubResponse.contents_url
		ContributorsUrl = $GitHubResponse.contributors_url
		DownloadsUrl = $GitHubResponse.downloads_url
		EventsUrl = $GitHubResponse.events_url
		ForksUrl = $GitHubResponse.forks_url
		GitCommitsUrl = $GitHubResponse.git_commits_url
		GitRefsUrl = $GitHubResponse.git_refs_url
		GitTagsUrl = $GitHubResponse.git_tags_url
		GitUrl = $GitHubResponse.git_url
		HooksUrl = $GitHubResponse.hooks_url
		Issue_commentUrl = $GitHubResponse.issue_comment_url
		Issue_eventsUrl = $GitHubResponse.issue_events_url
		IssuesUrl = $GitHubResponse.issues_url
		KeysUrl = $GitHubResponse.keys_url
		LabelsUrl = $GitHubResponse.labels_url
		LanguagesUrl = $GitHubResponse.languages_url
		MergesUrl = $GitHubResponse.merges_url
		MilestonesUrl = $GitHubResponse.milestones_url
		MirrorUrl = $GitHubResponse.mirror_url
		NotificationsUrl = $GitHubResponse.notifications_url
		PullsUrl = $GitHubResponse.pulls_url
		ReleasesUrl = $GitHubResponse.releases_url
		SshUrl = $GitHubResponse.ssh_url
		StargazersUrl = $GitHubResponse.stargazers_url
		StatusesUrl = $GitHubResponse.statuses_url
		SubscribersUrl = $GitHubResponse.subscribers_url
		SubscriptionUrl = $GitHubResponse.subscription_url
		SvnUrl = $GitHubResponse.svn_url
		TagsUrl = $GitHubResponse.tags_url
		TeamsUrl = $GitHubResponse.teams_url
		TreesUrl = $GitHubResponse.trees_url
		Homepage = $GitHubResponse.homepage
		Language = $GitHubResponse.language
		ForksCount = $GitHubResponse.forks_count
		StargazersCount = $GitHubResponse.stargazers_count
		WatchersCount = $GitHubResponse.watchers_count
		Size = $GitHubResponse.size
		DefaultBranch = $GitHubResponse.default_branch
		OpenIssuesCount = $GitHubResponse.open_issues_count
		HasIssues = $GitHubResponse.has_issues
		HasWiki = $GitHubResponse.has_wiki
		HasPages = $GitHubResponse.has_pages
		HasDownloads = $GitHubResponse.has_downloads
		PushedAt = $GitHubResponse.pushed_at
		CreatedAt = $GitHubResponse.created_at
		UpdatedAt = $GitHubResponse.updated_at
		Permissions = $GitHubResponse.permissions
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
        [System.Security.SecureString]
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
	
	Begin
	{
		
	}
	
	Process
	{
		$securedAccessToken = ConvertTo-SecureString -String ([Environment]::GetEnvironmentVariable("GitHubAccessTokenHash", "Machine"))
		$accessToken = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList 'UserName', $securedAccessToken
		$accessToken.GetNetworkCredential().Password
	}
	
	End
	{
		
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

<#
	New-GitHubRepository

	Creates a new repository 
#>
Function New-GitHubRepository 
{
	[OutputType([Repository])]
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
			$reponse = Invoke-RestMethod -Method Post -Uri $uri -Headers $Headers -Body $bodyAsJSON -Verbose
			[Repository]::New($reponse)
		}
		catch 
        {
			Format-Response -Response $_.Exception.Response | Write-Error
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
		[string] $RepositoryName,
		[Parameter(Mandatory = $true, ParameterSetName='organization')]
		[string] $OrganizationName
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
    [OutputType([System.Management.Automation.ParameterMetadata[]])]
    [CmdletBinding()]
	Param
	(
        [Parameter(Mandatory = $true)]
        [System.Management.Automation.ParameterMetadata[]]
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
    [OutputType([System.Collections.Hashtable])]
    Param 
	(
        [System.Management.Automation.CommandInfo] 
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