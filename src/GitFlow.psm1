# https://github.com/nvie/gitflow/wiki/Command-Line-Arguments

Import-Module -Name (Join-Path -Path $PSScriptRoot -ChildPath 'GitHub.psm1')
Import-Module -Name (Join-Path -Path $PSScriptRoot -ChildPath 'Solution.psm1')

function Initialize-GitFlow {
	[CmdletBinding()]
	Param(
		[Parameter(Mandatory = $true, Position = 0)]
		[Solution] $Solution
	)
	Process
	{				
		Push-Location -Path $Path
		git flow init -fd
		Pop-Location
	}
}

Function Start-Feature 
{
	[CmdletBinding()]
	Param
	(
		[Parameter(Mandatory = $true)]
		[Solution] $Solution
 	)
	
	DynamicParam 
	{
		Get-UnassignedIssuesParameter -GitHubRepositoryName $Solution.Name -GitHubOwnerName $Solution.GitHubRepository.Name
    }

    begin {
        # Bind the parameter to a friendly variable
        $GitHubFeature = $PsBoundParameters[$ParameterName]
		
		
		
    }
}


function Finish-Feature 
{
	[CmdletBinding()]
	Param
	(
		[Parameter(Mandatory = $true)]
		[String] $SolutionName
 	)
	DynamicParam 
	{
		
    }
	Process	
	{
	}	
}

Function Get-Features
{

}

Function Get-UnassignedIssuesParameter
{
	[CmdletBinding()]
	Param
	(
		[Parameter(Mandatory = $true)]
		[Solution] $Solution
 	)
	Process
	{
		# Set the dynamic parameters' name
		$ParameterName = 'RelatedIssue'
		
		# Create the dictionary 
		$RuntimeParameterDictionary = New-Object System.Management.Automation.RuntimeDefinedParameterDictionary

		# Create the collection of attributes
		$AttributeCollection = New-Object System.Collections.ObjectModel.Collection[System.Attribute]
		
		# Create and set the parameters' attributes
		$ParameterAttribute = New-Object System.Management.Automation.ParameterAttribute
		$ParameterAttribute.Mandatory = $true
		$ParameterAttribute.Position = 1

		# Add the attributes to the attributes collection
		$AttributeCollection.Add($ParameterAttribute)

		# Generate and set the ValidateSet 
		$arrSet = Get-GitHubIssue -Owner $Solution.GitHubRepository.Owner.Login -RepositoryName $Solution.GitHubRepository.Name -Assignee None
		$ValidateSetAttribute = New-Object System.Management.Automation.ValidateSetAttribute($arrSet)

		# Add the ValidateSet to the attributes collection
		$AttributeCollection.Add($ValidateSetAttribute)

		# Create and return the dynamic parameter
		$RuntimeParameter = New-Object System.Management.Automation.RuntimeDefinedParameter($ParameterName, [string], $AttributeCollection)
		$RuntimeParameterDictionary.Add($ParameterName, $RuntimeParameter)
		return $RuntimeParameterDictionary
	}
}