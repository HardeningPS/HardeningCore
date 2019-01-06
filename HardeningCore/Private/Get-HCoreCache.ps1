Function Get-HCoreCache
{

    <#
        .SYNOPSIS
        Retrieve an item from the cache

        .DESCRIPTION
        Retrieve an item from the cache

        .PARAMETER Name
        Specifies the name of the cache

        .EXAMPLE
        PS C:\> Get-HCoreCache -Name 'MyCache'

        .INPUTS
        System.String

        .INPUTS
        System.Management.Automation.PSObject

        .OUTPUTS
        System.Management.Automation.PSCustomObject

        .LINK
        https://hardening.netboot.fr/configuration/powershell/private/get-hcorecache/

        .LINK
        https://github.com/HardeningPS/HardeningCore/blob/stable/HardeningCore/Private/Get-HCoreCache.ps1

        .NOTES
        - File Name : Get-HCoreCache.ps1
        - Author    : Thomas ILLIET
    #>

    [CmdletBinding( HelpUri = "https://hardening.netboot.fr/configuration/powershell/private/get-hcorecache/" )]
    [OutputType( [System.Management.Automation.PSCustomObject] )]
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
        if ( $Null -ne $script:Cache[$Name] )
        {
            Write-Verbose "[$($MyInvocation.MyCommand.Name)] Found cached object with key: $Name (exp: $($script:Cache[$Name].ExpirationDateTime) )"
            if ( (Get-Date) -lt $script:Cache[$Name].ExpirationDateTime )
            {
                Write-Verbose "[$($MyInvocation.MyCommand.Name)] Cache still valid"
                return $script:Cache[$Name]
            }
            else
            {
                Write-Verbose "[$($MyInvocation.MyCommand.Name)] Cache object expired. Removing from cache"
                $script:Cache.Remove($Name)
            }
        }
    }

    end
    {
        Write-Verbose "[$($MyInvocation.MyCommand.Name)] Complete"
    }
}
