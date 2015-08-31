
function Get-Version {
    Write-Verbose 'message' @{ text="getting git version using $($gitversion_path)" }

    $result = Invoke-Expression "$gitversion_path /u $gitVersionUserName /p $gitVersionPassword"

    if ($LASTEXITCODE -ne 0){
        Write-Error 'message' @{ text="GERROR $($result)" }
    } else{
        return ConvertFrom-Json ($result -join "`n");
    }
}