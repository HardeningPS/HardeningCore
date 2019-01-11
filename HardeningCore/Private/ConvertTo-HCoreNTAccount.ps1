function ConvertTo-HCoreNTAccount
{

    <#
        .SYNOPSIS
        Convert a SID to a common friendly name

        .DESCRIPTION
        Convert a SID to a common friendly name

        .PARAMETER SID
        SID of an identity being converted

        .EXAMPLE
        PS C:\> ConvertTo-HCoreSid -Identity 'Administrator'

        .INPUTS
        System.Security.Principal.IdentityReference[]

        .INPUTS
        System.Management.Automation.PSObject

        .OUTPUTS
        System.String

        .LINK
        https://hardening.netboot.fr/configuration/powershell/private/convertto-hcorentaccount/

        .LINK
        https://github.com/HardeningPS/HardeningCore/blob/stable/HardeningCore/Private/ConvertTo-HCoreNTAccount.ps1

        .NOTES
        - File Name : ConvertTo-HCoreNTAccount.ps1
        - Author    : Thomas ILLIET
    #>

    [CmdletBinding( HelpUri = "https://hardening.netboot.fr/configuration/powershell/private/convertto-hcorentaccount/" )]
    [OutPutType( [System.String] )]
    param
    (
        [Parameter(
            Position = 0,
            Mandatory = $true ,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true
        )]
        [System.Security.Principal.SecurityIdentifier[]]
        $Sid
    )

    begin
    {
        Write-Verbose "[$($MyInvocation.MyCommand.Name)] Function started"
    }

    process
    {
        $result = @()
        foreach ($id in $Sid)
        {
            $id = ( $id -replace "\*" ).Trim()

            $sidId = [System.Security.Principal.SecurityIdentifier]$id
            try
            {
                $result += $sidId.Translate( [System.Security.Principal.NTAccount] ).value
            }
            catch
            {
                Write-Error "Could not translate SID: ${sidId}"
            }
        }
        return $result
    }

    end
    {
        Write-Verbose "[$($MyInvocation.MyCommand.Name)] Complete"
    }
}