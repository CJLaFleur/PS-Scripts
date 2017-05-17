#configure IP address
New-NetIPAddress -InterfaceAlias Ethernet,
 -IPAddress 172.16.0.20,
 -PrefixLength 24, #subnet mask
 -DefaultGateway 172.16.0.1
 #all values are placeholders. they should be parmeterized later.

 #configure DNS server
Set-DNSClientServerAddress -InterfaceAlias "Ethernet",
-ServerAddress 172.16.0.10 #can contain more than one.

#repair trust relationship
Test-ComputerSecureChannel -Credential domain\admin -Repair
