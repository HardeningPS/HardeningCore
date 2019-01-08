Function Get-HCoreLocalSecurityPolicy
{

    <#
        .SYNOPSIS
        Retrieve the local security policy

        .DESCRIPTION
        Retrieve the local security policy

        .PARAMETER Area
        Specifies the security areas to be applied to the system

        .EXAMPLE
        PS C:\> Get-HCoreLocalSecurityPolicy -Area 'SecurityPolicy'

        .INPUTS
        System.String

        .INPUTS
        System.Management.Automation.PSObject

        .OUTPUTS
        System.Collections.Specialized.OrderedDictionary

        .LINK
        https://hardening.netboot.fr/configuration/powershell/private/get-hcorelocalsecuritypolicy/

        .LINK
        https://github.com/HardeningPS/HardeningCore/blob/stable/HardeningCore/Private/Get-HCoreLocalSecurityPolicy.ps1

        .LINK
        https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/secedit

        .NOTES
        - File Name : Get-HCoreLocalSecurityPolicy.ps1
        - Author    : Thomas ILLIET
    #>

    [CmdletBinding( HelpUri = "https://hardening.netboot.fr/configuration/powershell/private/get-hcorelocalsecuritypolicy/" )]
    [OutputType( [System.Collections.Specialized.OrderedDictionary] )]
    Param(
        [Parameter(
            Position = 0,
            Mandatory = $true,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true
        )]
        [ValidateSet('SecurityPolicy')]
        [System.String]
        $Area
    )

    begin
    {
        Write-Verbose "[$($MyInvocation.MyCommand.Name)] Function started"
        $tmpPath = Get-HCoreRandomTmp
    }

    process
    {
        Invoke-HCoreSecedit -Command "/export /cfg $tmpPath /areas $Area"
        Get-HCoreSecurityPolicyContent -FilePath $tmpPath
    }

    end
    {
        Remove-HCoreTmp -Path $tmpPath
        Write-Verbose "[$($MyInvocation.MyCommand.Name)] Function ended"
    }
}
