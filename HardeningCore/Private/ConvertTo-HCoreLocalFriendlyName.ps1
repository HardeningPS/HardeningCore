function ConvertTo-HCoreLocalFriendlyName
{

    <#
        .SYNOPSIS
        Resolves username or SID to a NTAccount friendly name so desired and actual idnetities can be compared

        .DESCRIPTION
        Resolves username or SID to a NTAccount friendly name so desired and actual idnetities can be compared

        .PARAMETER Identity
        An Identity in the form of a friendly name (testUser1,contoso\testUser1) or SID

        .EXAMPLE
        PS C:\> ConvertTo-HCoreLocalFriendlyName -Identity 'tilliet'
        This example demonstrats converting a username without a domain name specified

        .EXAMPLE
        PS C:\> ConvertTo-HCoreLocalFriendlyName -Identity 'S-1-5-32-544'
        This example demonstrats converting a SID to a frendlyname

        .INPUTS
        System.String[]

        .INPUTS
        System.Management.Automation.PSObject

        .OUTPUTS
        System.String

        .LINK
        https://hardening.netboot.fr/configuration/powershell/private/convertto-hcorelocalfriendlyname/

        .LINK
        https://github.com/HardeningPS/HardeningCore/blob/stable/HardeningCore/Private/ConvertTo-HCoreLocalFriendlyName.ps1

        .NOTES
        - File Name : ConvertTo-HCoreLocalFriendlyName.ps1
        - Author    : Thomas ILLIET
    #>

    [CmdletBinding( HelpUri = "https://hardening.netboot.fr/configuration/powershell/private/convertto-hcorelocalfriendlyname/" )]
    [OutPutType( [System.String] )]
    param
    (
        [Parameter(
            Position = 0,
            Mandatory = $true ,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true
        )]
        [System.String[]]
        $Identity
    )

    begin
    {
        Write-Verbose "[$($MyInvocation.MyCommand.Name)] Function started"
    }

    process
    {
        $friendlyNames = @()
        foreach ($id in $Identity)
        {
            $id = ( $id -replace "\*" ).Trim()
            if ($null -ne $id -and $id -match '^(S-[0-9-]{3,})')
            {
                # if id is a SID convert to a NTAccount
                $friendlyNames += ConvertTo-HCoreNTAccount -Sid $id
            }
            else
            {
                # if id is an friendly name convert it to a sid and then to an NTAccount
                $sidResult = ConvertTo-HCoreSid -Identity $id

                if ($sidResult -isnot [System.Security.Principal.SecurityIdentifier])
                {
                    continue
                }

                $friendlyNames += ConvertTo-HCoreNTAccount -Sid $sidResult.Value
            }
        }
        return $friendlyNames
    }

    end
    {
        Write-Verbose "[$($MyInvocation.MyCommand.Name)] Complete"
    }
}
