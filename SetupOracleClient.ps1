
# Author: Eran Mor eran.mor@bcaa.com

# Variables
$oracleClientSourcePath = '\\bcaa.bc.ca\go\Support\Sw_apps\Oracle\12c\client'
$oracleClientSetupExecutable = 'D:\OracleClient12\setup.exe'

# Copy and install oracle client 12c

Copy-Item -from  $oracleClientSourcePath -to 'd:\' -wait
Rename-Item -Path 'd:\client' -NewName "OracleClient12"
& $oracleClientSetupExecutable -wait
Copy-Item -from 'D:\Oracle\product\12.1.0\client_1\jdbc\lib' -to 'D:\jboss\jboss-eap-6.4.0\jboss-eap-6.4\standalone\deployments\'
