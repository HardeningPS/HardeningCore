Function Test-HCoreFilter
{

    <#
        .SYNOPSIS
        Main function to perform configuration filtering

        .DESCRIPTION
        Main function to perform configuration filtering

        .PARAMETER Name
        Specifies the name of the filter

        .EXAMPLE
        PS C:\> Test-HCoreFilter -Name 'PartOfDomain'

        .INPUTS
        System.String

        .INPUTS
        System.Management.Automation.PSObject

        .OUTPUTS
        System.Boolean

        .LINK
        https://hardening.netboot.fr/configuration/powershell/private/test-hcorefilter/

        .LINK
        https://github.com/HardeningPS/HardeningCore/blob/stable/HardeningCore/Private/Test-HCoreFilter.ps1

        .NOTES
        - File Name : Test-HCoreFilter.ps1
        - Author    : Thomas ILLIET
    #>

    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSAvoidUsingInvokeExpression", "")]
    [CmdletBinding( HelpUri = "https://hardening.netboot.fr/configuration/powershell/private/test-hcorefilter/" )]
    [OutputType( [System.Boolean] )]
    Param(
        [Parameter(
            Mandatory = $true,
            Position = 0,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true
        )]
        [ValidateNotNullOrEmpty()]
        [System.String]
        $Name
    )

    begin
    {
        Write-Verbose "[$($MyInvocation.MyCommand.Name)] Function started"
    }

    process
    {
        $cmdLet = "Test-HCoreFilter$($Name)"
        if ( Get-Item -Path Function:$cmdLet )
        {
            Invoke-Expression -Command $cmdLet
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
