Configuration Solution
{
    Param 
    (
        [parameter(Mandatory = $true)]
		[System.String]
		$SolutionName
    )
    
    Import-DscResource –Module PSDesiredStateConfiguration
    Import-DscResource -Module PackageManagementProviderResource

    Node $AllNodes.NodeName
    {
        $SolutionFolderPath = Join-Path -Path $Node.SolutionContainerFolder -ChildPath $SolutionName
        $SourceFolderPath = Join-Path -Path $SolutionFolderPath -ChildPath 'src'
        $NugetPackagesFolderPath = Join-Path -Path $SourceFolderPath -ChildPath 'packages'
        $NuGetFolderPath = Join-Path -Path $SourceFolderPath -ChildPath '.nuget'
        $NuGetConfigPath = Join-Path -Path $NuGetFolderPath -ChildPath 'NuGet.Config'

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

        File NuGetConfig {
            Type = 'File'
            DestinationPath = $NuGetConfigPath
            Ensure = 'Present'
            Contents = '<?xml version="1.0" encoding="utf-8"?>
                        <configuration>
                          <solution>
                            <add key="disableSourceControlIntegration" value="true" />
                          </solution>
                          <packageSources>
                          </packageSources>
                        </configuration>'
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
                DependsOn = '[File]NuGetConfig'
            }
        
            Script $PackageManagementSource.Name
            {
                GetScript = 
                {
                
                }
                SetScript =
                {
                    $packageSource = "<add key='$($PackageManagementSource.Name)' value='$($PackageManagementSource.SourceUri)' />"
                    
                    [xml] $NuGetConfig = Get-Content $NuGetConfigPath
                    $packageSourceElement = $NuGetConfig.CreateDocumentFragment()
                    $packageSourceElement.InnerXml = $packageSource   
                    $NuGetConfig.configuration.packageSources.add.AppendChild($packageSourceElement)
                    $NuGetConfig.Save($NuGetConfigPath)
                }
                TestScript = 
                {
                    [xml]$NuGetConfig = Get-Content $NuGetConfigPath
                    $PackageManagementSourceExists = $NuGetConfig.configuration.packageSources.add | where {$_.key -eq $PackageManagementSource.Name}
                }
                DependsOn = '[File]NuGetConfig'
                
            } 
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
    }
}

Solution -Verbose -ConfigurationData .\SolutionConfigurationData.psd1