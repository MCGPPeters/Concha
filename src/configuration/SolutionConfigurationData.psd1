@{
    AllNodes = 
    @(
        @{
            NodeName = '*'
            SolutionContainerFolder = 'c:\dev'
            PackageManagementSources = 
            @(
                @{
                    Ensure = 'Present'
                    Name        = 'NuGet'
                    ProviderName= 'NuGet'
                    SourceUri   = 'http://nuget.org/api/v2/'  
                    InstallationPolicy ='Trusted'
                },
                @{
                    Ensure = 'Present'
                    Name        = 'eVision-ci'
                    ProviderName= 'NuGet'
                    SourceUri   = 'https://evision.myget.org/F/ci/auth/8159a17d-97ca-4f3a-8f95-63d34705ac0f'  
                    InstallationPolicy ='Trusted'
                },
                @{
                    Ensure = 'Present'
                    Name        = 'eVision-main'
                    ProviderName= 'NuGet'
                    SourceUri   = 'https://evision.myget.org/F/main/auth/8159a17d-97ca-4f3a-8f95-63d34705ac0f'  
                    InstallationPolicy ='Trusted'
                }
            );
        }

        @{
            NodeName = 'localhost'
        }
    );
}
