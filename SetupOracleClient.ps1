
# Author: Eran Mor eran.mor@bcaa.com

# Variables
$oracleClientSourcePath = "\\bcaa.bc.ca\go\Support\Sw_apps\Oracle\12c\client"
$oracleClientSetupExecutable = "d:\OracleClient12\setup.exe"

Write-Host "Copy and install oracle client 12c"

Copy-Item $oracleClientSourcePath -Destination "d:\" -Recurse -Verbose -Force

Rename-Item -Path "d:\client" -NewName "OracleClient12" -Force

Write-Host "Install OracleClient12"

Start-Process $oracleClientSetupExecutable -NoNewWindow -Wait

Copy-Item "d:\Oracle\product\12.1.0\client_1\jdbc\lib" -Destination "d:\jboss\jboss-eap-6.4.0\jboss-eap-6.4\standalone\deployments\" -Recurse -Verbose -Force

Write-Host "Restarting JBossEAP6 service"

Restart-Service -Name JBossEAP6
