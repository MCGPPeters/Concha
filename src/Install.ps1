#Requires -Version 5.0
#Requires -runasadministrator

Install-Module -Name GitHubShell
Install-Module -Name GitFlowShell
Install-Module -Name SolutionShell

Import-Module -Name GitHubShell
Import-Module -Name GitFlowShell
Import-Module -Name SolutionShell

#setup the GitHub access token
$securedAccessToken = Read-Host -Prompt "Please enter a valid GitHub OAuth access token. You can acquire a personal token via https://github.com/settings/tokens" -AsSecureString
Set-GitHubAccessToken -SecuredAccessToken $securedAccessToken

#install package manager providers
Get-PackageProvider -Name Chocolatey -ForceBootstrap
Get-PackageProvider -Name NuGet -ForceBootstrap

#install git-flow
Install-Package -Name devbox-gitflow
Install-Package -Name nuget.commandline