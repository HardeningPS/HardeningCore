Function Test-HCoreFilterWorkStation
{

    <#
        .SYNOPSIS
        Test if the computer is a Work Station

        .DESCRIPTION
        Test if the computer is a Work Station

        .EXAMPLE
        PS C:\> Test-HCoreFilterWorkStation

        .OUTPUTS
        System.Boolean

        .LINK
        https://hardening.netboot.fr/configuration/powershell/private/test-hcorefilterworkstation/

        .LINK
        https://github.com/HardeningPS/HardeningCore/blob/stable/HardeningCore/Private/Test-HCoreFilterWorkStation.ps1

        .LINK
        https://docs.microsoft.com/en-us/windows/desktop/CIMWin32Prov/win32-operatingsystem

        .NOTES
        - File Name : Test-HCoreFilterWorkStation.ps1
        - Author    : Thomas ILLIET
    #>

    [CmdletBinding( HelpUri = "https://hardening.netboot.fr/configuration/powershell/private/test-hcorefilterworkstation/" )]
    [OutputType( [System.Boolean] )]
    Param()

    begin
    {
        Write-Verbose "[$($MyInvocation.MyCommand.Name)] Function started"
    }

    process
    {
        $operatingSystem = Get-HCoreCache -Name "OperatingSystem"
        if ( $null -eq $operatingSystem )
        {
            $operatingSystem = Get-CimInstance -ClassName Win32_OperatingSystem
            New-HCoreCache -Name 'OperatingSystem' -InputObject $operatingSystem
        }

        if ( $operatingSystem.Object.ProductType -eq 1 )
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
