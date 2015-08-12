<#
	Initialize-GitHubRepository

	Creates a new git repository in the current folder
#>
function Initialize-GitHubRepository {
	[CmdletBinding()]
	param(
		[Parameter(Mandatory = $true)]
		[string] $AccessToken,
		[Parameter(Mandatory = $true, Position = 0)]
		[string] $Name
	)
	Process
	{

	}
}