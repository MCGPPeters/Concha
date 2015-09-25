$scriptFolder = $MyInvocation.MyCommand.Path
$folder = Split-Path $scriptFolder

Function Start-Build {
	Param (
		[Parameter(Mandatory = $true, Position = 0)]
		[string] $Path 
	)
	DynamicParam {
		# Set the dynamic parameters' name
		$ParameterName = 'Configuration'
		
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
		$arrSet = Get-ChildItem -Filter *.ps1 -File -Path .\configuration | Select-Object -ExpandProperty Name
        
		$ValidateSetAttribute = New-Object System.Management.Automation.ValidateSetAttribute($arrSet)

		# Add the ValidateSet to the attributes collection
		$AttributeCollection.Add($ValidateSetAttribute)

		# Create and return the dynamic parameter
		$RuntimeParameter = New-Object System.Management.Automation.RuntimeDefinedParameter($ParameterName, [string], $AttributeCollection)
		$RuntimeParameterDictionary.Add($ParameterName, $RuntimeParameter)
		return $RuntimeParameterDictionary
    }
    Begin {
        Get-Module Psake  | Remove-Module
		Import-Module (Get-ChildItem -Directory "$scriptFolder\.Nuget\Psake.*\tools\Psake.psm1" | Select-Object -First 1)
    }
    Process {
        Invoke-Psake (Join-Path -Path "$scriptFolder\configuration" -ChildPath $Configuration)
    }
    End {
        Remove-Module Psake   
    }
}