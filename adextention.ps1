#Get the username from user
$dbuser=Read-Host "Enter the Username[Eg:dbsparannattil]"
#Check if an AD user exists with Get-ADUser  
try {
    $user=Get-ADUser -Identity $dbuser -Properties AccountExpires -ErrorAction stop
    $expdate=$user.AccountExpires
    $Date = [DateTime]$expdate
    $curdate=$Date.AddYears(1600).ToLocalTime().ToString()
    Write-Host "User account expires on: $curdate" -ForegroundColor DarkYellow
if((Get-Date $curdate) -le (Get-Date)){   
If (([double]$user.AccountExpires -ne 9223372036854775807) -and ($user.AccountExpires -gt 0))
{
# Set the expiration date for 60 days into the future
    $user | Set-ADUser -AccountExpirationDate ((Get-Date).AddDays(30)).Ticks
    $user=Get-ADUser -Identity $dbuser -Properties AccountExpires -ErrorAction stop
    $username=$user.SamAccountName
    $newexpdate=$user.AccountExpires
    $newDate = [DateTime]$newexpdate
    $extDate=$newDate.AddYears(1600).ToLocalTime().ToString()
    Write-Host "Account $username Extended till: $extDate" -ForegroundColor Green
}#if closing
}
Else{ 
Write-Warning "User account still not expired"}
}#Try closing
catch {
    Write-Warning -Message "User does not exist."
      } 
$dbuser=$user=$null

