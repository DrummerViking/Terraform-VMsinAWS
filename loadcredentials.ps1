if(-not(Test-Path .\accesskey.xml)) {
    Write-Host 'No credentials found. Please run "Get-Credential | Export-CliXml -Path ".\accesskey.xml"" first to save your AWS keys in an encrypted XML file.' -ForegroundColor Red
    exit
}
$cred = Import-Clixml .\accesskey.xml
$env:AWS_ACCESS_KEY_ID="$($cred.UserName)"
$env:AWS_SECRET_ACCESS_KEY="$($cred.GetNetworkCredential().password)"