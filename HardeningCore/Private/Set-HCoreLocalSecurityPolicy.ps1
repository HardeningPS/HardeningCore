Function Set-HCoreLocalSecurityPolicy
{

    <#
        .SYNOPSIS
        Define the local security policy

        .DESCRIPTION
        Define the local security policy

        .PARAMETER Path
        Specify the path of the security policy file

        .EXAMPLE
        PS C:\> Set-HCoreLocalSecurityPolicy -Path C:\Windows\Temp\0217c8ec-7eb1-4463-a765-ddbee936f377.tmp

        .INPUTS
        System.String

        .INPUTS
        System.Management.Automation.PSObject

        .OUTPUTS
        System.Void

        .LINK
        https://hardening.netboot.fr/configuration/powershell/private/set-hcorelocalsecuritypolicy/

        .LINK
        https://github.com/HardeningPS/HardeningCore/blob/stable/HardeningCore/Private/Set-HCoreLocalSecurityPolicy.ps1

        .NOTES
        - File Name : Set-HCoreLocalSecurityPolicy.ps1
        - Author    : Thomas ILLIET
    #>

    [CmdletBinding(
        SupportsShouldProcess = $true,
        ConfirmImpact = 'High',
        HelpUri = "https://hardening.netboot.fr/configuration/powershell/private/set-hcorelocalsecuritypolicy/"
    )]
    [OutputType( [System.Void] )]
    Param(
        [Parameter(
            Position = 0,
            Mandatory = $true ,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true
        )]
        [System.String]
        $Path
    )

    begin
    {
        Write-Verbose "[$($MyInvocation.MyCommand.Name)] Function started"
        $tempFlushMapFile = Join-Path -Path ( [System.IO.Path]::GetTempPath() ) -ChildPath 'HCoreSecedit.jfm'
        $tempDatabaseFile = Join-Path -Path ( [System.IO.Path]::GetTempPath() ) -ChildPath 'HCoreSecedit.sdb'
    }

    process
    {
        if ( Test-Path -Path $Path )
        {
            if ( $PSCmdlet.ShouldProcess( $Path ) )
            {
                Invoke-HCoreSecedit -Command  "/configure /db $tempDatabaseFile /cfg $Path"
            }
        }
        else
        {
            Write-Error "Could not find security policy file: $Path"
        }
    }

    end
    {
        Remove-Item -Path $tempFlushMapFile -ErrorAction SilentlyContinue
        Remove-Item -Path $tempDatabaseFile -ErrorAction SilentlyContinue
        Write-Verbose "[$($MyInvocation.MyCommand.Name)] Function ended"
    }
}
