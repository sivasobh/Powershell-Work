# 
# NAME: Cleanupservers.ps1
# 
# AUTHOR: AMG , NASDAQOMX
# DATE  : 
# 
# COMMENT: Cleanup server directories
# 
# ==============================================================================================

$disk = [math]::Round((Get-WmiObject Win32_LogicalDisk -Filter "DeviceID='C:'" | Select-Object -ExpandProperty Size)/1GB,2)
$beforefree = [math]::Round((Get-PSDrive C | Select-Object -ExpandProperty Free)/1GB,2)
$beforeused = [math]::Round((Get-PSDrive C | Select-Object -ExpandProperty Used)/1GB,2)
$beforepct = ($beforeused/$disk)*100

# Clear all temp folders
Remove-Item -Path C:\temp\* -Recurse -Force -Verbose -ErrorAction SilentlyContinue
Remove-Item -Path C:\tmp\* -Recurse -Force -Verbose -ErrorAction SilentlyContinue
Remove-Item -Path C:\Windows\Temp\* -Recurse -Force -Verbose -ErrorAction SilentlyContinue
Remove-Item -Path C:\Users\*\AppData\Local\Temp\* -Recurse -Force -Verbose -ErrorAction SilentlyContinue
Remove-Item -Path C:\Users\*\AppData\LocalLow\Temp\* -Recurse -Force -Verbose -ErrorAction SilentlyContinue

# Clear SoftwareDistribution
Stop-Service -Name wuauserv -Force -Verbose -ErrorAction SilentlyContinue
Remove-Item -Path C:\Windows\SoftwareDistribution -Recurse -Force -Verbose -ErrorAction SilentlyContinue
Remove-Item -Path C:\Windows\WindowsUpdate.log -Recurse -Force -Verbose -ErrorAction SilentlyContinue

$blexclude = 'Database','events','locks','log','reader','package_tracking.db','bldeploy-*','bltargetjobmanager-*'
# Clear Bladelogic transactions
Remove-Item -Path "C:\Program Files\BMC Software\BladeLogic\RSCD\Transactions\*" -Exclude $blexclude -Recurse -Force -Verbose -ErrorAction SilentlyContinue

# Clear Bit9 cache.bak file
Remove-Item -Path "C:\ProgramData\Bit9\Parity Agent\cache.bak" -Recurse -Force -Verbose -ErrorAction SilentlyContinue

$afterfree = [math]::Round((Get-PSDrive C | Select-Object -ExpandProperty Free)/1GB,2)
$afterused = [math]::Round((Get-PSDrive C | Select-Object -ExpandProperty Used)/1GB,2)
$afterpct = ($afterused/$disk)*100

Write-Output "----------------------------Before Cleanup-------------------------------`r`n"
Write-Output "Used GB = $beforeused GB"
Write-Output "Used % = $beforepct %"
Write-Output "Free = $beforefree GB"
Write-Output "Size = $disk GB" 
Write-Output "----------------------------After Cleanup--------------------------------`r`n"
Write-Output "Used GB = $afterused GB"
Write-Output "Used % = $afterpct %"
Write-Output "Free = $afterfree GB"
Write-Output "Size = $disk GB"


