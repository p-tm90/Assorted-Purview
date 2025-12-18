Set-Location $PSScriptRoot
. .\ModuleConnectionFunctions.ps1

Configure-MicrosoftModules -TypeOfConfiguration Purview -Scope CurrentUser

#Update modules & set up the connections
Write-Host "Do you need to update modules and connect to Microsoft Purview?"
$ConnectChoice = Read-Host "Type Y to update and connect, or any other key to skip"

If ($ConnectChoice -in @("Y")){
    Write-Host "Updating modules and connecting to Microsoft Purview..."
    Set-Location $PSScriptRoot
    . .\ModuleConnectionFunctions.ps1
    Configure-MicrosoftModules -TypeOfConfiguration Purview -InstallScope CurrentUser
}

Else {Write-Host "Skipping connection step as selected; proceeding with script execution."}

#Setup core variables.
$Location = $PSScriptRoot
$Date = Get-Date -Format "yyyyMMdd_HHmmss"
$ExportPath = ".\Outputs"
If (!(Test-Path -Path $ExportPath)){New-Item -ItemType Directory -Name "Outputs"}

#Gather existing DLP Rule packs.
$SITRulePacks = Get-DlpSensitiveInformationTypeRulePackage
Foreach ($Pack in $SITRulePacks){
    #Regular Export
    Write-Host "Exporting Rule Pack: $($Pack.RuleCollectionName)" -ForegroundColor Green
    
    $xml = New-Object System.Xml.XmlDocument
    $xml.PreserveWhitespace = $false
    $xml.LoadXml($Pack.ClassificationRuleCollectionXml)

    $settings = New-Object System.Xml.XmlWriterSettings
    $settings.Indent = $true
    $settings.IndentChars = '  '       # two spaces; change to "`t" for tabs
    $settings.NewLineChars = "`r`n"
    $settings.NewLineHandling = 'Replace'
    $settings.Encoding = [System.Text.Encoding]::UTF8

    $outFile = Join-Path $outDir ("{0}_{1}_RulePack.xml" -f $Date, $Pack.RuleCollectionName)
    $writer = [System.Xml.XmlWriter]::Create($outFile, $settings)
    $xml.Save($writer)
    $writer.Close()

    Write-Host "Formatted XML saved to: $outFile" -ForegroundColor Green
}