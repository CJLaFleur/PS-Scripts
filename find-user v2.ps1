<#
.SYNOPSIS
Searches for a name or part of a name and returns info from Active Directory.

.DESCRIPTION
Searches for a name or part of a name. The script returns active user objects from Active Directory, their description, and computer objects that have a matching entry in the description as well.

.EXAMPLE
find-user administrator

.NOTES
This script requires the use of the ActiveDirectory module.
#>

param (
$search = (Read-Host -Prompt 'Enter a name to search for')
)

$users = Get-ADUser -Filter * -Properties Description | Where-Object { $_.Name -like "*$search*" -and $_.Enabled -eq "True" }
$workstations = Get-ADComputer -Filter * -Properties Description | Where-Object { $_.Description -like "*$search*" }
$obj = New-Object -TypeName PSObject

ForEach ($user in $users) {
	$obj | Add-Member -MemberType NoteProperty -Force `
		-Name "Organizational Unit" -Value ($user.DistinguishedName)
	$obj | Add-Member -MemberType NoteProperty -Force `
		-Name "Description" -Value ($user.Description)
	
	Write-Output $obj
}

ForEach ($workstation in $workstations) {
	$obj | Add-Member -MemberType NoteProperty -Force `
		-Name "Workstation" -Value ($workstation.Name)
	$obj | Add-Member -MemberType NoteProperty -Force `
		-Name "Description" -Value ($workstation.Description)

	Write-Output $obj | Select-Object -Property Workstation,Description
}