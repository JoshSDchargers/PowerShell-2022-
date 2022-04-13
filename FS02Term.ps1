$TermUser = "jtester"

New-Item -ItemType Directory -Force -Path C:\Users\$user\Desktop\Termination\$TermUser

New-Item -ItemType Directory -Force -Path C:\Users\$user\Desktop\Termination\$TermUser\P_Drive
Copy-Item -Path "\\FS01\Users\jaguirre\*" -Destination  "C:\Users\$users\Desktop\Termination\$TermUser\P_Drive" -Recurse

New-Item -ItemType Directory -Force -Path C:\Users\$users\Desktop\Termination\$TermUser\OneDrive


New-Item -ItemType Directory -Force -Path C:\Users\$user\Desktop\Termination\$TermUser\Outlook
