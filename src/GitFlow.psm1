function Initialize-GitFlow {
	[CmdletBinding()]
	Param(
		[Parameter(Mandatory = $true, Position = 0)]
		[string] $Path
	)
	Process
	{				
		Push-Location -Path $Path
		git flow init -fd
		Pop-Location
	}
}

function Start-Feature {
	[CmdletBinding()]
	
	DynamicParam {
		# Set the dynamic parameters' name
		$ParameterName = 'GitHubFeature'
		
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
		$arrSet = Get-GitHubIssue
		$ValidateSetAttribute = New-Object System.Management.Automation.ValidateSetAttribute($arrSet)

		# Add the ValidateSet to the attributes collection
		$AttributeCollection.Add($ValidateSetAttribute)

		# Create and return the dynamic parameter
		$RuntimeParameter = New-Object System.Management.Automation.RuntimeDefinedParameter($ParameterName, [string], $AttributeCollection)
		$RuntimeParameterDictionary.Add($ParameterName, $RuntimeParameter)
		return $RuntimeParameterDictionary
    }

    begin {
        # Bind the parameter to a friendly variable
        $GitHubFeature = $PsBoundParameters[$ParameterName]
		
		
		
    }
