<#

******************* New Neat Server Setup *******************
 Author: Eran Mor eran.mor@bcaa.com
 Variables

#>


$ZipLocalPath = "d:\jboss\jboss-as-NEAT_NonProd.zip"
$jbossDestination = "d:\jboss\jboss-eap-6.4.0"
$BlazeDataLogFilesPath = "d:\BlazeDataLogFiles"
$JbossZipLocation = "\\n-build-as2\e$\bamboo-home\BuildArchive\TrunkBuildServer\LOCAL_BUILD\jboss-as-NEAT_NonProd.zip"
$jbossPath = "d:\jboss"
$windowsPath = "c:\Windows"
$ProgramFiles = "C:\Program Files (x86)"
$dDrivePath = "d:\"
$certsShare = "\\nea-tst-app030\c$\users\johng\desktop\Certs\"
$certsLocal = "d:\certs"
$ip=get-WmiObject Win32_NetworkAdapterConfiguration|Where {$_.Ipaddress.length -gt 1}
$ipaddress = $ip.ipaddress[0]
$JbossWinTestUser = "bcaa.bc.ca\JbossWinTest"
$nbatchtUser = "bcaa.bc.ca\nbatcht"
$bamboouser = "bcaa.bc.ca\bamboo"
$CygwinFolder = "c:\"
$ScriptsShare = "\\nova\IS\NEAT"

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

write-host 'Creating d:\BlazeDataLogFiles and d:\jboss Folders'

New-Item -ItemType directory -Path $BlazeDataLogFilesPath, $jbossPath
# New-Item -ItemType directory -Path $jbossPath

Write-Host 'Copying DB connector driver'

CopyItem -from '\\Nova\public\John Goodsell\BuildNeatServer\sqljdbc_auth.dll' -to $windowsPath -Force -wait

Write-Host 'Copying pdfprint_cmd to ProgramFiles Folder'

CopyItem -from '\\Nova\public\John Goodsell\BuildNeatServer\pdfprint_cmd' -to $ProgramFiles -Force -verbose -Recurse -wait

Write-Host 'copying cygwin to c drive'

CopyItem -from '\\Nova\public\John Goodsell\BuildNeatServer\' -to $CygwinFolder -Force -verbose -Recurse -wait

Write-Host 'Copying jboss-as-NEAT_NonProd.zip to d:\jboss'

CopyItem -from $JbossZipLocation -to $jbossPath -Force -wait

Write-Host 'Copying \scripts folder to d:\scripts'

CopyItem -from $ScriptsShare -to $dDrivePath -Force -verbose -Recurse -wait

Write-Host 'Copying certificates'

CopyItem -from $certsShare -to $dDrivePath -Force -verbose -Recurse -wait

Write-Host 'copy certificates to D:\Java\jdk1.8.0_112\jre\lib\security'

CopyItem -from $certsLocal -to 'D:\Java\jdk1.8.0_112\jre\lib\security' -Force -verbose -Recurse -wait

Write-Host 'Unzip jboss-as-NEAT_NonProd.zip to d:\jboss\jboss-eap-6.4.0'

Add-Type -assembly "system.io.compression.filesystem"

[io.compression.zipfile]::ExtractToDirectory($ZipLocalPath, $jbossDestination)

Write-Host 'share the folder D:\jboss\jboss-eap-6.4.0\jboss-eap-6.4\standalone with everyone'

NET SHARE standalone=D:\jboss\jboss-eap-6.4.0\jboss-eap-6.4\standalone "/GRANT:Everyone,READ"

Write-Host 'Installing Jboss service'

cmd.exe /c "D:\jboss\jboss-eap-6.4.0\jboss-eap-6.4\modules\system\layers\base\native\sbin\service.bat install /controller $ipaddress"

Write-Host 'Adding BCAA domain users to local Administrators Group'

Add-LocalGroupMember -Group "Administrators" -Member $JbossWinTestUser, $nbatchtUser, $bamboouser
