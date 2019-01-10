Function Test-HCoreFilterDomainController
{

    <#
        .SYNOPSIS
        Test if the computer is a Domain Controller

        .DESCRIPTION
        Test if the computer is a Domain Controller

        .EXAMPLE
        PS C:\> Test-HCoreFilterDomainController

        .OUTPUTS
        System.Boolean

        .LINK
        https://hardening.netboot.fr/configuration/powershell/private/test-hcorefilterdomaincontroller/

        .LINK
        https://github.com/HardeningPS/HardeningCore/blob/stable/HardeningCore/Private/Test-HCoreFilterDomainController.ps1

        .LINK
        https://docs.microsoft.com/en-us/windows/desktop/CIMWin32Prov/win32-operatingsystem

        .NOTES
        - File Name : Test-HCoreFilterDomainController.ps1
        - Author    : Thomas ILLIET
    #>

    [CmdletBinding( HelpUri = "https://hardening.netboot.fr/configuration/powershell/private/test-hcorefilterdomaincontroller/" )]
    [OutputType( [System.Boolean] )]
    Param()

    begin
    {
        Write-Verbose "[$($MyInvocation.MyCommand.Name)] Function started"
    }

    process
    {
        $operatingSystem = Get-HCoreCache -Name "OperatingSystem"
        if ( [string]::IsNullOrEmpty($operatingSystem) )
        {
            $operatingSystem = Get-CimInstance -ClassName Win32_OperatingSystem
            New-HCoreCache -Name "OperatingSystem" -InputObject $operatingSystem
        }

        if ( $operatingSystem.ProductType -eq 2 )
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
