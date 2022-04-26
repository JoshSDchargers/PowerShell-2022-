#Author: Joshua Aguirre
#Date Created: 4/13/2022
#Last Modified: 4/13/2022
#Discription: Quick Termination Script for PROSCIENTO offboarding (Phase 1)

$DesktopPath = [System.Environment]::GetFolderPath([System.Environment+SpecialFolder]::Desktop)

#============================================================================================================================================================

#User's first Var's
$sAMAccountName = Read-Host -Prompt "Please enter the User logon name to be disabled"
$TermUser = Get-ADUser -Identity $sAMAccountName | Select-Object -ExpandProperty name
$UserEmail = Get-ADUser -Identity $sAMAccountName | Select-Object -ExpandProperty UserPrincipalName

Write-Host "Gathering Users Info" -ForegroundColor Yellow


#User Add Prop
#Disable-ADAccount -Identity $sAMAccountName # Disable's user account
Set-Aduser -Identity $sAMAccountName -ChangePasswordAtLogon $false #Uncheck "User must change password"


#Change User's Password 
$minLength =  10 ## characters
$maxLength = 15 ## characters
    $length = Get-Random -Minimum $minLength -Maximum $maxLength
    $password = [System.Web.Security.Membership]::GeneratePassword($length, $AlphaChars)
        $OutInt = "$sAMAccountName = $password"
        $OutInt >> C:\Users\jaadmin\Desktop\Termination\Log\New_Users_Password.txt
        Write-Host "Changing User's Password..." -ForegroundColor Yellow


$Encrypted = ConvertTo-SecureString "$password" -AsPlainText -Force
Set-ADAccountPassword -Identity  $sAMAccountName -NewPassword $Encrypted -Reset
Write-Host "Encrypting Password..." -ForegroundColor Yellow

#================================================================================================================================================
# AD Logging


$TermUser >>  "$Home\Desktop\Termination\Log\PastEmployees_Account_Info.txt"

date >>  C:\Users\jaadmin\Desktop\Termination\Log\PastEmployees_Account_Info.txt

Get-ADUser -Identity $sAMAccountName -Properties title,department,company,manager,UserPrincipalName | Select-Object name,title,department,company,manager,UserPrincipalName  >>  C:\Users\jaadmin\Desktop\Termination\Log\PastEmployees_Account_Info.txt

"Active Dir Groups" >>  C:\Users\""\Desktop\Termination\Log\PastEmployees_Account_Info.txt

$RemoveGroup = Get-ADPrincipalGroupMembership -Identity $sAMAccountName | Select-Object name 

$RemoveGroup | Out-File -FilePath C:\Users\""\Desktop\Termination\Log\PastEmployees_Account_Info.txt -Append

Write-Host "Logging user's account information" -ForegroundColor Yellow

# "<<<<=================================================================================>>>>" >>  C:\Users''\Desktop\Termination\Log\PastEmployees_Account_Info.txt



#==================================================================================================================================================
# Delete all groups except, Domain Users, Okta AppProv-O365 E3-E1-P1, and MDM-Users if there. 
     $RemoveLoop = Get-ADPrincipalGroupMembership -Identity $sAMAccountName | foreach name         
    
           for($i=0; $i -le $RemoveLoop.Length-1; $i++) {
        
            if(  ($RemoveLoop[$i] -ne "Domain Users") -AND 
                 ($RemoveLoop[$i] -ne "MDM - Users") -AND
                 ($RemoveLoop[$i] -ne "Okta-AppProv-O365-E1") -AND
                 ($RemoveLoop[$i] -ne "Okta-AppProv-O365-E3") -AND
                 ($RemoveLoop[$i] -ne "Okta-Appprov-O365-PhoneSystem") -AND
                 ($RemoveLoop[$i] -ne "Okta-AppProv-M365-E3") -AND
                 ($RemoveLoop[$i] -ne "Okta-AppProv-O365-P1") 
               ) {


            Remove-ADGroupMember -Identity $RemoveLoop[$i] -Members $sAMAccountName

            }
     
      }

    Write-Host "Removing User from all groups." -ForegroundColor Yellow

#===================================================================================================================================================
#9.	Clear ALL the fields in the Organization Tab. Make sure to “Clear” the Manager Name.
    Write-Host "Clearing $TermUser's organization information"
    Set-ADUser -Identity $sAMAccountName -Title $null -Department $null -Company $null -Manager $null


#=================================================================================================================================================
#Forward User's Email

Connect-ExchangeOnline

$ForwardLoop = Read-Host -Prompt "Forward User's Email in Office Portal?(Y/N)"

if($ForwardLoop -eq "Y") {

    $ForwardEmail = Read-Host -Prompt "Enter Forward user's email:"
     Set-Mailbox -Identity $TermUser -ForwardingAddress $ForwardEmail
     Write-Host "Email Forwarded" -ForegroundColor Yellow

    }

Disconnect-ExchangeOnline


#=================================================================================================================================================
#Disable Account

Connect-AzureAD 

Get-AzureADUser -SearchString $sAMAccountName | Revoke-AzureADUserAllRefreshToken #ExpireToken



$TeamsGroup = Get-AzureADUser -SearchString $sAMAccountName | Get-AzureADUserMembership | Where-Object {$_.Description -Like "*Teams*"} | Select DisplayName, Description
"==============================================================================================" | Out-File -filepath C:\Users\''\Desktop\Termination\Log\TeamsGroup.txt -append
$sAMAccountName,$TeamsGroup | Out-File -filepath C:\Users\""\Desktop\Termination\Log\TeamsGroup.txt -append

$TeamsGroup = Get-AzureADUser -SearchString $sAMAccountName | Get-AzureADUserMembership | Where-Object {$_.Description -Like "*Teams*"} | Select DisplayName -ExpandProperty DisplayName

$TeamsGroup = $TeamsGroup | ft -HideTableHeaders



$UserID = Get-AzureADUser -ObjectId $sAMAccountName  | Select ObjectId -ExpandProperty Objectid

#get all objects
$GroupID = Get-AzureADUser -SearchString $sAMAccountName | Get-AzureADUserMembership | Where-Object {$_.Description -Like "*Teams*"} | Select ObjectId -ExpandProperty ObjectId



for($i=0; $i -le $GroupID.Length-1; $i++) {
            
  Remove-AzureADGroupMember -ObjectId $GroupID[$i] -MemberId $UserID

    }


Set-AzureADUser -ObjectID $UserEmail -AccountEnabled $false

Disconnect-AzureAD



#=================================================================================================================================================
#Download Email
Read-Host -Prompt "Run a Okta Sync (Press any key to continue)"

#=================================================================================================================================================
#Adding AD Attributes

ForEach-Object { Set-AdUser -Identity $sAmAccountName -Clear ProxyAddresses  }

$user = $sAmAccountName
Get-ADObject -LDAPFilter "(sAmAccountName=$user)" | Set-ADObject -replace @{msExchHideFromAddressLists=$true}



