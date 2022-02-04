#Get-ChildItem -Path \\picr.local\Files\users -Directory | select Name 
$FolderName = Get-ChildItem -Path \\picr.local\Files\users -Directory | foreach Name 


<#
foreach ($elem in $A) { if ($B -contains $elem) { "there is a match" } }
$FolderName | Where {$target -notcontains $_}
$target | Where {$FolderName -notcontains $_}
$target | Where {$FolderName -contains $_}
#>