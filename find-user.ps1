<#
.SYNOPSIS
Searches for a name or part of a name and returns the location of matching entries from Active Directory.
.DESCRIPTION
Searches for a name or part of a name. The script returns user objects from active directory as well as computer objects that have a matching entry in the description.
.EXAMPLE
find-user administrator
.NOTES
This script requires the use of the ActiveDirectory module.
#>

param (
$user = (Read-Host -Prompt 'Enter a name to search for')
)

Get-ADUser -Filter * |
	Where-Object { $_.Name -like "*$User*" } |
	Select-Object Name,
		@{l='Organizational Unit' ; e={$_.DistinguishedName}} |
		Format-Table -AutoSize

Get-ADComputer -Filter * -Properties Description |
	where { $_.Description -like "*$User*" } |
	Select-Object @{l='PC' ;e={$_.Name}} |
	Format-List