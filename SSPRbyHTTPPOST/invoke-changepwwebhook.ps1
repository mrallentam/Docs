Param (
	[Parameter(Mandatory = $true,
			   ParameterSetName = "XXUSERNAME")]
	[String[]]$XXUSERNAME,
	
	[Parameter(Mandatory = $true,
			   ParameterSetName = "XXPASSWORD")]
	[String[]]$XXPASSWORD,
	
	[Parameter(Mandatory = $true,
			  ParameterSetName = "NEWESAEPASSWORD")]
	[String[]]$NEWESAEPASSWORD
	
	)

#Ping authentication
$pingurl=
$pinguser = $XXusername
$pingpass = $XXpassword
$secpingpasswd = ConvertTo-SecureString $pingpass -AsPlainText -Force
$pingcredential = New-Object System.Management.Automation.PSCredential($pinguser, $secpingpasswd)
$authorized = Invoke-RestMethod $pingurl -Credential $pingcredential

if ($authorized -eq $false) {
Write-output "User is not Authorized to change password"
exit}

else {
$USER = "z-"+$XXUSERNAME
[Byte[]]$key = (1 .. 16)
$PW = $NEWRDSPASSWORD | ConvertTo-SecureString -AsPlainText -Force
$Password = $pw | ConvertFrom-SecureString -key $key
$uri = "HTTP://URI"
$data = @(
		@{ User = "$user"; Password = "$password" }
		)
		$body = ConvertTo-Json -InputObject $data
		$header = @{ message = "changepasswordtest" }
		$response = Invoke-WebRequest -Method Post -Uri $uri -Body $body -Headers $header
		#$jobid = (ConvertFrom-Json ($response.Content)).jobids[0]
		
	}
	