
$LogFile = "C:\Users\set-domain-errors.txt"

function Set-Domain{
  [CmdletBinding()]
  param(
    [Parameter(Mandatory=$True,
      ValueFromPipeline=$True,
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
      Add-Computer -ComputerName $Computer -DomainName main.city.northampton.ma.us
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
