     param (
     [string[]] $Servers = $null
     #[string] $param2 = $null
     )
foreach ($server in $Servers)
{
  Invoke-Command -ScriptBlock {Set-ExecutionPolicy Unrestricted} -ComputerName $server
  
 try
 { 
 Invoke-Command -FilePath "\\ELOQUA.NET\admin\automation\siva\Apprecycle\Apprecyclecommand.ps1" -ComputerName $server
 }
 catch
 {
   psexec -s \\$Server powershell.exe -ExecutionPolicy Unrestricted \\ELOQUA.NET\admin\automation\siva\Apprecycle\Apprecyclecommand.ps1
 }
  }
