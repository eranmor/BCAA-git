# Cawa clinet setup and FW rule

.\setup.exe -f "win_installer.properties"

Write-Host "Creating FW rule"
netsh advfirewall firewall add rule name="Allow CAWA Connections" dir=in action=allow protocol=TCP localport=7520 remoteip=192.197.3.48,192.197.3.49

Write-hos "Setting CA Workload Automation Agent to start automatically"
Set-Service -Name "CA Workload Automation Agent" -StartupType Automatic
Start-Service -Name "CA Workload Automation Agent"
