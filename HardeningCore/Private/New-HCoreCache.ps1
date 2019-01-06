Function New-HCoreCache
{

    <#
        .SYNOPSIS
        Save a new item in the cache

        .DESCRIPTION
        Save a new item in the cache

        .PARAMETER Name
        Specifies the name of the cache

        .PARAMETER InputObject
        Specifies the object to be written to the cache.

         .PARAMETER Expiration
        Specifies cache expiration in seconds

        .EXAMPLE
        PS C:\> New-HCoreCache -Name "MyCache" -InputObject ([PSCustomObject]@{ test = "test" })

        .EXAMPLE
        PS C:\> New-HCoreCache -Name "MyCache" -InputObject ([PSCustomObject]@{ test = "test" }) -Expiration 3600

        .INPUTS
        System.String

        .INPUTS
        System.Object

        .INPUTS
        System.Int32

        .INPUTS
        System.Management.Automation.PSObject

        .OUTPUTS
        System.Void

        .LINK
        https://hardening.netboot.fr/configuration/powershell/private/new-hcorecache/

        .LINK
        https://github.com/HardeningPS/HardeningCore/blob/stable/HardeningCore/Private/New-HCoreCache.ps1

        .NOTES
        - File Name : New-HCoreCache.ps1
        - Author    : Thomas ILLIET
    #>

    [CmdletBinding( SupportsShouldProcess = $true, ConfirmImpact = 'Low' )]
    [CmdletBinding( HelpUri = "https://hardening.netboot.fr/configuration/powershell/private/new-hcorecache/" )]
    [OutputType( [System.Void] )]
    Param(
        [Parameter(
            Mandatory = $true,
            Position = 0,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true
        )]
        [ValidateNotNullOrEmpty()]
        [System.String]
        $Name,

        [Parameter(
            Mandatory = $true,
            Position = 2,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true
        )]
        [ValidateNotNullOrEmpty()]
        [System.Object]
        $InputObject,

        [Parameter(
            Position = 2,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true
        )]
        [ValidateNotNullOrEmpty()]
        [System.Int32]
        $Expiration = 30
    )

    begin
    {
        Write-Verbose "[$($MyInvocation.MyCommand.Name)] Function started"
    }

    process
    {
        if ( $PSCmdlet.ShouldProcess( $MyInvocation.MyCommand.Name, 'Save a new item in the cache' ) )
        {
            $script:Cache[$Name] = [PSCustomObject]@{
                ExpirationDateTime = (Get-Date).AddSeconds($Expiration)
                Object             = $InputObject
            }
        }
    }

    end
    {
        Write-Verbose "[$($MyInvocation.MyCommand.Name)] Function ended"
    }
}
