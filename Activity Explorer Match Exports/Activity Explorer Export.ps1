#Settings script execution location.
$Location = $PSScriptRoot
Set-Location $Location
$OutputsPath = "$Location\Outputs"

#Importing core functions & initiate connection to Purview.
. .\Dependencies\ModuleConnectionFunctions.ps1
Configure-MicrosoftModules -TypeOfConfiguration Purview -InstallScope CurrentUser

