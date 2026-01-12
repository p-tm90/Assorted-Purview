. "$PSScriptRoot\Prerequisites.ps1"


Configure-MicrosoftModules -TypeOfConfiguration Purview -InstallScope CurrentUser

$LabelName = Read-Host "Enter Retention Label Name to Remove"
$RetentionRules = Get-RetentionComplianceRule | Where-Object {
    $_.ApplyComplianceTag -like "*$($LabelName)" -or `
    $_.ComplianceTagProperty -like "*$($LabelName)" -or `
    $_.PublishComplianceTag -like "*$($LabelName)"
}

$PolicyNames = @()
Foreach ($Rule in $RetentionRules) {
    $Policy = Get-RetentionCompliancePolicy -Identity $Rule.Policy
    $PolicyNames += $Policy
}

Write-Host "Policies tied to the label '$LabelName':"
Foreach ($PolicyName in $PolicyNames){
        Write-Host "• Policy Name: $($PolicyName.Name)`n•Policy GUID: $($PolicyName.GUID)`n" -ForegroundColor Cyan
}