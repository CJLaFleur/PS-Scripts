function Get-ComputerNameByIP {
  param(
    [Parameter (Mandatory = $True,
    ValueFromPipeline=$True,
    ValueFromPipelineByPropertyName=$True)]
    [String[]]$IPAddress = $null
)
  BEGIN {
  }
  PROCESS {
    if ($IPAddress -and $_) {
      throw "Please use either pipeline or input parameter"
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
    $IPAddress = Read-Host "Please supply the IP Address"
    [System.Net.Dns]::GetHostbyAddress($IPAddress)
  }
}
  END {
  }
}

#Use any range you want here
Get-Content C:\ipinfo.txt | ForEach-Object {$IPAddress} | Get-ComputerNameByIP