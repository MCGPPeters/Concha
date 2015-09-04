#Requires -Version 5.0
#Requires -runasadministrator

Configuration Prerequisites
{
	Set-WSManQuickConfig -SkipNetworkProfileCheck -Force

    Install-Module -Name cChoco

    Import-DscResource -Module cChoco

    cChocoInstaller Chocolatey
    {
        InstallDir = $Node.ChocolateyPackagesFolderPath
    }

    cChocoPackageInstaller GitFlow
    {
        Name = 'devbox-gitflow'
        DependsOn = '[cChocoInstaller]Chocolatey'
    }
}

Prerequisites -Verbose -ConfigurationData .\PrerequisitesConfigurationData.psd1