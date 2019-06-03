Import-Module \\contoso.local\netlogon\OnedriveLib.dll
#Find OneDrive folder
$path = $env:OneDriveCommercial

# Alternative:
# $path = $env:USERPROFILE + '\OneDrive'

#Get OneDrive status
$ODStatus = Get-ODStatus -ByPath $path
 
# or in short:
$ODStatus = Get-ODStatus -ByPath $env:OneDriveCommercial

if ($ODStatus = 'UpToDate' -or 'Syncing') {
    #OneDrive is connected
    write-host 'OneDrive connected and found'
    robocopy $env:HOMESHARE $env:OneDriveCommercial /E /SEC
    new-item $env:HOMESHARE -name '_FILES COPIED TO ONEDRIVE.txt' -ItemType 'file' -Value 'Files Copied
}
