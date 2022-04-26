#Author: Joshua Aguirre
#Date Created: 2/4/2022
#Last Modified: 4/13/2022
#Discription: Termination Script for 

    

#============================================================================================================================================================
#Make Term Folders

$directoyPath="$Home\Desktop\Termination";
$directoyPathTwo="$Home\Desktop\Termination\Log";
$directoyPathThree="$Home\Desktop\Termination\Log\Ex_Employees_Account_Info";

if(!(Test-Path -path $directoyPath))  
{  
    New-Item -ItemType directory -Path $directoyPath
    Write-Host "Folder path has been created successfully at: " $directoyPath             
}
else
{
    Write-Host "The given folder path $directoyPath already exists" -ForegroundColor Green
}

if(!(Test-Path -path $directoyPathTwo))  
{  
    New-Item -ItemType directory -Path $directoyPathTwo
    Write-Host "Folder path has been created successfully at: " $directoyPathTwo             
}
else
{
    Write-Host "The given folder path $directoyPathTwo already exists" -ForegroundColor Green
}

if(!(Test-Path -path $directoyPathThree))  
{  
    New-Item -ItemType directory -Path $directoyPathThree
    Write-Host "Folder path has been created successfully at: " $directoyPathThree             
}
else
{
    Write-Host "The given folder path $directoyPathThree already exists" -ForegroundColor Green
}


#============================================================================================================================================================

#User's first Var's
$sAMAccountName = Read-Host -Prompt "Please enter the User logon name to be disabled"
$TermUser = Get-ADUser -Identity $sAMAccountName | Select-Object -ExpandProperty name
$UserEmail = Get-ADUser -Identity $sAMAccountName | Select-Object -ExpandProperty UserPrincipalName

Write-Host "Gathering Users Info" -ForegroundColor Yellow

#=============================================================================================================================================================
#Global Var
      
    $Naming = Get-ADUser -Identity $sAmAccountName | Select GivenName, Surname, UserPrincipalName
    $FirstName = $Naming.GivenName
    $LastName = $Naming.Surname
    $Email = $Naming.UserPrincipalName
    $FName = $FirstName + " " +$LastName


#User Add Prop
#Disable-ADAccount -Identity $sAMAccountName # Disable's user account
Set-Aduser -Identity $sAMAccountName -ChangePasswordAtLogon $false #Uncheck "User must change password"

#=============================================================================================================================================================

#Change User's Password 
$minLength =  10 ## characters
$maxLength = 15 ## characters
    $length = Get-Random -Minimum $minLength -Maximum $maxLength
    $password = [System.Web.Security.Membership]::GeneratePassword($length, $AlphaChars)
        $OutInt = "$sAMAccountName = $password"
        $OutInt >> "$home\Desktop\Termination\Log\New_Users_Password.txt"
        Write-Host "Changing User's Password..." -ForegroundColor Yellow


$Encrypted = ConvertTo-SecureString "$password" -AsPlainText -Force
Set-ADAccountPassword -Identity  $sAMAccountName -NewPassword $Encrypted -Reset
Write-Host "Encrypting Password..." -ForegroundColor Yellow

#===============================================================================================================================================================
# AD Logging


$TermUser >>  "$Home\Desktop\Termination\Log\Ex_Employees_Account_Info\$FName.txt"

date >>  "$Home\Desktop\Termination\Log\Ex_Employees_Account_Info\$FName.txt"

Get-ADUser -Identity $sAMAccountName -Properties title,department,company,manager,UserPrincipalName | Select-Object name,title,department,company,manager,UserPrincipalName  >>  "$Home\Desktop\Termination\Log\Ex_Employees_Account_Info\$FName.txt"

"User's AD Group Membership" | Out-File -FilePath "$Home\Desktop\Termination\Log\Ex_Employees_Account_Info\$FName.txt" -Append

$RemoveGroup = Get-ADPrincipalGroupMembership -Identity $sAMAccountName | Select-Object name 

$RemoveGroup | Out-File -FilePath "$Home\Desktop\Termination\Log\Ex_Employees_Account_Info\$FName.txt" -Append

Write-Host "Logging user's account information" -ForegroundColor Yellow


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


            Remove-ADGroupMember -Identity $RemoveLoop[$i] -Members $sAMAccountName -erroraction 'silentlycontinue'

            }
     
      }

    Write-Host "Removing User from all groups." -ForegroundColor Yellow

#===================================================================================================================================================
#9.	Clear ALL the fields in the Organization Tab. Make sure to “Clear” the Manager Name.
    Write-Host "Clearing $TermUser's organization information"
    Set-ADUser -Identity $sAMAccountName -Title $null -Department $null -Company $null -Manager $null -EmailAddress $null


#=================================================================================================================================================
#Forward User's Email

Connect-ExchangeOnline

$ForwardLoop = Read-Host -Prompt "Forward User's Email in Office Portal?(Y/N)"

if($ForwardLoop -eq "Y") {

    $ForwardEmail = Read-Host -Prompt "Enter Forward user's email:"
     Set-Mailbox -Identity $TermUser -ForwardingAddress $ForwardEmail
     Write-Host "Email Forwarded" -ForegroundColor Yellow

    }

#=================================================================================================================================================
#Cancel All Meetings

$Calremove = Read-Host -Prompt "Would you like cancel all user's meetings?(Y/N)"

if($Calremove -eq "Y") {

   Remove-CalendarEvents -Identity $sAMAccountName -CancelOrganizedMeetings -QueryWindowInDays 730
   Write-Host "Canceling all Organized Meetings" -ForegroundColor Yellow

  }

Disconnect-ExchangeOnline

#=================================================================================================================================================
#Disable Account

Connect-AzureAD 

Get-AzureADUser -SearchString $sAMAccountName | Revoke-AzureADUserAllRefreshToken #ExpireToken


$TeamsGroup = Get-AzureADUser -SearchString $sAMAccountName | Get-AzureADUserMembership | Where-Object {$_.Description -Like "*Teams*"} | Select DisplayName, Description
"==============================================================================================" | Out-File -filepath "$Home\Desktop\Termination\Log\Ex_Employees_Account_Info\$FName.txt" -append
"User's Teams Group" | Out-File -filepath "$Home\Desktop\Termination\Log\Ex_Employees_Account_Info\$FName.txt" -append
$TeamsGroup | Out-File -filepath "$Home\Desktop\Termination\Log\Ex_Employees_Account_Info\$FName.txt" -append
$TeamsGroup = Get-AzureADUser -SearchString $sAMAccountName | Get-AzureADUserMembership | Where-Object {$_.Description -Like "*Teams*"} | Select DisplayName -ExpandProperty DisplayName
$TeamsGroup = $TeamsGroup | ft -HideTableHeaders

$UserID = Get-AzureADUser -ObjectId $sAMAccountName  | Select ObjectId -ExpandProperty Objectid
$GroupID = Get-AzureADUser -SearchString $sAMAccountName | Get-AzureADUserMembership | Where-Object {$_.Description -Like "*Teams*"} | Select ObjectId -ExpandProperty ObjectId



for($i=0; $i -le $GroupID.Length-1; $i++) {
            
  Remove-AzureADGroupMember -ObjectId $GroupID[$i] -MemberId $UserID

    }


Set-AzureADUser -ObjectID $UserEmail -AccountEnabled $false

Disconnect-AzureAD


#=================================================================================================================================================
#Download Email

Read-Host -Prompt "Run a Okta Sync (Press any key to continue)"
Start-Process ""
Start-Sleep -Seconds 25
Read-Host -Prompt "Done?(Press any key to continue)"

#=================================================================================================================================================
#Adding AD Attributes

ForEach-Object { Set-AdUser -Identity $sAmAccountName -Clear ProxyAddresses  }
$user = $sAmAccountName
Get-ADObject -LDAPFilter "(sAmAccountName=$user)" | Set-ADObject -replace @{msExchHideFromAddressLists=$true}

#=====================================================================================================================================================
$Answer = Read-Host -Prompt "Would you like to Email Distro forward group for the user's email(Y/N)"

 if($Answer -eq "Y") {

        #Create Distro List
        $Naming = Get-ADUser -Identity $sAmAccountName | Select GivenName, Surname, UserPrincipalName
        $FirstName = $Naming.GivenName
        $LastName = $Naming.Surname
        $Email = $Naming.UserPrincipalName
        $NameString = "$FirstName $LastName Forward"
        $proxy = "SMTP:$Email"

        #change user ad prop
        $changeUPN = Get-ADUser -Identity $sAmAccountName  | foreach {$_.UserPrincipalName}
        $Count = $changeUPN.Length - 15
        $changeUPN = $changeUPN.Insert($Count,'-term')
        Get-ADUser $sAmAccountName | Set-ADUser -UserPrincipalName "$changeUPN"


        ForEach-Object { Set-AdUser -Identity $sAmAccountName -Clear ProxyAddresses  }


        Write-Host "Sync with Okta and wait 3 Hours" -ForegroundColor Red
        Start-Sleep -Seconds 10


        $user = $sAmAccountName
        Get-ADObject -LDAPFilter "(sAmAccountName=$user)" | Set-ADObject -replace @{msExchHideFromAddressLists=$true}


        New-ADGroup -Name "$NameString" -GroupCategory Distribution -GroupScope Global -Path "" -OtherAttributes @{'mail'="$Email";'proxyAddresses'=$proxy;'msExchHideFromAddressLists'=$True}
        
          $userForward = Get-ADUser -LDAPFilter "(mail=$ForwardEmail)"
          $sAMAccountNameForwardUser = $userForward.sAMAccountName

          $ForwardFName = $userForward.GivenName
          $ForwardLName = $userForward.Surname

          $FTName = $ForwardFName+" " +$ForwardLName
          $ToName = "Forward to " + $FTName

          Add-ADGroupMember $NameString -Members $sAMAccountNameForwardUser
          Set-ADGroup -Identity $NameString -Description $ToName
     

}
       


 if($Answer -eq "N") {


        $Naming = Get-ADUser -Identity $sAmAccountName | Select GivenName, Surname, UserPrincipalName
        $FirstName = $Naming.GivenName
        $LastName = $Naming.Surname
        $Email = $Naming.UserPrincipalName

           ForEach-Object { Set-AdUser -Identity $sAmAccountName -Clear ProxyAddresses  }
           $user="$sAmAccountName"
           Get-ADObject -LDAPFilter "(sAmAccountName=$user)" | Set-ADObject -replace @{msExchHideFromAddressLists=$true}

}

#=================================================================================================================================================
#Move User's data and make Directories

New-Item -ItemType Directory -Force -Path X:\$FName
New-Item -ItemType Directory -Force -Path X:\$FName\P_Drive
New-Item -ItemType Directory -Force -Path X:\$FName\OneDrive
New-Item -ItemType Directory -Force -Path X:\$FName\OutLook
New-Item -ItemType Directory -Force -Path X:\$FName\Account_Information
Copy-Item -Path "\\FS01\Users\$sAMAccountName\*" -Destination  "X:\$FName\P_Drive" -Recurse
Copy-Item -Path "$Home\Desktop\Termination\Log\Ex_Employees_Account_Info\$FName.txt*" -Destination  "X:\$FName\Account_Information" -Recurse
