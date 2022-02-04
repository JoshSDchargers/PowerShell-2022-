$certificateThumbprint = "9BCE7405DD63FD8DE7486FDD32D111667197BB8E" # TODO: modify me
$usernameMicrosoft365 = "%userPrincipalName%" # TODO: modify me
$destinationFolderPath = "\\Server\Share\%username%" # TODO: modify me
$tenantName = "MyTenant" # TOOD: modify me
$oneDriveSiteURL = "https://$tenantName-my.sharepoint.com/personal" # TODO: modify me

# Build OneDrive URL
$charsToReplace = @(".", "@")
$charsToReplace | %%{$usernameMicrosoft365 = $usernameMicrosoft365.Replace($_, "_")}
$oneDriveSiteURL = "$oneDriveSiteURL/$usernameMicrosoft365"

# Connecto to SharePoint Online
$tenant = $Context.CloudServices.GetO365Tenant()
$credential = $tenant.GetCredential()

try
{
    $connection = Connect-PnPOnline -Url $oneDriveSiteURL -ClientId $credential.AppId -Thumbprint $certificateThumbprint -Tenant "$tenantName`.onmicrosoft.com" -ReturnConnection
    
    # Get all items
    try
    {
        $items = Get-PnPListItem -List Documents -ErrorAction Stop
    }
    catch
    {
        $Context.LogMessage("An error occurred when retrieving OneDrive items. Error: " + $_.Exception.Message, "Error")
        return
    }
    
    if ($null -eq $items)
    {
        return # No items found
    }
    
    # Create directory structure
    $folders = $items | Where-Object {$_.FileSystemObjectType -eq "Folder"}
    $oneDrivePath = "/personal/$usernameMicrosoft365/Documents"
    foreach ($folder in $folders)
    {
        $folderPath = $folder.FieldValues.FileRef.Replace($oneDrivePath, "").Replace("/", "\")
        try
        {
            New-Item -Path "$destinationFolderPath$folderPath" -Force -ItemType "directory" -ErrorAction Stop
        }
        catch
        {
            $Context.LogMessage("An error occurred when creating the directory structure. Error: " + $_.Exception.Message, "Error")
            return
        }
    }
    
    # Download files
    $files = $items | Where-Object {$_.FileSystemObjectType -eq "File"}
    foreach ($file in $files)
    {
        $localFolderPath = $file.FieldValues.FileDirRef.Replace($oneDrivePath, "").Replace("/", "\")
        try
        {
            Get-PnPFile -Url $file.FieldValues.FileRef -Path "$destinationFolderPath$localFolderPath" -AsFile -Filename $file.FieldValues.FileLeafRef -ErrorAction Stop
        }
        catch
        {
            $Context.LogMessage("An error occurred when downloading the file $($file.FieldValues.FileRef). Error: " + $_.Exception.Message, "Warning")
            continue
        }
    }
}
finally
{
    # Close the connection and release resources
    if ($connection) { Disconnect-PnPOnline -Connection $connection }
}