$Menu = "None"
$GroupArray = Get-ADPrincipalGroupMembership -Identity jaguirre | foreach {$_.SamAccountName}

   while ($true) {

    for(($i = -1), ($p = 1); $i -lt $GroupArray.Length-1; ($i++), ($p++)) {
        
        Write-Host $p")" $GroupArray[$i]

    }

     $Menu = Read-Host -Prompt "Enter Group Number you want to delete (or C to continue)"

     if ($Menu -eq "C") { 
          exit 
          }

     
     if ($Menu -ne "C") { 

          Write-Host "hello"

          $GroupArray = $GroupArray | Where-Object { $_ -ne $GroupArray[$Menu-2] }

          }




            
   }