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
        [Parameter(Mandatory = $false)]
		[string] $GitHubAccessToken,
        [Parameter(Mandatory = $true)]
		[String] $GitHubOwnerName,
        [Parameter(Mandatory = $true)]
        [String] $GitHubRepositoryName
 	)
	DynamicParam
    {
        if(-not $GitHubAccessToken)
        {
            $GitHubAccessToken = {Get-GitHubAccessToken}.Invoke()
        }

        $GitHubIssues = Get-GitHubIssue -AccessToken $GitHubAccessToken -Owner $GitHubOwnerName -RepositoryName $GitHubRepositoryName | Foreach-Object -Process {'"#' + $_.Number + ' ' + $_.Title + '"'}

		New-DynamicParameter -Name 'GitHubIssue' -Mandatory -HelpMessage 'Select the GitHub issue that corresponds to the feature you wish to start development on' -ValidateSet $GitHubIssues
    }
    Begin 
    {
        $GitHubIssue = $PSBoundParameters['GitHubIssue']
    }
    Process
    {
        git flow feature start -F $GitHubIssue
        git branch 
    }
    End{}
}

Function Finish-Feature   
{
	[CmdletBinding()]
	Param
	(
		
 	)
	DynamicParam 
	{
        $Features = Get-Features

		New-DynamicParameter -ParameterName 'Feature' -Mandatory -HelpMessage 'Select the feature branch to finish. Commits in the branch will be squached and the related GitHub issue will be closed' -ValidateSet $Features
    }
    Begin
    {
        $Feature = $PSBoundParameters['Feature']
    }
	Process	
	{
        git flow feature finish -rFS $Feature
	}	
    End{}
}

Function Get-Features
{
	[OutputType([String[]])]
	[CmdletBinding()]
	Param()

	Process	
	{
		git flow feature | Select-Object -Property @{'Name' = 'Feature'; 'Expression' = {$_.Replace("* ", '').Trim()}} | Select-Object -ExpandProperty Feature
	}
}

Function New-DynamicParameter
{
	[OutputType([System.Management.Automation.RuntimeDefinedParameter])]
	[CmdletBinding()]
	Param
	(
		[Parameter(Mandatory = $true)]
		[String] $Name,
        [Parameter(Mandatory = $false)]
        [string] $ParameterSetName = '__AllParameterSets',
        [Parameter(Mandatory = $false)]
		[Type] $Type = [String],
        [Parameter(Mandatory = $false)]
        [Switch] $Mandatory,
        [Parameter(Mandatory = $false)]
        [Int] $Position,
        [Parameter(Mandatory = $false)]
        [Switch] $ValueFromPipelineByPropertyName,
        [Parameter(Mandatory = $false)]
		[String] $HelpMessage,
		[Parameter(Mandatory = $false)]
		[String[]] $ValidateSet,
        [Parameter(Mandatory = $false)]
        [System.Management.Automation.RuntimeDefinedParameterDictionary] $RuntimeDefinedParameterDictionary
     )
     Begin
     {
        $ParameterAttribute = New-Object -TypeName System.Management.Automation.ParameterAttribute
        $ParameterAttribute.ParameterSetName = $ParameterSetName
        if($Mandatory)
        {
            $ParameterAttribute.Mandatory = $True
        }
        if($ValueFromPipelineByPropertyName)
        {
            $ParameterAttribute.ValueFromPipelineByPropertyName = $True
        }
        if($HelpMessage)
        {
            $ParameterAttribute.HelpMessage = $HelpMessage
        }
        if($Position)
        {
            $ParameterAttribute.Position = $Position
        }
 
        $AttributeCollection = New-Object -TypeName 'Collections.ObjectModel.Collection[System.Attribute]'
        $AttributeCollection.Add($ParameterAttribute)
    
        if($ValidateSet)
        {
            $ParamOptions = New-Object -TypeName System.Management.Automation.ValidateSetAttribute -ArgumentList $ValidateSet
            $AttributeCollection.Add($ParamOptions)
        }

        $Parameter = New-Object -TypeName System.Management.Automation.RuntimeDefinedParameter -ArgumentList @($Name, $Type, $AttributeCollection)
    
        if($RuntimeDefinedParameterDictionary)
        {
            $RuntimeDefinedParameterDictionary.Add($Name, $Parameter)
        }
        else
        {
            $RuntimeDefinedParameterDictionary = New-Object -TypeName System.Management.Automation.RuntimeDefinedParameterDictionary
            $RuntimeDefinedParameterDictionary.Add($Name, $Parameter)
            $RuntimeDefinedParameterDictionary
        }
    }
}