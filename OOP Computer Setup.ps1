
Class Computers{

  #member variables
  [String[]]$CName
  [String[]]$NewCName
  [String]$DomainName
  [String]$Username
  static [String]$SetCNameErrLog = "C:\Users\set-cname-errors.txt"
  static [String]$SetDomainErrLog = "C:\Users\set-domain-errors.txt"

  #default constructor
  Computers(){
  }

  #Constructor for renaming computers.
  Computers($CName, $NewCName, $Username){
    $this.CName = $CName
    $this.NewCName = $NewCName
    $this.Username = $Username
  }

  #Constructor for setting the domain.
  Computers($DomainName, $Username){
    $this.DomainName = $DomainName
    $this.Username = $Username
  }


  #Constructor that instantiates all member variables.
  Computers($CName, $NewCName, $DomainName, $Username){
    $this.CName = $CName
    $this.NewCName = $NewCName
    $this.DomainName = $DomainName
    $this.Username = $Username
  }

  #Sets domain
  [Void] Set-Domain(){
    [CmdletBinding()]
    param(
      [Parameter(Mandatory=$True,
        ValueFromPipelineByPropertyName=$True,
        HelpMessage= "Enter the target computer name.")]
        [Alias('Hostname','CN', 'ComputerName')]
      [String[]]$CName,

      [Parameter()]
      [string]$ErrorLogFilePath = $LogPath

    BEGIN {
        Remove-Item -Path $ErrorLogFilePath -Force -EA
        $ErrorsHappened = $False
    }

    PROCESS{
      foreach ($Computer in $CName){
          try{
        Add-Computer -ComputerName $Computer -DomainName $DomainName
          }
          catch{
            Write-Verbose "Couldn't connect to $Computer"
            $computer | Out-File $ErrorLogFilePath -Append
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

  #Sets computer name(s)
  [Void] Set-CName(){
    [CmdletBinding()]
    param(
      [Parameter(Mandatory=$True,
        ValueFromPipelineByPropertyName=$True,
        HelpMessage= "Enter the target computer name.")]
        [Alias('Hostname','CN', 'ComputerName')]
      [String[]]$CName,
      [Parameter(Mandatory = $True,
        ValueFromPipeline=$True,
        ValueFromPipelineByPropertyName=$True,
        HelpMessage = "Enter the new computer name.")]
        [Alias('NewName')]
        [String[]]$NewCName,
      [Parameter(Mandatory = $True,
        HelpMessage = "Enter your username.")]
        [String]$Username,

        [Parameter()]
        [string]$ErrorLogFilePath = $LogFile
    )

    BEGIN {
        Remove-Item -Path $ErrorLogFilePath -Force -EA
        $ErrorsHappened = $False
    }

    PROCESS{
    try{
        For ($i = 0; i -lt $CName.Length; $i++){
          Rename-Computer -ComputerName $CName[i] -NewName $NewCName[i] -DomainCredential $Username
        }

    }
    catch{
      $CName[i] | Out-File $ErrorLogFilePath -Append
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
