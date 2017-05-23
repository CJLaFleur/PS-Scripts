<#
.SYNOPSIS
Simple script to add users to the domain, and set the computer name. You will be prompted for your credentials.
It is mandatory that a computer name be specified.
The domain is hard-coded and will be set automatically.
#>


function Set-Domain{
  Add-Computer -DomainName main.city.northampton.ma.us
}

function Set-CName{
  [CmdletBinding()]
  param(
    [Parameter(Mandatory = $True,
      ValueFromPipeline=$True,
      ValueFromPipelineByPropertyName=$True,
      HelpMessage = "Enter the new computer name.")]
      [Alias('NewName')]
      $NewCName,
    [Parameter(Mandatory = $True,
      HelpMessage = "Enter your username.")]
      $Username
  )
  Rename-Computer -ComputerName $env:USERDOMAIN -NewName $NewCName -DomainCredential $Username
}

Set-Domain
Set-CName

Restart-Computer -Force
