<#
    .SYNOPSIS
        Checks for a connected device

    .DESCRIPTION
        Checks for a specific Plug and Play (PnP) Device. Use Get-PnpDevice to find the DeviceID.

    .INPUTS
        DeviceID: String like SWD\PRINTENUM\WSD-CD4A8906-A0E6-4D88-81BC-1C6C35E46631

    .OUTPUTS
        Errorlevel 0 if device found; 1 for device missing; 2+ for other problems.

    .EXAMPLE
        Win_Check_Device.ps1 -DeviceID "SWD\PRINTENUM\WSD-CD4A8906-A0E6-4D88-81BC-1C6C35E46631"

    .NOTES
        Changelog
        v 0.1.0 initial version

    .LINK
        https://github.com/zetaworx/tacticalrmm-scripts
#>

[CmdletBinding()]
param(
    [Parameter(Mandatory=$true)]
    [string[]]
    $DeviceID
)

Write-Verbose "Checking Status and PNP DeviceID: $DeviceID"
try {
    $X = Get-PnpDevice | Where { ( $_.PNPDeviceID -eq $DeviceID ) -and ( $_.Status -eq "OK" ) } -ErrorAction Stop
}
catch {
    $Exception = $_.Exception
    Write-Host "ERROR: something went wrong $Exception"
    Exit 2
}

Write-Verbose "Found: $($X)"

If ( $X -ne $null ) {
    Write-Host "Device found: $($X.Description)"
    Exit 0
}
else {
    Write-Host "Device not found"
    Exit 1
}
