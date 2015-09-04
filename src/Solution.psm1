#
# A solution is a combination of projects that have a common lifecycle. That means all projects within it
# share a GitHub repository, development workflow, release strategy, SemVer versioning etc...
#

Class Solution
{
	[String] Name
	[String] Path
}

Function New-Solution 
{
	[CmdletBinding(DefaultParameterSetName='user')]
	Param
	(
		[Parameter(Mandatory = $true, Position = 0)]
		[string] $GitHubAccessToken,
		[Parameter(Mandatory = $true)]
		[string] $SolutionName,
		[Parameter(Mandatory = $true)]
		[string] $Path,
		[Parameter(Mandatory = $true)]
		[ValidateSetAttribute("gitflow")]
		[string] $DevelopmentWorkflow,
		[Parameter(Mandatory = $true, ParameterSetName='organization')]
		[string] $OrganizationName
 	)
	Begin 
	{
	}
	Process	
	{


		New-SolutionStructure -SolutionName $SolutionName -Path $Path
		
		Initialize-GitFlow
				
		New-GitHubRepository -Name

	}
	End 
	{

	}
}

Function Join-Solution 
{
	[CmdletBinding()]
	Param (
		[Parameter(Mandatory = $true, Position = 0)]
		[string] $GitHubAccessToken,
		[Parameter(Mandatory = $true)]
		[string] $SolutionName,
		[Parameter(Mandatory = $true)]
		[string] $Owner
		[Parameter(Mandatory = $false)]
		[switch] $UseSSH	
	)
	Begin 
	{
	}
	Process	
	{		
		if($UseSSH.ToBool() -eq $true) 
		{
			$cloneUrl = gitHubRepository.ssh_url
		}
		else 
		{
			$cloneUrl = gitHubRepository.clone_url
		}	
	}
	End 
	{

	}
}

Function Rename-Solution 
{
	[CmdletBinding()]
	Param 
	(
		[Parameter(Mandatory = $true, Position = 0)]
		[string] $GitHubAccessToken,
		[Parameter(Mandatory = $true)]
		[string] $SolutionName
	)
	Begin 
	{
	}
	Process	
	{
				
				
	}
	End 
	{

	}
}

Function Add-License 
{
	[CmdletBinding()]
	Param 
	(
		[Parameter(Mandatory = $true, Position = 0)]
		[string] $GitHubAccessToken,
		[Parameter(Mandatory = $true)]
		[string] $SolutionName
	)
	Begin 
	{
	}
	Process	
	{
				
				
	}
	End 
	{

	}
}