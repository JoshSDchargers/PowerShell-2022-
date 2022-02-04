 Start-Transcript -Path .\Desktop\PastEmpolyees.txt


    $users = Get-ADUser -Filter * -SearchBase "OU=Disabled Users,OU=Disabled,OU=Profil,DC=PICR,DC=local" | select -expand samaccountname
    $target = @()
    
    foreach ($user in $users) {

        $homeDir = (Get-ADUser $user -Properties HomeDirectory).HomeDirectory
                If ($homeDir) { 
                Write-Host $user ":: HomeFolder DOES Exist"
                $target += $user
                }
                    Else { Write-Host $user ":: Does NOT exist" }
    }

    Stop-Transcript