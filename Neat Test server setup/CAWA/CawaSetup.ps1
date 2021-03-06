# Cawa client setup and FW rule

$CawaServerIp1=192.197.3.48
$CawaServerIp2=192.197.3.49
Write-Host 'Installing CAWA Agent'

& cmd.exe /c setup.exe -f "win_installer.properties"

Start-Sleep -s 30


Write-Host "Creating FW rule"
netsh advfirewall firewall add rule name="Allow CAWA Connections" dir=in action=allow protocol=TCP localport=7520 remoteip=$CawaServerIp1,$CawaServerIp2

Write-host "Setting CA Workload Automation Agent to start automatically"

Set-Service -Name 'CA Workload Automation Agent' -StartupType Automatic

# Start-Service -Name 'CA Workload Automation Agent'
