Function Remove-HCoreTmp
{

    <#
        .SYNOPSIS
        Remove temporary files or directories

        .DESCRIPTION
        Remove temporary files or directories

        .PARAMETER Path
        Specifies the path the temporary files or directories

        .EXAMPLE
        PS C:\> Remove-HCoreTmp -Path 'C:\Users\ThomasILLIET\AppData\Local\Temp\bda19316-98ab-4c36-9c78-922641c1003d.tmp'

        .INPUTS
        System.String

        .INPUTS
        System.Management.Automation.PSObject

        .OUTPUTS
        System.Void

        .LINK
        https://hardening.netboot.fr/configuration/powershell/private/remove-hcoretmp/

        .LINK
        https://github.com/HardeningPS/HardeningCore/blob/stable/HardeningCore/Private/Remove-HCoreTmp.ps1

        .NOTES
        - File Name : Remove-HCoreTmp.ps1
        - Author    : Thomas ILLIET
    #>

    [CmdletBinding(
        SupportsShouldProcess = $true,
        ConfirmImpact = 'Low',
        HelpUri = "https://hardening.netboot.fr/configuration/powershell/private/remove-hcoretmp/"
    )]
    [OutputType( [System.Void] )]
    Param
    (
        [Parameter(
            Mandatory = $true,
            Position = 0,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true
        )]
        [ValidateNotNullOrEmpty()]
        [System.String]
        $Path
    )

    begin
    {
        Write-Verbose "[$($MyInvocation.MyCommand.Name)] Function started"
    }

    process
    {
        if ( $PSCmdlet.ShouldProcess( $MyInvocation.MyCommand.Name, "Remove $path" ) )
        {
            if ( Test-Path -Path $Path )
            {
                $tempPath = ([System.IO.Path]::GetTempPath()).replace('\', '\\')
                if ( $Path -match "$tempPath[0-9a-fA-F]{8}\-[0-9a-fA-F]{4}\-[0-9a-fA-F]{4}\-[0-9a-fA-F]{4}\-[0-9a-fA-F]{12}([\\]{1}|.[a-z]{3})+$" )
                {
                    Write-Verbose "[$($MyInvocation.MyCommand.Name)] Removing temporary item: $Path"
                    Remove-Item -Path $Path -Force
                }
                else
                {
                    Write-Error 'Could not remove item because is not in the temporary directory'
                }
            }
            else
            {
                Write-Error 'Could not remove item because is not exist'
            }
        }
    }

    end
    {
        Write-Verbose "[$($MyInvocation.MyCommand.Name)] Function ended"
    }
}
