TaskSetup {
    $taskName = $($psake.context.Peek().currentTaskName)
    Write-Verbose $taskName
    TeamCity-ReportBuildProgress "Running Task $taskName"
}

TaskTearDown {
    $taskName = $($psake.context.Peek().currentTaskName)
    TeamCity-CloseBlock $taskName
}

Task Default -Depends Compile

Task Init -Depends EnsureDesiredState

Task EnsureDesiredState {
    tasks\EnsureDesiredState.ps1
}

Task Test -Depends Compile {
	tasks\Test.ps1
}

Task Compile -Depends RestoreDependencies {
	
}

Task Clean {
    tasks\Clean.ps1
}

Task VersionModule {
    $version = Get-Version

	(Get-Content $psd_path) -replace "ModuleVersion = \'.+'", "ModuleVersion = '$script:AssemblyVersion'"  | Set-Content $psd_path -Encoding UTF8
}

Task RestoreDependencies {
    tasks\RestoreDependencies.ps1
}

Task Package {
    $version = Get-Version

    if ($version) {

        gci "$root_folder" -Recurse -Include *.nuspec | % {
            exec { 
                & $nuget_path pack $_ -o $artifacts_folder -version $version.NuGetVersionV2 
            }
        }
    } else {
        Write-Output "Warning: could not get version. No packages will be created."
    }
}