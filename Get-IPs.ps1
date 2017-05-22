function Get-IPs {
    
    [cmdletbinding()]
    Param(

        [Parameter(Mandatory = $True,
                   Position =0,
                   ValueFromPipeline = $True,
                   ValueFromPipelineByPropertyName = $True,
                   HelpMessage ="Specify the first IP in the range(s).")]
        [Alias('Start')]
        [String[]] $StartIP,

        [Parameter(Mandatory = $True,
                   Position =1,
                   HelpMessage ="Enter the last IP in the range(s).")]
        [Alias('End')]
        [String[]] $EndIP
    )
    [Int]$BitCount = 0
    [String]$Subnet

    for([Int] $i = 0, $i -lt $StartIP.Length; $i++){
        if($StartIP[$i] -eq "."){
           $BitCount++ 
        }
        if ($BitCount -eq 3) {
            $Subnet = $StartIP
            $StartIP = $StartIP.Substring($i)
            break
        }
    }

    for([Int] $i = 0, $i -lt $EndIP.Length; $i++){
        if($EndIP[$i] -eq "."){
           $BitCount++ 
        }
        if ($BitCount -eq 3) {
            $EndIP = $EndIP.Substring($i)
            $BitCount = 0
            break
        }
    }

    for([Int] $i = $Subnet.Length; $i -ge 0; $i--){
            $Subnet = $Subnet -replace ".$"
            if($Subnet[$i] -eq "."){
                break
            }
        }
    
   [String[]] $IPrange = "$($Subnet) $($StartIP..$EndIP)"
   
   foreach($IP in $IPrange) {
       Test-Connection $IP -Count 1 -Quiet | Where-Object {$_ -eq “True”}
   } 
}