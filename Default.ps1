properties {
    $solution           = "Concha.sln"
    $target_config      = "Release"

    $base_directory     = Resolve-Path .
    $src_directory      = "$base_directory\src"
    $output_directory   = "$base_directory\build"
    $tools_directory    = "$base_directory\tools"
    $nuget_directory    = "$tools_directory\.nuget"
	$package_directory  = "$nuget_directory"

	$nuget_path         = "$nuget_directory\nuget.exe"
    $nugetConfig_path   = "$nuget_directory\nuget.config"

	$chocolatey_path    = FindTool("chocolatey.*\tools\chocolateyInstall\choco.exe")

    $sln_path           = "$src_directory\$solution"
    $psd_path           = "$src_directory\Concha.psd"
       
    $gitversion_path    = FindTool("GitVersion.CommandLine.*\tools\GitVersion.exe")
	
    $code_coverage      = $true

    $gitVersionUserName = ""
    $gitVersionPassword = ""
}

TaskSetup {
    $taskName = $($psake.context.Peek().currentTaskName)
    TeamCity-OpenBlock $taskName
    TeamCity-ReportBuildProgress "Running task $taskName"
}

TaskTearDown {
    $taskName = $($psake.context.Peek().currentTaskName)
    TeamCity-CloseBlock $taskName
}

task default -depends CopyOutput, Package

task Init -depends Clean, RestoreNuget, VersionModule

task Test{
	Invoke-Pester -Script $src_directory\*.tests.ps1 -CodeCoverage $src_directory\*.psm1
}

task CopyOutput -depends Test{
	Copy-Item -Path $src_directory\*.psm1 -Destination $output_directory
}

task Clean {
    EnsureDirectory $output_directory

    Remove-Item -Path $output_directory -Filter * -Recurse
}

task VersionModule {
    $version = Get-Version

	(Get-Content $psd_path) -replace "ModuleVersion = \'.+'", "ModuleVersion = '$script:AssemblyVersion'"  | Set-Content $psd_path -Encoding UTF8
}

task RestoreNuget {
    Get-SolutionPackages |% {
        "Restoring " + $_
        &$nuget_path install $_ -o $package_directory -configfile $nugetConfig_path
    }
}

task Package {
    $version = Get-Version

    if ($version) {

        gci "$base_directory" -Recurse -Include *.nuspec | % {
            exec { 
                & $nuget_path pack $_ -o $output_directory -version $version.NuGetVersionV2 
            }
        }
    } else {
        Write-Output "Warning: could not get version. No packages will be created."
    }
}

function EnsureDirectory {
    param($directory)

    if(!(test-path $directory)) {
        mkdir $directory
    }
}

function Get-SolutionPackages {
    gci $src_directory -Recurse "packages.config" -ea SilentlyContinue | foreach-object { $_.FullName }
}

function Get-Version {
    TeamCity-WriteServiceMessage 'message' @{ text="getting git version using $($gitversion_path)" }

    $result = Invoke-Expression "$gitversion_path /u $gitVersionUserName /p $gitVersionPassword"

    if ($LASTEXITCODE -ne 0){
        TeamCity-WriteServiceMessage 'message' @{ text="GERROR $($result)" }
    } else{
        return ConvertFrom-Json ($result -join "`n");
    }
}

function FindTool {
    param(
        [string] $name
    )

    $result = Get-ChildItem "$package_directory\$name" | Select-Object -First 1

    return $result.FullName
}