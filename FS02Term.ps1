$TermUser = "jtester"

New-Item -ItemType Directory -Force -Path C:\Users\jaadmin\Desktop\Termination\$TermUser

New-Item -ItemType Directory -Force -Path C:\Users\jaadmin\Desktop\Termination\$TermUser\P_Drive
Copy-Item -Path "\\FS01\Users\jaguirre\*" -Destination  "C:\Users\jaadmin\Desktop\Termination\$TermUser\P_Drive" -Recurse

New-Item -ItemType Directory -Force -Path C:\Users\jaadmin\Desktop\Termination\$TermUser\OneDrive


New-Item -ItemType Directory -Force -Path C:\Users\jaadmin\Desktop\Termination\$TermUser\Outlook
