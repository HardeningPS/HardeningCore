Function Get-HCoreConfig
{

    <#
        .SYNOPSIS
        Get hardening configuration

        .DESCRIPTION
        Get hardening configuration

        .PARAMETER Name
        Configuration name

        .PARAMETER Path
        Custom configuration directory

        .EXAMPLE
        PS C:\> Get-HCoreConfig -Name 'AccountPolicy'

        .EXAMPLE
        PS C:\> Get-HCoreConfig -Name 'AccountPolicy' -Path 'C:\MyCustomConfigDirectory'

        .INPUTS
        System.String

        .INPUTS
        System.Management.Automation.PSObject

        .OUTPUTS
        System.Collections.Hashtable

        .LINK
        https://hardening.netboot.fr/configuration/powershell/public/get-hcoreconfig/

        .LINK
        https://github.com/HardeningPS/HardeningCore/blob/stable/HardeningCore/Public/Get-HCoreConfig.ps1

        .NOTES
        - File Name : Get-HCoreConfig.ps1
        - Author    : Thomas ILLIET
    #>

    [CmdletBinding( HelpUri = "https://hardening.netboot.fr/configuration/powershell/public/get-hcoreconfig/" )]
    [OutputType( [System.Collections.Hashtable] )]
    Param(
        [Parameter(
            Mandatory = $true,
            ParameterSetName = 'Name',
            Position = 0,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true
        )]
        [ValidateNotNullOrEmpty()]
        [System.String]
        $Name,

        [Parameter(
            Mandatory = $false,
            ParameterSetName = 'Path',
            Position = 1,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true
        )]
        [AllowNull()]
        [System.String]
        $Path
    )

    begin
    {
        Write-Verbose "[$($MyInvocation.MyCommand.Name)] Function started"
    }

    process
    {
        if ( [string]::IsNullOrEmpty( $Path ) )
        {
            $Path = Join-Path -Path ( Get-HCoreModulePath ) -ChildPath 'Config'
        }
        $configFile = Join-Path -Path $Path -ChildPath "${Name}.psd1"

        if ( Test-Path $configFile )
        {
            Import-PowerShellDataFile -Path $configFile
        }
        else
        {
            Write-Error "Could not find configuration file: ${configFile}"
        }
    }

    end
    {
        Write-Verbose "[$($MyInvocation.MyCommand.Name)] Complete"
    }
}
