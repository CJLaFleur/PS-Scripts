<#
.SYNOPSIS
Simple script to add users to the domain. You will be prompted for your credentials.
#>
Add-Computer -DomainName "main.city.northampton.ma.us"
Restart-Computer
