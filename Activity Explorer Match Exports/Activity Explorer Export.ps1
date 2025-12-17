#Settings script execution location.
$Location = $PSScriptRoot
Set-Location $Location
$OutputsPath = "$Location\Outputs"

#Importing core functions & initiate connection to Purview.
. .\Dependencies\Functions.ps1
Configure-MicrosoftModules -TypeOfConfiguration Purview -InstallScope CurrentUser

