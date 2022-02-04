Start-Transcript -Path .\Desktop\testlog.txt


$users = Get-ADUser -Filter * -SearchBase "" | select -expand samaccountname
    
    foreach ($user in $users) {

        $homeDir = (Get-ADUser $user -Properties HomeDirectory).HomeDirectory
                If ($homeDir) { Write-Host $user ":: HomeFolder DOES Exist"}
                    Else { Write-Host $user ":: Does NOT exist" }
    }


    Write-Host "============================================================================================"

    $users = Get-ADUser -Filter * -SearchBase "" | select -expand samaccountname

    
    foreach ($user in $users) {

        $homeDir = (Get-ADUser $user -Properties HomeDirectory).HomeDirectory
                If ($homeDir) { Write-Host $user ":: HomeFolder DOES Exist"}
                    Else { Write-Host $user ":: Does NOT exist" }
    }



    Stop-Transcript
