function ConvertTo-HCoreSid
{

    <#
        .SYNOPSIS
        Converts an identity to a SID to verify it's a valid account

        .DESCRIPTION
        Converts an identity to a SID to verify it's a valid account

        .PARAMETER Identity
        Specifies the identity to convert

        .EXAMPLE
        PS C:\> ConvertTo-HCoreSid -Identity 'Administrator'

        .INPUTS
        System.String

        .INPUTS
        System.Management.Automation.PSObject

        .OUTPUTS
        System.Security.Principal.SecurityIdentifier

        .LINK
        https://hardening.netboot.fr/configuration/powershell/private/convertto-hcoresid/

        .LINK
        https://github.com/HardeningPS/HardeningCore/blob/stable/HardeningCore/Private/ConvertTo-HCoreSid.ps1

        .NOTES
        - File Name : ConvertTo-HCoreSid.ps1
        - Author    : Thomas ILLIET
    #>

    [CmdletBinding( HelpUri = "https://hardening.netboot.fr/configuration/powershell/private/convertto-hcoresid/" )]
    [OutputType( [System.Security.Principal.SecurityIdentifier] )]
    param
    (
        [Parameter(
            Position = 0,
            Mandatory = $true ,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true
        )]
        [System.String]
        $Identity
    )

    begin
    {
        Write-Verbose "[$($MyInvocation.MyCommand.Name)] Function started"
    }

    process
    {
        $id = [System.Security.Principal.NTAccount]$Identity
        try
        {
            return $id.Translate( [System.Security.Principal.SecurityIdentifier] )
        }
        catch
        {
            Write-Error "Could not convert Identity: ${Identity} to SID"
        }
    }

    end
    {
        Write-Verbose "[$($MyInvocation.MyCommand.Name)] Complete"
    }
}