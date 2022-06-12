<#
    .SYNOPSIS
    Checks the Windows activation status

    .DESCRIPTION
    Uses CIM to check if Windows is activated.

    .INPUTS
    None

    .OUTPUTS
    Errorlevel 0 if activated; 1 if activation ist missing; 2+ for other problems.

    .EXAMPLE
    .\Win_Activation_Status.ps1
    
    .NOTES
        Changelog
        v 0.1.0 initial version

    .LINK
        https://github.com/zetaworx/tacticalrmm-scripts
#>

[CmdletBinding()]
param()

try {
    $X = Get-CIMInstance -query "select Name, Description, LicenseStatus, ProductKeyChannel from SoftwareLicensingProduct where LicenseStatus=1" -ErrorAction Stop
}
catch {
    Write-Host "ERROR: Problem getting data. $($_.Exception.Message)"
    Exit 2
}

Write-Verbose "Description:  $($X.Description)"
Write-Verbose "Name: $($X.Name)"
Write-Verbose "ProductKeyChannel $($X.ProductKeyChannel)"
Write-Verbose "License: $($X.LicenseStatus)"

If ($X.ProductKeyChannel -match "Eval") {
    Write-Host "Windows is not activated. You are running a trial version. Product: $($X.Description)"
    Exit 1
} 

If ($X.Name -like "Windows*") {
    Write-Host "Windows is activated. Product: $($X.Description)"
    Exit 0
} else {
    Write-Host "Windows is not activated"
    Exit 1
}
