Function Get-HCoreModulePath
{

    <#
        .SYNOPSIS
        Get current module path

        .DESCRIPTION
        Simple function to get module path with $ModulePath, and allow to makes it easy to test the project functions.

        .EXAMPLE
        PS C:\> Get-HCoreModulePath

        .OUTPUTS
        System.String

        .LINK
        https://hardening.netboot.fr/configuration/powershell/private/get-hcoremodulepath/

        .LINK
        https://github.com/HardeningPS/HardeningCore/blob/stable/HardeningCore/Private/Get-HCoreModulePath.ps1

        .NOTES
        - File Name : Get-HCoreModulePath.ps1
        - Author    : Thomas ILLIET
    #>

    [CmdletBinding( HelpUri = "https://hardening.netboot.fr/configuration/powershell/private/get-hcoremodulepath/" )]
    [OutputType( [System.String] )]
    Param()

    begin
    {
        Write-Verbose "[$($MyInvocation.MyCommand.Name)] Function started"
    }

    process
    {
        return $Script:ModulePath
    }

    end
    {
        Write-Verbose "[$($MyInvocation.MyCommand.Name)] Function ended"
    }
}
