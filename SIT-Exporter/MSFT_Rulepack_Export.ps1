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
    
    $Xml = New-Object System.Xml.XmlDocument
    $Xml.PreserveWhitespace = $False
    $Xml.LoadXml($Pack.ClassificationRuleCollectionXml)

    $Settings = New-Object System.Xml.XmlWriterSettings
    $Settings.Indent = $True
    $Settings.IndentChars = '  '       # two spaces; change to "`t" for tabs
    $Settings.NewLineChars = "`r`n"
    $Settings.NewLineHandling = 'Replace'
    $Settings.Encoding = [System.Text.Encoding]::UTF8

    $OutFile = Join-Path "$Location\Outputs" ("{0}_{1}_RulePack.xml" -f $Date, $Pack.RuleCollectionName)
    $Writer = [System.Xml.XmlWriter]::Create($OutFile, $Settings)
    $Xml.Save($Writer)
    $writer.Close()

    Write-Host "Formatted XML saved to: $($OutFile)" -ForegroundColor Green
}