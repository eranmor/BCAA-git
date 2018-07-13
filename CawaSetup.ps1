# Cawa clinet setup and FW rule

& '\\bcaa.bc.ca\go\Support\ServerSoftware\CAWA\CAWA R12.0 SP2\CAWA_Agent_R1137_Win64\setup.exe'
netsh advfirewall firewall add rule name="Allow CAWA Connections" dir=in action=allow protocol=TCP localport=7520 remoteip=192.197.3.48,192.197.3.49
