#region RSAT
Import-Module ActiveDirectory

$stopwatch = [System.Diagnostics.Stopwatch]::StartNew()
Get-ADUser -filter * | Out-Null
$stopwatch.Stop()
$stopwatch.Elapsed
$stopwatch.Reset()

#endregion

#region adsisearcher
$stopwatch = [System.Diagnostics.Stopwatch]::StartNew()
$ldapcon = [adsisearcher]"ldap://company.pri"
$ldapcon.filter = "(&(ObjectCategory=User)(ObjectClass=Person))"
$all = $ldapcon.findall()
$stopwatch.Stop()
$stopwatch.Elapsed
$stopwatch.Reset()

#endregion

#region TLS

$domain = 'company.pri'
$Identity = 'Administrator'

Add-Type -AssemblyName System.DirectoryServices.AccountManagement

$ctype = [System.DirectoryServices.AccountManagement.ContextType]::Domain
$ctxOptions = [System.DirectoryServices.AccountManagement.ContextOptions]::Negotiate -bor [System.DirectoryServices.AccountManagement.ContextOptions]::SecureSocketLayer
$DN = 'DC=' + $Domain.Replace('.', ',DC=')
$principalCtx = New-Object -TypeName System.DirectoryServices.AccountManagement.PrincipalContext -ArgumentList @([System.DirectoryServices.AccountManagement.ContextType]::Domain, $($Domain), $($DN), $ctxOptions)
$accnt = [System.DirectoryServices.AccountManagement.UserPrincipal]::FindByIdentity($principalCtx, $Identity)
if ($accnt)
{
    $output = [ordered]@{
        DisplayName	    = $null
        Domain		    = $null
        LastPasswordSet = $null
    }
    
    
    $output.LastPasswordSet = ($accnt.LastPasswordSet).datetime
    $output.DisplayName = $($accnt.DisplayName)
    $output.Domain = $($domain)

}

$output

#endregion
