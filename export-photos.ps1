$FullName =Import-Csv "Desktop\Hired.csv"

$NameFlat = $FullName.name


for(($i = 0); $i -lt $NameFlat.Length; $i++) {
  
  
  get-mailbox $NameFlat[$i] | % {Get-UserPhoto $_.identity} | % {Set-Content -path "C:\temp\sec\$($_.identity).jpg" -value $_.picturedata -Encoding byte}


 } 