<#
A. Change UPN to *-term@
B. Clear proxyAddresses attribute
C. Set msExchHideFromAddressLists to True
D. Clear mail field
#>


$changeUPN = Get-ADUser -Identity zanton | foreach {$_.UserPrincipalName}

<# $changeUPN[-15] #>

$Count = $changeUPN.Length - 15


$changeUPN = $changeUPN.Insert($Count,'-term')

<# It’s an array field, so load proxy data , remove the element , replace it #>


$BaseOU = "OU=Employees,OU=Accounts,OU=Profil,DC=PICR,DC=local"


ForEach-Object { Set-AdUser -Identity jtester -Clear ProxyAddresses  }


$user="jtester"

Get-ADObject -LDAPFilter "(sAmAccountName=$user)" | Set-ADObject -replace @{msExchHideFromAddressLists=$true}