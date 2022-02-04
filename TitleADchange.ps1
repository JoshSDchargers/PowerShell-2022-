for($i=0; $i -le $data.Length-1; $i++) {

   try {

    $nameVarb = $data.username[$i]
    $AccountLock = Get-ADUser -Filter "userPrincipalName -eq '$nameVarb'" | select SamAccountName


    if(!$AccountLock){
          Write-Host "Couldnt find UPN for:" $data.username[$i] -ForegroundColor Green
  
    }

    if($AccountLock){
         set-ADUser $AccountLock.SamAccountName -Department $data.department[$i] -Title $data.Job[$i]
    }

    $accountfind = $data.manager[$i]
    $accountname = Get-ADUser -Filter {Name -eq $accountfind} |Select-Object samaccountname

    if($accountname) {
         set-ADUser $AccountLock.SamAccountName -Manager $accountname
    }
    if(!$accountname){
         Write-Host "Couldnt find Manager for:" $data.username[$i] -ForegroundColor Red
   
    }
}

catch {
     Write-Host "User failed:" -NoNewline -ForegroundColor Yellow ; Write-Host $data.username[$i] -ForegroundColor Yellow
   }
}