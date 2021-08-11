
##############################
# Define output stream type
[OutputType([object])]

# Define runbook input params
Param
(
        [Parameter(Mandatory=$true)]
        [pscredential] 
        $xxxusername,

        [Parameter(Mandatory=$true)]
        [pscredential] 
        $xxxpassword,

        [Parameter(Mandatory=$true)]
        [PSCredential] 
        $NewRDSPassword,
)

$con = Get-AutomationConnection -Name "AzureRunAsConnection"

Connect-AzAccount `
    -ServicePrincipal `
    -Tenant $con.TenantId `
    -ApplicationId $con.ApplicationId `
    -CertificateThumbprint $con.CertificateThumbprint 

#invoke webrequest for 
$authenticated = invoke 

if ($authenticated -eq $false){
write-output "Error User not verified through xxx"
exit   
}
else
{
                                                               
$guser="z-"+$xxxusername

mkdir c:\temp\pwinfo

$guser|out-file c:\temp\pwinfo\user.txt
$file="c:\temp\pwinfo\pw.txt"
[Byte[]] $key = (1..16)
$Password =  $NewRDSPassword| ConvertTo-SecureString -AsPlainText -Force
$Password | ConvertFrom-SecureString -key $key | Out-File $File
start-sleep -seconds 5


Start-Process -verb runas PowerShell.exe -argumentlist '-command invoke-command -scriptblock {
$action = New-ScheduledTaskAction -Execute PowerShell.exe -argument "{
$rfuser=get-content c:\temp\pwinfo\user.txt
[Byte[]] $key = (1..16)
$pwd=Get-Content c:\temp\pwinfo\pw.txt|ConvertTo-SecureString -Key $key
Set-ADAccountPassword -Identity $rfuser -Reset -NewPassword $pwd 
}"
$trigger= New-ScheduledTaskTrigger -At 12am -Once
Register-ScheduledTask -Action $action -TaskName ChangePassword -RunLevel highest -Trigger $trigger
}'
start-sleep -seconds 5

Start-Process -verb runas PowerShell.exe -argumentlist '-command invoke-command -scriptblock {
$principal = New-ScheduledTaskPrincipal -UserId domain\gmsaaccount -LogonType Password -RunLevel highest
Set-ScheduledTask ChangePassword -Principal $principal
}'
start-sleep -seconds 5

Start-Process -verb runas PowerShell.exe -argumentlist '-command Start-ScheduledTask -TaskName ChangePassword'
start-sleep -seconds 5

Start-Process -verb runas PowerShell.exe -argumentlist '-command Unregister-ScheduledTask -TaskName ChangePassword -Confirm:$false'
start-sleep -seconds 5

Start-Process -verb runas PowerShell.exe -argumentlist '-command remove-item -path c:\temp\pwinfo -recurse -force'
}
