Function Initialize-Solution 
{
	[OutputType([Solution])]
	[CmdletBinding()]
	Param
	(
		[Parameter(Mandatory = $true)]
		[String] $SolutionName,
		[Parameter(Mandatory = $true)]
		[DirectoryStructure] $DirectoryStructure,
		[Parameter(Mandatory = $true)]
		[DevelopmentWorkflow] $DevelopmentWorkflow
	)
	Process	
	{	
	  Invoke-Commandline -Path git init [-q | --quiet] [--bare] [--template=<template_directory>]
	  [--separate-git-dir <git dir>]
	  [--shared[=<permissions>]] [directory]
	}
}

Function Invoke-Commandline
{
    Param
    (
        [System.IO.DirectoryInfo] $Path,
        [String[]] $Arguments
    )
    $OFS = " "
    $process = New-Object System.Diagnostics.Process
    $process.StartInfo.FileName = $FilePath
    $process.StartInfo.Arguments = $ArgumentList
    $process.StartInfo.UseShellExecute = $false
    $process.StartInfo.RedirectStandardOutput = $true
    if ( $process.Start() ) 
	{
    $output = $process.StandardOutput.ReadToEnd() -replace "\r\n$",""
    if ( $output ) 
	{
        if ( $output.Contains("`r`n") ) 
		{
			$output -split "`r`n"
        }
        elseif ( $output.Contains("`n") ) 
		{
			$output -split "`n"
        }
        else 
		{
			$output
        }
    }
    $process.WaitForExit()
    Invoke-Expression -Command "$Env:SystemRoot\system32\cmd.exe" `
        /c exit $process.ExitCode
    }
}