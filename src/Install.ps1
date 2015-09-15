#Requires -Version 5.0
#Requires -runasadministrator

#configure the GitHub access token
$securedAccessToken = Read-Host -Prompt "Please enter a valid GitHub OAuth access token. You can acquire a personal token via https://github.com/settings/tokens" -AsSecureString
Set-GitHubAccessToken -SecuredAccessToken $securedAccessToken

#install package manager providers
Get-PackageProvider -Name Chocolatey -ForceBootstrap
Get-PackageProvider -Name NuGet -ForceBootstrap

#add system wide package sources
Register-PackageSource -Name eVision-ci -ProviderName NuGet -Location https://evision.myget.org/F/ci/auth/8159a17d-97ca-4f3a-8f95-63d34705ac0f -ForceBootstrap -Trusted
Register-PackageSource -Name eVision-main -ProviderName NuGet -Location https://evision.myget.org/F/main/auth/8159a17d-97ca-4f3a-8f95-63d34705ac0f -ForceBootstrap -Trusted
Register-PackageSource -Name chocolatey.org -ProviderName Chocolatey -Location http://chocolatey.org/api/v2/ -ForceBootstrap -Trusted

#install system wide packages
Install-Package -Name devbox-gitflow -MinimumVersion 2.8.6 -MaximumVersion 2.9.9 -Source chocolatey.org -ProviderName Chocolatey

#install system wide modules
Install-Module -Name Posh-Git -MinimumVersion 0.5.0 -MaximumVersion 1.9.9 -Force
Install-Module -Name GitHubShell -MinimumVersion 1.0.0 -MaximumVersion 1.9.9 -Force
Install-Module -Name GitFlowShell -MinimumVersion 1.0.0 -MaximumVersion 1.9.9 -Force
Install-Module -Name SolutionShell -MinimumVersion 1.0.0 -MaximumVersion 1.9.9 -Force