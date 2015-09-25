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
		[PSCustomObject] $Solution
 	)
	
	DynamicParam 
	{
		Get-GetValidatedDynamicParameter -ParameterName 'GitHubIssue' -ValidateSet (Get-GitHubIssue -Owner $Solution.GitHubRepository.Owner.Login -RepositoryName $Solution.GitHubRepository.Name)
    }
    Begin 
    {
        # Bind the parameter to a friendly variable
        $GitHubFeature = $PsBoundParameters['GitHubIssue']
    }
    Process
    {
        
    }
}

function Finish-Feature 
{
	[CmdletBinding()]
	Param
	(
		
 	)
	DynamicParam 
	{
		Get-GetValidatedDynamicParameter -ParameterName 'Feature' -ValidateSet (Get-Features)
    }
    Begin
    {
        $Feature = $PSBoundParameters['Feature']
    }
	Process	
	{
        
		git flow feature start -rFS $Feature
	}	
}

Function Get-Features
{
	[OutputType([string[]])]
	[CmdletBinding()]
	Param()

	Process	
	{
		git flow feature | Select-Object -Property @{'Name' = 'Feature'; 'Expression' = {$_.Replace("* ", '').Trim()}} | Select-Object -ExpandProperty Feature
	}
}

Function Get-GetValidatedDynamicParameter
{
	[OutputType([System.Management.Automation.RuntimeDefinedParameterDictionary])]
	[CmdletBinding()]
	Param
	(
		[Parameter(Mandatory = $true)]
		[String]$ParameterName,
		[Parameter(Mandatory = $true)]
		[string[]] $ValidateSet
 	)
	Process
	{		
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
		$ValidateSetAttribute = New-Object System.Management.Automation.ValidateSetAttribute($ValidateSet)

		# Add the ValidateSet to the attributes collection
		$AttributeCollection.Add($ValidateSetAttribute)

		# Create and return the dynamic parameter
		$RuntimeParameter = New-Object System.Management.Automation.RuntimeDefinedParameter($ParameterName, [string], $AttributeCollection)
		$RuntimeParameterDictionary.Add($ParameterName, $RuntimeParameter)
		return $RuntimeParameterDictionary
	}
}