$OUpath = 'ou=Employees,ou=Accounts,ou=Profil,dc=PICR,dc=local'
Get-ADUser -Filter * -SearchBase $OUpath | Select-object DistinguishedName,Name,UserPrincipalName | Export-Csv -NoType OU1.Csv