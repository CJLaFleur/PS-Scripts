$LogPath = "c:\errors.txt"

function Get-OSInfo {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$True,
                   ValueFromPipeline=$True,
                   ValueFromPipelineByPropertyName=$True,
                   HelpMessage="The. Computer. Name.")]
        [Alias('Hostname','cn')] #helps to facilitate handling objects of a different name
        [string[]]$ComputerName,

        [Parameter()]
        [string]$ErrorLogFilePath = $LogPath
    )
    BEGIN {
        Remove-Item -Path $ErrorLogFilePath -Force -EA SilentlyContinue
        $ErrorsHappened = $False
    }
    PROCESS {
        Write-Verbose "HERE WE GO!!!!"
        foreach ($computer in $ComputerName) {
          #Catches errors
            try {

                Write-Verbose "------------------------------"
                Write-Verbose "Retrieving data from $computer"
                #Doing this means the code only has to connect once to a Cim session.
                $session = New-CimSession -ComputerName $computer -EA Stop
                $OS = Get-CimInstance -ClassName win32_operatingsystem -CimSession $session

                $BootTime = $OS.ConvertToDateTime($OS.LastBootUpTime)
                $Uptime = $OS.ConvertToDateTime($OS.LocalDateTime) - $BootTime

                #Hash table utilizing methods from the classes used above
                $Properties = @{ComputerName = $Computer
                                Status = 'Connected'
                                LastBootTime = $BootTime
                                Uptime = $Uptime
                                }

            } catch {

                Write-Verbose "Couldn't connect to $computer"
                $computer | Out-File $ErrorLogFilePath -Append
                $ErrorsHappened = $True
                $properties = @{ComputerName = $Computer
                                Status = 'Disconnected'
                                SPVersion = $null
                                OSVersion = $null
                                Model = $null
                                Mfgr = $null}

            } finally {

                $obj = New-Object -TypeName PSObject -Property $Properties
                Write-Output $obj

            }
        }
    }
    END {
        if ($ErrorsHappened) {
            Write-Warning "Errors logged to $ErrorLogFilePath."
        }
    }
}
