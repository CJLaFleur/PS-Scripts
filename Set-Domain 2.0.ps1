$LogPath = "C:\Users\set-domain-errors.txt"

function Set-Domain{
  [CmdletBinding()]
  param(
    [Parameter(Mandatory=$True,
      ValueFromPipeline=$True,
      ValueFromPipelineByPropertyName=$True,
      HelpMessage= "Enter the target computer name.")]
      [Alias('Hostname','CN', 'ComputerName')]
    [String[]]$CName,

    [Parameter(Mandatory=$True,
    HelpMessage= "Enter the target computer name.")]
    [Alias('Auth')]


    [Parameter()]
    [string]$ErrorLogFilePath = $LogPath
    )

  BEGIN {
      Remove-Item -Path $ErrorLogFilePath -Force -EA SilentlyContinue
      $ErrorsHappened = $False
  }

  PROCESS{
    foreach ($Computer in $CName){

          Foreach ($Cred in $Credentials){
          try{
          Add-Computer -ComputerName $Computer -DomainName main.city.northampton.ma.us -Credential $Creds
          }
        }
      }
        catch{
          Write-Verbose "Couldn't connect to $Computer"
          $Computer | Out-File $ErrorLogFilePath -Append
          $ErrorsHappened = $True
        }
      }

  END {
    if ($ErrorsHappened) {
      Write-Warning "Errors logged to $ErrorLogFilePath."
      }
    }
   }
}

<#$creds = Get-Credential
For Each ($i in $collection)
{
   My-Cmdlet -Credential $creds
}
#>

function Get-ComputerNameByIP {
  param(
    $IPAddress = $null
)
  BEGIN {
  }
  PROCESS {
    if ($IPAddress -and $_) {
      throw ‘Please use either pipeline or input parameter’
      break
    }
  elseif ($IPAddress) {
    ([System.Net.Dns]::GetHostbyAddress($IPAddress))
  }
  elseif ($_) {
    trap [Exception] {
      Write-Warning $_.Exception.Message
      continue;
    }
    [System.Net.Dns]::GetHostbyAddress($_)
  }
  else {
    $IPAddress = Read-Host “Please supply the IP Address”
    [System.Net.Dns]::GetHostbyAddress($IPAddress)
  }
}
  END {
  }
}

#Use any range you want here
1..255 | ForEach-Object {”10.20.100.$_”} | Get-ComputerNameByIP
