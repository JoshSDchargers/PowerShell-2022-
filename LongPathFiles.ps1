#Joshua Aguirre
#Last Modified: 03/21/2022
#LongPathScript.ps1


Remove-Item C:\Users""\Desktop\LongPath\OutputMain\*
Remove-Item C:\Users""\Desktop\LongPath\Output\*


cmd /c dir Z:\ /s /b |? {$_.length -gt 250} >> C:\Users""\Desktop\LongPath\OutputMain\Z-Drive.csv
cmd /c dir P:\ /s /b |? {$_.length -gt 250} >> C:\Users""\Desktop\LongPath\OutputMain\P-Drive.csv
cmd /c dir O:\ /s /b |? {$_.length -gt 250} >> C:\Users""\Desktop\LongPath\OutputMain\xxxx.csv
cmd /c dir N:\ /s /b |? {$_.length -gt 250} >> C:\Users""\Desktop\LongPath\OutputMain\Archive_IT.csv
cmd /c dir M:\ /s /b |? {$_.length -gt 250} >> C:\Users""\Desktop\LongPath\OutputMain\Archive_xxxx.csv

dir C:\Users\jaadmin\Desktop\LongPath\OutputMain\* -include *.csv -rec | gc | out-file  C:\Users""\Desktop\LongPath\OutputMain\LongPaths.csv





$PathNames = @()
$PathNames = Import-Csv C:\Usersxxxxxx\Desktop\LongPath\OutputMain\LongPaths.csv -Header c1 -Delimiter ';'
$PathNumber = $PathNames.Length
  

$HoldValue = $PathNames[1]


for($i = 0 ; $i -lt $PathNumber; $i++) {

       $NOPath = 0
     
     $HoldValue = $PathNames[$i]
 
        if($HoldValue -clike '*C:*') {

        $NOPath = 1

            Write-Host "Remove from List"
  
        }

        if($HoldValue -clike '*N:\HR\Ex-Employee\*') {

               $NOPath = 1

            $HoldValue |  select -ExpandProperty c1 | Out-File C:\Users\jaadmin\Desktop\LongPath\Output\Ex-Employees.csv -Append -Encoding unicode
  
        }

       if($HoldValue -clike '*P:*') {

               $NOPath = 1

                 $HoldValue.Length, $HoldValue |  select -ExpandProperty c1 | Out-File C:\Usersxxxxxxxx\Desktop\LongPath\Output\P_Drive.csv -Append -Encoding unicode
  
        }


         if($HoldValue -clike '*Z:\Op*') {

                $NOPath = 1
          
            $HoldValue |  select -ExpandProperty c1 | Out-File C:\Users\jaadmin\Desktop\LongPath\Output\xxxx.csv -Append -Encoding unicode
  
  
        }

        
         if($HoldValue -clike '*Z:\Operations\Project Management\*') {

                $NOPath = 1
            $HoldValue |  select -ExpandProperty c1 | Out-File C:\Users\jaadmin\Desktop\LongPath\Output\xxx.csv -Append -Encoding unicode
     
  
  
        }

             
         if($HoldValue -clike '*Z:\Operations\Studies\*') {

                $NOPath = 1
          
            $HoldValue |  select -ExpandProperty c1 | Out-File C:\Usersxxxxxxxx\Desktop\LongPath\Output\xxx.csv -Append -Encoding unicode
  
  
        }


         if($HoldValue -clike '*Z:\B*') {
                $NOPath = 1
       
            $HoldValue |  select -ExpandProperty c1 | Out-File C:\Users\xxxxx\Desktop\LongPath\Output\Budget_and_Contract.csv -Append -Encoding unicode
  
  
        }

          if($HoldValue -clike '*Z:\M*') {

                 $NOPath = 1

            $HoldValue |  select -ExpandProperty c1 | Out-File C:\Users\jaadmin\Desktop\LongPath\Output\Finance_and_Accounting.csv -Append -Encoding unicode
  
  
        }

    
          if($HoldValue -clike '*Z:\QA*') {
            
            $NOPath = 1

            $HoldValue |  select -ExpandProperty c1 | Out-File C:\Users""\Desktop\LongPath\Output\Quality_Assurance.csv -Append -Encoding unicode
  
  
        }

        
          if($HoldValue -clike '*Z:\C*') {
            
            $NOPath = 1

            $HoldValue |  select -ExpandProperty c1 | Out-File C:\Users\jaadmin\Desktop\LongPath\Output\xxx.csv -Append -Encoding unicode
  
  
        }


          if($HoldValue -clike '*Z:\P*') {
            
            $NOPath = 1

            $HoldValue |  select -ExpandProperty c1 | Out-File C:\Users""\Desktop\LongPath\Output\Pharmaceutical.csv -Append -Encoding unicode
  
  
        }


        if($NOPath -eq 0) {

        $HoldValue |  select -ExpandProperty c1 | Out-File C:\Users""\Desktop\LongPath\Output\NeedsWork.csv -Append -Encoding unicode


        }
        

       
      }