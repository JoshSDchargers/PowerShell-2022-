#requires -version 3.0
#Remove-UserProfile.ps1
[cmdletbinding(SupportsShouldProcess)]
Param(
[Parameter(Position=0)]
[ValidateNotNullorEmpty()]
[int]$Days=30
)
Start-Transcript -Path C:\ProfileCleanup.txt -Append
Write-Warning "Filtering for user profiles older than $Days days" 
Get-CimInstance win32_userprofile -Verbose | 
Where {$_.LastUseTime -lt $(Get-Date).Date.AddDays(-$days)} |
Remove-CimInstance -Verbose
Stop-Transcript