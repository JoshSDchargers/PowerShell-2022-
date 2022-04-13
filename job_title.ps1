$promotions = Import-Csv -Delimiter ";" -Path ad



<#
 -SearchBase ‘OU=,’ -Filter *

foreach($user in $promotions){
    $ADUser = Get-ADUser -Filter "displayname -eq '$($user.name)'" -Properties mail
    if ($ADUser){
        Set-ADUser -Identity $ADUser -Title $user.jobtitle
        Set-ADUser -Identity $ADUser -Title $user.department
        Set-ADUser -Identity $ADUser -Title $user.manager


    }
}
#>
