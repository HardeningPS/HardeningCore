Function Get-HCoreAccountPolicy
{

    <#
        .SYNOPSIS
        This function allows you to get the configuration of the password policy and account lockout policy.

        .DESCRIPTION
        This function allows you to get the configuration of the password policy and account lockout policy.

        .PARAMETER Type
        This parameter is used to define the target.

        .PARAMETER ConfigDirectory
        Define the custom configuration directory.

        .EXAMPLE
        PS C:\> Get-HCoreAccountPolicy

        .EXAMPLE
        PS C:\> Get-HCoreAccountPolicy -Type 'Gpo'

        .EXAMPLE
        PS C:\> Get-HCoreAccountPolicy -Type 'Gpo' -ConfigDirectory 'c:\MyCustomConfigurationDirectory\'

        .INPUTS
        System.String

        .INPUTS
        System.Management.Automation.PSObject

        .OUTPUTS
        System.Object[]

        .LINK
        https://hardening.netboot.fr/configuration/powershell/public/get-hcoreaccountpolicy/

        .LINK
        https://github.com/HardeningPS/HardeningCore/blob/stable/HardeningCore/Public/Get-HCoreAccountPolicy.ps1

        .NOTES
        - File Name : Get-HCoreAccountPolicy.ps1
        - Author    : Thomas ILLIET
    #>

    [CmdletBinding( HelpUri = "https://hardening.netboot.fr/configuration/powershell/public/get-hcoreaccountpolicy/" )]
    [OutputType( [System.Object[]] )]
    Param(
        [Parameter(
            Position = 0,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true
        )]
        [ValidateSet( 'Local', 'Gpo' )]
        [System.String]
        $Type = 'Local',

        [Parameter(
            Position = 1,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true
        )]
        [ValidateNotNullOrEmpty()]
        [System.String]
        $ConfigDirectory
    )

    begin
    {
        Write-Verbose "[$($MyInvocation.MyCommand.Name)] Function started."
    }

    process
    {
        $splat = @{
            Type   = $Type
            Config = ( Get-HCoreConfig -Name 'AccountPolicy' -Path $ConfigDirectory )
        }
        Get-HCoreSecurityPolicy @splat
    }

    end
    {
        Write-Verbose "[$($MyInvocation.MyCommand.Name)] Complete."
    }
}
