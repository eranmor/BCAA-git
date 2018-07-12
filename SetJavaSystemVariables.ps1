$BackUpPath = 'd:\jboss\jboss-as-NEAT_NonProd.zip'
$destination = 'd:\jboss\jboss-eap-6.4.0'


# Add Java System Variables

[System.Environment]::SetEnvironmentVariable('JAVA_HOME', 'D:\Java\jdk1.8.0_172' , [System.EnvironmentVariableTarget]::Machine)
[System.Environment]::SetEnvironmentVariable('JBOSS_HOME', 'D:\jboss\jboss-eap-6.4.0\jboss-eap-6.4', [System.EnvironmentVariableTarget]::Machine)
[System.Environment]::SetEnvironmentVariable('NOPAUSE', 1, [System.EnvironmentVariableTarget]::Machine)
[System.Environment]::SetEnvironmentVariable('SERVER_OPTS', '-b 0.0.0.0 -c standalone-full.xml -b 0.0.0.0 -c standalone-full.xml -P=%JBOSS_HOME%\standalone\deployments\neat.properties', [System.EnvironmentVariableTarget]::Machine)

# Copy DB connector driver

Copy-Item -Path '\\Nova\public\John Goodsell\BuildNeatServer\sqljdbc_auth.dll' -Destination 'c:\Windows'
Copy-Item -Path '\\Nova\public\John Goodsell\BuildNeatServer\sqljdbc_auth.dll' -Destination 'd:\tmp'

# Create Folders

New-Item -ItemType directory -Path d:\BlazeDataLogFiles
New-Item -ItemType directory -Path d:\jboss

# Copy jboss-as-NEAT_NonProd.zip to d:\jboss

Copy-Item '\\n-test-as22\d$\jboss\jboss-as-NEAT_NonProd.zip' -Destination 'd:\jboss'

# Unzip jboss-as-NEAT_NonProd.zip to d:\jboss\jboss-eap-6.4.0

Add-Type -assembly "system.io.compression.filesystem"

[io.compression.zipfile]::ExtractToDirectory($BackUpPath, $destination)

# share the folder D:\jboss\jboss-eap-6.4.0\jboss-eap-6.4\standalone with everyone

NET SHARE standalone=D:\jboss\jboss-eap-6.4.0\jboss-eap-6.4\standalone "/GRANT:Everyone,READ" 

# copy \\n-test-as22\d$\scripts folder to d:\scripts and 

Copy-Item '\\n-test-as22\d$\scripts' -Destination 'd:\scripts'


