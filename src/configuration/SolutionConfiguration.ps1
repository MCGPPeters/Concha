Configuration Solution
{
    Param 
    (
        [parameter(Mandatory = $true)]
		[System.String]
		$SolutionName
    )

    Set-Variable -Name NuGetOrgPackageSourceUri -Value 'http://nuget.org/api/v2/' -Option Constant

    Import-DscResource –Module PSDesiredStateConfiguration
    Import-DscResource -Module PackageManagementProviderResource
    Import-DscResource -Module SolutionPrerequisitesResource
    
    Node $AllNodes.NodeName
    {
        $SolutionFolderPath = Join-Path -Path $Node.SolutionContainerFolderPath -ChildPath $SolutionName
        $SourceFolderPath = Join-Path -Path $SolutionFolderPath -ChildPath 'src'
        $NugetPackagesFolderPath = Join-Path -Path $SourceFolderPath -ChildPath 'packages'
        $NuGetFolderPath = Join-Path -Path $SourceFolderPath -ChildPath '.nuget'

        SolutionPrerequisites EnsurePrerequisites
        {
        }

        File SolutionFolder {
            Type = 'Directory' 
            DestinationPath = $SolutionFolderPath
            Ensure = 'Present'
        }

        File SrcFolder {
            Type = 'Directory'
            DestinationPath = $SourceFolderPath
            Ensure = 'Present'
        }

        File NuGetPackesFolder {
            Type = 'Directory'
            DestinationPath = $NugetPackagesFolderPath
            Ensure = 'Present'
        }

        File TestsFolder {
            Type = 'Directory'
            DestinationPath = Join-Path -Path $SolutionFolderPath -ChildPath 'tests'
            Ensure = 'Present'
        }

        File DocsFolder {
            Type = 'Directory'
            DestinationPath = Join-Path -Path $SolutionFolderPath -ChildPath 'docs'
            Ensure = 'Present'
        }

        File SamplesFolder {
            Type = 'Directory'
            DestinationPath = Join-Path -Path $SolutionFolderPath -ChildPath 'samples'
            Ensure = 'Present'
        }

        File BuildFolder {
            Type = 'Directory'
            DestinationPath = Join-Path -Path $SolutionFolderPath -ChildPath 'build'
            Ensure = 'Present'
        }

        File ArtifactsFolder {
            Type = 'Directory'
            DestinationPath = Join-Path -Path $SolutionFolderPath -ChildPath 'artifacts'
            Ensure = 'Present'
        }

        File NuGetFolder {
            Type = 'Directory'
            DestinationPath = $NuGetFolderPath
            Ensure = 'Present'
        }

        NugetPackage NuGetCommandLine
        {
            Ensure          = 'Present' 
            Name            = 'nuget.commandline'
            RequiredVersion = '2.8.6'
            DestinationPath = $NugetPackagesFolderPath
        }

        $NuGetExePath = Get-ChildItem -Path $NugetPackagesFolderPath -Filter NuGet.exe -Recurse | Select-Object -First 1 -ExpandProperty FullName

        PackageManagementSource NuGet
        {
            Ensure = 'Present'
            Name        = 'NuGet'
            ProviderName= 'NuGet'
            SourceUri   = 'http://nuget.org/api/v2/'  
            InstallationPolicy ='Trusted'
        }

        NugetPackage GitVersion
        {
            Ensure          = 'Present' 
            Name            = 'gitversion.commandline'
            DestinationPath = $NugetPackagesFolderPath
            RequiredVersion = '3.0.2'
            DependsOn       = '[PackageManagementSource]NuGet'
        }
        
        NugetPackage GitReleaseManager
        {
            Ensure          = 'Present' 
            Name            = 'gitreleasemanager'
            DestinationPath = $NugetPackagesFolderPath
            RequiredVersion = '0.3.0'
            DependsOn       = '[PackageManagementSource]NuGet'
        }

        NugetPackage Psake
        {
            Ensure          = 'Present' 
            Name            = 'psake'
            DestinationPath = $NugetPackagesFolderPath
            RequiredVersion = '4.4.2'
            DependsOn       = '[PackageManagementSource]NuGet'
        }

        foreach($PackageManagementSource in $Node.PackageManagementSources)
        {
            PackageManagementSource $PackageManagementSource.Name
            {
                Ensure      = $PackageManagementSource.Ensure
                Name        = $PackageManagementSource.Name
                ProviderName= $PackageManagementSource.ProviderName 
                SourceUri   = $PackageManagementSource.SourceUri
                InstallationPolicy = $PackageManagementSource.InstallationPolicy
            }
        }          
    }
}

Solution -Verbose -ConfigurationData .\SolutionConfigurationData.psd1