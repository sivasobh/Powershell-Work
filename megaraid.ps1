#cmd /c "C:\Program Files (x86)\MegaRAID Storage Manager\MegaCli" -EncInfo -aALL | findstr "Enclosure" | findstr /v /C:type /C:Serial /C:Zoning > c:\tmp_raid_enclosures.txt


#Invoke-Command -ComputerName p01db041  -ScriptBlock {cmd /c "C:\Program Files (x86)\MegaRAID Storage Manager\MegaCli64" -PDList  -aALL}
$server= Read-Host "Enter Server name: "
#Write-Progress -Activity checking -Status 'Progress-&gt;' -PercentComplete $I -CurrentOperation OuterLoop
Invoke-Command -FilePath "\\MYLAB.NET\admin\automation\siva\HDD_ERROR\hdd_error.ps1" -ComputerName $server |Select-String '(Enclosure Device ID:|Slot Number:|Firmware state:|Error Count|Predictive Failure Count:)'  >> $PSScriptRoot\temp.txt
$filePath="$PSScriptRoot\temp.txt"
$Contents  = Get-Content $FilePath | Where {$_}
$index     = 0
$FNLResult = @()
try
{
    do
    {
        $EDID = "NA"
        $SLNo = "NA"
        $MEC  = "NA"
        #$OEC  = "NA"
        $PFC  = "NA"
        $FC   = "NA"

        do 
        {
            $Value   = $null
            $Details = $Contents[$index].ToString().Split(":")[0].Trim()
            $Value   = $Contents[$index].ToString().Split(":")[1].Trim()

                if($Details -eq "Enclosure Device ID")     { $EDID = $value }
            elseif($Details -eq "Slot Number")             { $SLNo = $value }
            elseif($Details -eq "Media Error Count")       { $MEC  = $value }
            #elseif($Details -eq "Other Error Count")       { $OEC  = $value }
            elseif($Details -eq "Predictive Failure Count"){ $PFC  = $value }
            elseif($Details -eq "Firmware state")          { $FC   = $value }

            $index ++
        }
        until($Contents[$index].tostring().toupper().StartsWith("ENCLOSURE DEVICE ID"))

       

        $Result = New-Object -TypeName psobject -Property @{
            "Enclosure Device ID"      = $EDID 
            "Slot Number"              = $SLNo 
            "Media Error Count"        = $MEC  
            #"Other Error Count"        = $OEC  
            "Predictive Failure Count" = $PFC  
            "Firmware state"           = $FC   
        }
         If (($Result.'Firmware state') -notlike 'Online, Spun Up' -or ($Result.'Predictive Failure Count') -gt 0 -or ($Result.'Media Error Count') -gt 0)
        {

        $FNLResult += $Result
        

    }
    }
    until($index -eq $Contents.Length)
  
}

catch
{}

if ($FNLResult.count-eq 0){write-host "No HDD issue found on $server"-foregroundColor green }
else{
        $FNLResult|ft
        #need to run the megaraid batch and copy the file to script location
       # Copy-Item \\mylab.net\admin\automation\Automations\MegaRaidDataPull.bat \\$server\c$\Users\$env:UserName\Desktop\MegaRaidDataPull.bat
      #  $s = New-PSSession -ComputerName $server
       # Invoke-Command -FilePath "$PSScriptRoot\MegaRaidDataPull.bat" -ComputerName $server 
    }

#cleanup the file and variable
$contents=$FNLResult=$null
rm $filePath

<#
$content| Select-String 'Slot Number:'
$content| Select-String 'Firmware state:'-NotMatch 'Online'
$content| Select-String 'Predictive Failure Count:'-gt 0
$content| select-string -pattern "failed"
$content| Select-String -Pattern "Unconfigured(bad)"
$content| Select-String -Pattern 'Unconfigured(good)' #>

