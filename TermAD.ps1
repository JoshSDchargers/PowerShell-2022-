<#
In AD
    1. Change Pass
    2. Get Org info and Groups
    3. Clear Org info
    #>

$sAMAccountName = Read-Host -Prompt "Please enter the User logon name to be disabled"
$TermUser = Get-ADUser -Identity $sAMAccountName | Select-Object -ExpandProperty name
    
    $NewPass = Read-Host "Create a new password for $TermUser's account" <#-AsSecureString#>
    $OutInt = "$sAMAccountName = $NewPass"
    $OutInt >> C:\Users\xxxxx\Desktop\Termination\pwd.txt




     date >>  C:\Users\jaadmin\Desktop\Termination\OrgTab.txt
     Get-ADUser -Identity $sAMAccountName -Properties title,department,company,manager, UserPrincipalName | Select-Object name,title,department,company,manager,UserPrincipalName  >>  C:\Users\jaadmin\Desktop\Termination\OrgTab.txt
     "Active Dir Groups" >>  C:\Users\jaadmin\Desktop\Termination\OrgTab.txt
     Get-ADPrincipalGroupMembership -Identity $sAMAccountName | Select-Object name >> C:\Users\jaadmin\Desktop\Termination\OrgTab.txt
     "<<<<=================================================================================>>>>" >>  C:\Users\xxxx\Desktop\Termination\OrgTab.txt





     <#   
     Write-Host "Clearing $TermUser's organization information"
     Set-ADUser -Identity $sAMAccountName -Title $null -Department $null -Company $null -Manager $null
     #>
