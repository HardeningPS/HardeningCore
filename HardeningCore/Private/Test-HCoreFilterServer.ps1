Function Test-HCoreFilterServer
{

    <#
        .SYNOPSIS
        Test if the computer is a Server

        .DESCRIPTION
        Test if the computer is a Server

        .EXAMPLE
        PS C:\> Test-HCoreFilterServer

        .OUTPUTS
        System.Boolean

        .LINK
        https://hardening.netboot.fr/configuration/powershell/private/test-hcorefilterserver/

        .LINK
        https://github.com/HardeningPS/HardeningCore/blob/stable/HardeningCore/Private/Test-HCoreFilterServer.ps1

        .LINK
        https://docs.microsoft.com/en-us/windows/desktop/CIMWin32Prov/win32-operatingsystem

        .NOTES
        - File Name : Test-HCoreFilterServer.ps1
        - Author    : Thomas ILLIET
    #>

    [CmdletBinding( HelpUri = "https://hardening.netboot.fr/configuration/powershell/private/test-hcorefilterserver/" )]
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

        if ( $operatingSystem.Object.ProductType -eq 3 )
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
