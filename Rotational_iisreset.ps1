param(

[string[]] $servers = $null

)

foreach($server in $servers)
{
"Doing iisreset on  $server......"

Invoke-Command -ComputerName $server -ScriptBlock{iisreset} 

}
