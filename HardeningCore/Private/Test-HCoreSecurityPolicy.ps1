function Test-HCoreSecurityPolicy
{

    <#
        .SYNOPSIS
        Test Security Policy

        .DESCRIPTION
        Test Security Policy

        .PARAMETER Type
        This parameter is used to define the target.

        .PARAMETER Config
        Security policy Configuration

        .PARAMETER Parameter
        Dictionary of the parameters that are passed to a function

        .EXAMPLE
        PS C:\> Test-HCoreSecurityPolicy

        .INPUTS
        System.String

        .INPUTS
        System.Object

        .INPUTS
        System.Management.Automation.PSObject

        .OUTPUTS
        System.Boolean

        .LINK
        https://hardening.netboot.fr/configuration/powershell/private/test-hcoresecuritypolicy/

        .LINK
        https://github.com/HardeningPS/HardeningCore/blob/stable/HardeningCore/Private/Test-HCoreSecurityPolicy.ps1

        .NOTES
        - File Name : Test-HCoreSecurityPolicy.ps1
        - Author    : Thomas ILLIET
    #>

    [CmdletBinding( HelpUri = "https://hardening.netboot.fr/configuration/powershell/private/test-hcoresecuritypolicy/" )]
    [OutputType( [System.Boolean] )]
    Param(
        [Parameter(
            Position = 0,
            Mandatory = $true,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true
        )]
        [ValidateSet( 'Local', 'Gpo' )]
        [System.String]
        $Type,

        [Parameter(
            Position = 1,
            Mandatory = $true,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true
        )]
        [ValidateNotNullOrEmpty()]
        [System.Object]
        $Config,

        [Parameter(
            Position = 2,
            Mandatory = $true,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true
        )]
        [ValidateNotNullOrEmpty()]
        [System.Object]
        $Parameter
    )

    begin
    {
        Write-Verbose "[$($MyInvocation.MyCommand.Name)] Function started"
    }

    process
    {
        $splat = @{
            ReferenceObject  = ( Format-HCoreParameter -Config $config -Parameter $Parameter )
            DifferenceObject = ( Get-HCoreSecurityPolicy -Config $Config -Type $Type )
            Property         = @('Name', 'Value')
            IncludeEqual     = $true
        }
        $Compare = Compare-Object @splat | Where-Object {$_.SideIndicator -eq '<=' }

        if ( $Compare.count -eq 0 )
        {
            return $true
        }
        else
        {
            return $false
        }

    }

    end
    {
        Write-Verbose "[$($MyInvocation.MyCommand.Name)] Function ended"
    }
}
