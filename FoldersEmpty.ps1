Start-Transcript -Path .\Desktop\EmptyFolder.txt

Get-ChildItem -Path \\domain.local\Files\users -Directory | Where-Object {$_.GetFiles().Count -eq 0}

Stop-Transcript
