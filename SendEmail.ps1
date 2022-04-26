$From = ""
$To = ""
$Subject = "Subject Here"
$SMTPServer = "smtp.office365.com"
$SMTPPort = "587"
$SMTPUsername = ""
$GetPassword = ""
$SMTPPassword = $GetPassword | ConvertTo-SecureString  -AsPlainText -Force
$SMTPCredentials = new-object Management.Automation.PSCredential $SMTPUsername, $SMTPPassword
$Body = "Message for body"
#$Attachment = "C:\temp\temp.txt"
Send-MailMessage  -From $From -to $To -Subject $Subject -Body $Body -SmtpServer $SMTPServer -port $SMTPPort -UseSsl -Attachments $Attachment -Credential $SMTPCredentials -DeliveryNotificationOption OnSuccess