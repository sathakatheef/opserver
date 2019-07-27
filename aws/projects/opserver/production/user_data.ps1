<powershell>

## RENAME COMPUTER
$instance_id = Invoke-RestMethod -Uri "http://169.254.169.254/latest/meta-data/instance-id"
$instance_name = Get-EC2Tag | ?{$_.ResourceID -like $instance_id -and $_.Key -like "Name"} | %{$_.Value}
$rename_result = Rename-Computer $instance_name -PassThru -Force


## INSTALL SALT MINION AND REGISTER TO SALTMASTER
Read-S3Object -BucketName 1stop-config-templates -Key minion -File C:\1stop\minion

Invoke-WebRequest -Uri "https://repo.saltstack.com/windows/Salt-Minion-2018.3.3-Py2-AMD64-Setup.exe" -OutFile "C:\Users\Administrator\Downloads\Salt-Minion-2018.3.3-Py2-AMD64-Setup.exe"

Start-Process "C:\Users\Administrator\Downloads\Salt-Minion-2018.3.3-Py2-AMD64-Setup.exe"  -ArgumentList "/S /master=saltmaster /minion-name=$instance_name /custom-config=C:\1stop\minion /start-minion=0" -Wait

# Define contents of grains file
$grains = @'
roles:
- managed
- web-server
'@

# Create grains file
$grains | Out-File -FilePath 'C:\salt\conf\grains' -Force


# Set task scheduler to manual run salt-call after next boot with delay of 5mins after minion start
$Sta1 = New-ScheduledTaskAction -Execute "Powershell" -Argument '-NoProfile -WindowStyle Hidden -command "& salt-call state.apply --out-file=C:\salt\var\log\salt\1st_manual_run *>&1 > C:\salt\var\log\salt\1st_manual_run.error"'
$Stt1 = New-ScheduledTaskTrigger -AtStartup -RandomDelay (new-Timespan -Minutes 5)
$Stp1 = New-ScheduledTaskPrincipal -UserID "NT AUTHORITY\SYSTEM" -LogonType ServiceAccount
Register-ScheduledTask 00-Manual-Run-Salt-Call -Action $Sta1 -Trigger $Stt1 -Principal $Stp1

# Set task scheduler to restart minion after next boot with delay of 15mins after salt-call
# This is needed for salt to pick up git ENV path
$Sta2 = New-ScheduledTaskAction -Execute "Powershell" -Argument '-NoProfile -WindowStyle Hidden -command "& Restart-Service Salt-minion"'
$Stt2 = New-ScheduledTaskTrigger -AtStartup -RandomDelay (new-Timespan -Minutes 15)
$Stp2 = New-ScheduledTaskPrincipal -UserID "NT AUTHORITY\SYSTEM" -LogonType ServiceAccount
Register-ScheduledTask 00-Restart-Salt-minion -Action $Sta2 -Trigger $Stt2 -Principal $Stp2
Start-Service "salt-minion"

## SET SSM DOCUMENT TO AUTO-JOIN DOMAIN
Set-DefaultAWSRegion -Region ap-southeast-2
New-SSMAssociation -InstanceId $instance_id -Name "ssm_document_to_join_the_domain"

## CHECK IF REBOOT IS REQUIRED
# Requires a restart after install a role
if (Get-ChildItem "HKLM:\Software\Microsoft\Windows\CurrentVersion\Component Based Servicing\RebootPending" -EA Ignore)
{
      $rebootRequired = $true
}

# Windows Update Requires a reboot
if (Get-Item "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Auto Update\RebootRequired" -EA Ignore)
{
      $rebootRequired = $true
}

# Pending file Rename Operations to complete updates
if (Get-ItemProperty "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager" -Name PendingFileRenameOperations -EA Ignore)
{
      $rebootRequired = $true
}

## REBOOT IF REQUIRED
if ($rebootRequired -or $rename_result.HasSucceeded) {
#  Wait-Job -Job $jobs -Timeout 15
  # Try to reboot indefinitely as Ec2Config may cancel reboots until it's finished
  while ($true)
  {
      Restart-Computer -Force
      Start-Sleep 15
  }
}

</powershell>
