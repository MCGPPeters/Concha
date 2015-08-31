Import-Module (Get-ChildItem "$nuget-folder\.nuget\pester.*\tools\pester.psm1" | Select-Object -First 1)

Invoke-Pester -Script tests\* -CodeCoverage src\*

Remove-Module Pester
 