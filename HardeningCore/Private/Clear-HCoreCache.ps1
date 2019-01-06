Function Clear-HCoreCache
{

    <#
        .SYNOPSIS
        Remove all items from cache memory

        .DESCRIPTION
        Remove all items from cache memory

        .EXAMPLE
        PS C:\> Clear-HCoreCache

        .OUTPUTS
        System.Void

        .LINK
        https://hardening.netboot.fr/configuration/powershell/private/clear-hcorecache/

        .LINK
        https://github.com/HardeningPS/HardeningCore/blob/stable/HardeningCore/Private/Clear-HCoreCache.ps1

        .NOTES
        - File Name : Clear-HCoreCache.ps1
        - Author    : Thomas ILLIET
    #>

    [CmdletBinding( HelpUri = "https://hardening.netboot.fr/configuration/powershell/private/clear-hcorecache/" )]
    [OutputType( [System.Void] )]
    Param()

    begin
    {
        Write-Verbose "[$($MyInvocation.MyCommand.Name)] Function started"
    }

    process
    {
        Write-Verbose "[$($MyInvocation.MyCommand.Name)] Remove $($script:Cache.Count) cache items"
        $script:Cache = @{}
    }

    end
    {
        Write-Verbose "[$($MyInvocation.MyCommand.Name)] Function ended"
    }
}
