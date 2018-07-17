function Get-SecurePasswordFromFile ($userName)
{
    $pwFile = "$PSScriptRoot\$userName.txt"

    if (!(Test-Path $pwFile))
    {
       throw "File [$pwFile] not found. Run [_set-securePwd.ps1]"
    }
    return (Get-Content $pwFile | ConvertTo-SecureString )
}


function Connect-To-MSOL ($adminID)
{
    try
    {
        $secpasswd = Get-SecurePasswordFromFile $adminID

        $creds = New-Object System.Management.Automation.PSCredential ($adminID, $secpasswd)

        Connect-MsolService -Credential $creds
    }
    catch
    {
       write-host $($_.Exception.Message)
    }
}


function Get-SharepointContext ($siteUrl, $userName)
{
    try
    {
	    $ctx = New-Object Microsoft.SharePoint.Client.ClientContext($siteURL)

        if ($username -eq $null)
        {
            Logwrite "D" "connecting to site [$siteUrl] with default credentials..."
            $ctx.Credentials = [System.Net.CredentialCache]::DefaultNetworkCredentials
        }
        else
        {
			$secPassword = Get-SecurePasswordFromFile $userName
			if ($secPassword -eq $null)
			{
				write-host "no password available for user [$userName]"
				return $null
			}

            $ctx.Credentials = New-Object Microsoft.SharePoint.Client.SharePointOnlineCredentials($username, $secPassword)
        }
    }
    catch
    {
	   write-host $($_.Exception.Message)
       return $null
    }
    return $ctx
}



Connect-To-MSOL ($adminID)

$ctx = Get-SharepointContext 'http://dms.bcaa.bc.ca' 'bcaa\sp_some_user'
