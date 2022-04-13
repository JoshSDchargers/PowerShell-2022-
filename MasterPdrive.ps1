#Joshua Aguirre
#02/01/2022



#=================================================================================================
#PhaseOne (ADCheckHomeDir.ps1)

Start-Transcript -Path .\Desktop\Paudit\log\CurrentEmployeesList.txt
$targetCurrent = @()
$targetCurrentList = @()

    $users = Get-ADUser -Filter * -SearchBase "OU=" | select -expand samaccountname
    
        foreach ($user in $users) {
        $targetCurrentList += $user
            
            $homeDir = (Get-ADUser $user -Properties HomeDirectory).HomeDirectory
                    If ($homeDir) { Write-Host $user ":: HomeFolder DOES Exist"}
                        Else { 
                            Write-Host $user ":: Does NOT exist" 
                            $targetCurrent += $user
                        }
        }

          $targetCurrent| Out-File .\Desktop\Paudit\Employees_WO_Pdrives.txt


Write-Host "============================================================================================"

    $users = Get-ADUser -Filter * -SearchBase "OU=" | select -expand samaccountname
    $targetContractors = @()
    $targetContractorsList = @()
   
    foreach ($user in $users) {
    $targetContractorsList += $user

        $homeDir = (Get-ADUser $user -Properties HomeDirectory).HomeDirectory
            If ($homeDir) { Write-Host $user ":: HomeFolder DOES Exist"}
                    
                    Else { 
                    Write-Host $user ":: Does NOT exist" 
                    $targetContractors += $user
                  
                    }
    }

    $targetContractors | Out-File .\Desktop\Paudit\Contractors_WO_Pdrives.txt


        Stop-Transcript

  #=================================================================================================
  #PhaseTwo (ADdisableHome.ps1)

   Start-Transcript -Path .\Desktop\Paudit\log\PastEmpolyees.txt


    $users = Get-ADUser -Filter * -SearchBase "OU=" | select -expand samaccountname
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

      
  #=================================================================================================
  #PhaseThree (GetFolderName.ps1)

  $FolderName = Get-ChildItem -Path \\picr.local\Files\users -Directory | foreach Name 

  #=================================================================================================
  #PhaseFour(CompareArray.ps1) 

  $SameName = Compare-Object -IncludeEqual -ExcludeDifferent $FolderName $target
  $SameName | Out-File .\Desktop\Paudit\Disable_Users_with_Pdrives.txt

  #=================================================================================================
  #PhaseFive (FoldersEmpty.ps1)
  #Empty All Folders

  $EmptyNames = Get-ChildItem -Path \\picr.local\Files\users -Directory | Where-Object {$_.GetFiles().Count -eq 0} | foreach Name
  $EmptyNames | Out-File .\Desktop\Paudit\Compare\Empty_PDrive.txt

  #=================================================================================================
  #Folder's with Data
  $Namedata = Get-ChildItem -Path \\picr.local\Files\users -Directory | Where-Object {$_.GetFiles().Count -gt 0} | foreach Name
  $Namedata | Out-File .\Desktop\Paudit\Compare\Data_In_PDrive.txt

  #=================================================================================================
  #Empty and Inactive

  $emptyIN = Compare-Object -IncludeEqual -ExcludeDifferent $EmptyNames $target
  $emptyIN | Out-File .\Desktop\Paudit\Compare\Empty_and_Inactive.txt

  #================================================================================================= 
  #Empty and Active Current Empolyees

  $emptyACT = Compare-Object -IncludeEqual -ExcludeDifferent $targetCurrentlist $EmptyNames
  $emptyACT | Out-File .\Desktop\Paudit\Compare\Empty_and_Active_Employees.txt

  #=================================================================================================
  #Empty and Active Contractors

  $emptyCON = Compare-Object -IncludeEqual -ExcludeDifferent $targetContractorsList $EmptyNames
  $emptyCON | Out-File .\Desktop\Paudit\Compare\Empty_and_Active_Contractors.txt


  #=================================================================================================
  #With Data and Disable Users

  $ActiveDD = Compare-Object -IncludeEqual -ExcludeDifferent $Namedata $target
  $ActiveDD | Out-File .\Desktop\Paudit\Compare\With_Data_and_Disabled.txt

  
  #=================================================================================================
  #With Data and Current Employees Users

  $ActiveEE = Compare-Object -IncludeEqual -ExcludeDifferent $Namedata $targetCurrentList
  $ActiveEE | Out-File .\Desktop\Paudit\Compare\With_Data_and_Current_Employee.txt

  #=================================================================================================
  #With Data and Current Contrators Users

  $ActiveCC = Compare-Object -IncludeEqual -ExcludeDifferent $Namedata $targetContractorsList
  $ActiveCC | Out-File .\Desktop\Paudit\Compare\With_Data_and_Current_ContractorsList.txt




