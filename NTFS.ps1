$OutFile = "C:\Temp\Permissions.csv" # Insert folder path where you want to save your file and its name 
$RootPath = "" # Insert your share directory path 






$Header = "Folder Path,IdentityReference,AccessControlType,IsInherited,InheritanceFlags,PropagationFlags" 
# $Header = "Folder Path,IdentityReference,AccessControlType,IsInherited,InheritanceFlags,PropagationFlags,FilesystemRights" 
$FileExist = Test-Path $OutFile  
If ($FileExist -eq $True) {Del $OutFile}  
Add-Content -Value $Header -Path $OutFile  
$Folders = dir $RootPath -recurse | where {$_.psiscontainer -eq $True}  
foreach ($Folder in $Folders){ 
   $ACLs = get-acl $Folder.fullname | ForEach-Object { $_.Access  } 
   Foreach ($ACL in $ACLs){ 
   $OutInfo = $Folder.Fullname + "," + $ACL.IdentityReference  + "," + $ACL.AccessControlType + "," + $ACL.IsInherited + "," + $ACL.InheritanceFlags + "," + $ACL.PropagationFlags  
#  If you need detailed file system rights in your report, add the following at the end of previous line:  
# + "," + ($ACL.FileSystemRights -replace ',','/' ) 
   Add-Content -Value $OutInfo -Path $OutFile  
   }}
