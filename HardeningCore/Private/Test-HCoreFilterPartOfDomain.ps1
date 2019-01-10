Function Test-HCoreFilterPartOfDomain
{

    <#
        .SYNOPSIS
        Test if the computer is part of a domain

        .DESCRIPTION
        Test if the computer is part of a domain

        .EXAMPLE
        PS C:\> Test-HCoreFilterPartOfDomain

        .OUTPUTS
        System.Boolean

        .LINK
        https://hardening.netboot.fr/configuration/powershell/private/test-hcorefilterpartofdomain/

        .LINK
        https://github.com/HardeningPS/HardeningCore/blob/stable/HardeningCore/Private/Test-HCoreFilterPartOfDomain.ps1

        .NOTES
        - File Name : Test-HCoreFilterPartOfDomain.ps1
        - Author    : Thomas ILLIET
    #>

    [CmdletBinding( HelpUri = "https://hardening.netboot.fr/configuration/powershell/private/test-hcorefilterpartofdomain/" )]
    [OutputType( [System.Boolean] )]
    Param()

    begin
    {
        Write-Verbose "[$($MyInvocation.MyCommand.Name)] Function started"
    }

    process
    {
        $computerSystem = Get-HCoreCache -Name "ComputerSystem"
        if ( [string]::IsNullOrEmpty($computerSystem) )
        {
            $computerSystem = Get-CimInstance -ClassName Win32_ComputerSystem
            New-HCoreCache -Name "ComputerSystem" -InputObject $computerSystem
        }

        if ( $computerSystem.PartOfDomain -eq $true )
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
