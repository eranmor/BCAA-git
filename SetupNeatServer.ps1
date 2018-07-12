
# ******************* New Neat Server Setup *******************
# Author: Eran.Mor@bcaa.com
# Variables
﻿$BackUpPath = 'd:\jboss\jboss-as-NEAT_NonProd.zip'
$jbossDestination = 'd:\jboss\jboss-eap-6.4.0'
$BlazeDataLogFilesPath = "d:\BlazeDataLogFiles"
$jbossPath = "d:\jboss"
$windowsPath = 'c:\Windows'
$tmpPath = 'd:\tmp'
$dDrivePath = 'd:\'
$certsShare = '\\nea-tst-app030\c$\Users\johng\Desktop\certs'
$certsLocal = 'd:\certs'
$ipaddress = ([System.Net.DNS]::GetHostAddresses('PasteMachineNameHere')|Where-Object {$_.AddressFamily -eq "InterNetwork"}   |  select-object IPAddressToString)[0].IPAddressToString
$JbossWinTestUser = "bcaa.bc.ca\JbossWinTest"
$nbatchtUser = "bcaa.bc.ca\nbatcht"
$bamboouser = "bcaa.bc.ca\bamboo"

# Function Copy Item

Function CopyItem ($from, $to)
{
    if (!(Test-Path $to)) {
        md $to
    }
    Copy-Item -Path $from $to -Recurse -Force
    $?
   if($false) {Return}
 }
# Add Java System Variables

[System.Environment]::SetEnvironmentVariable('JAVA_HOME', 'D:\Java\jdk1.8.0_172' , [System.EnvironmentVariableTarget]::Machine)
[System.Environment]::SetEnvironmentVariable('JBOSS_HOME', 'D:\jboss\jboss-eap-6.4.0\jboss-eap-6.4', [System.EnvironmentVariableTarget]::Machine)
[System.Environment]::SetEnvironmentVariable('NOPAUSE', 1, [System.EnvironmentVariableTarget]::Machine)
[System.Environment]::SetEnvironmentVariable('SERVER_OPTS', '-b 0.0.0.0 -c standalone-full.xml -b 0.0.0.0 -c standalone-full.xml -P=%JBOSS_HOME%\standalone\deployments\neat.properties', [System.EnvironmentVariableTarget]::Machine)

# Create Folders

New-Item -ItemType directory -Path $BlazeDataLogFilesPath
New-Item -ItemType directory -Path $jbossPath

# Copy DB connector driver

CopyItem -from '\\Nova\public\John Goodsell\BuildNeatServer\sqljdbc_auth.dll' -to $windowsPath, $tmpPath

# Copy jboss-as-NEAT_NonProd.zip to d:\jboss

CopyItem -from '\\n-test-as22\d$\jboss\jboss-as-NEAT_NonProd.zip' -to $jbossPath

# copy \\n-test-as22\d$\scripts folder to d:\scripts and

CopyItem -from '\\n-test-as22\d$\scripts' -to $dDrivePath -Recurse

# copy certificates

CopyItem -from $certsShare -to $dDrivePath

#copy certificates to D:\Java\jdk1.8.0_112\jre\lib\security

CopyItem -from $certsLocal -to 'D:\Java\jdk1.8.0_112\jre\lib\security'
# Unzip jboss-as-NEAT_NonProd.zip to d:\jboss\jboss-eap-6.4.0

Add-Type -assembly "system.io.compression.filesystem"

[io.compression.zipfile]::ExtractToDirectory($BackUpPath, $jbossDestination)

# share the folder D:\jboss\jboss-eap-6.4.0\jboss-eap-6.4\standalone with everyone

NET SHARE standalone=D:\jboss\jboss-eap-6.4.0\jboss-eap-6.4\standalone "/GRANT:Everyone,READ"

# Install Jboss service

cmd.exe /c "D:\jboss\jboss-eap-6.4.0\jboss-eap-6.4\modules\system\layers\base\native\sbin\service.bat install /controller $ipaddress"

# add BCAA domain users to local Administrators Group

Add-LocalGroupMember -Group "Administrators" -Member $JbossWinTestUser, $nbatchtUser, $bamboouser
