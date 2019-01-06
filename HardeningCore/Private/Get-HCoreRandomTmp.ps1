Function Get-HCoreRandomTmp
{

    <#
        .SYNOPSIS
        Generate temporary files or directories path

        .DESCRIPTION
        Generate temporary files or directories path

        .PARAMETER Extension
        Specifies the file extension

        .EXAMPLE
        PS C:\> Get-HCoreRandomTmp

        .INPUTS
        System.String

        .INPUTS
        System.Management.Automation.PSObject

        .OUTPUTS
        System.String

        .LINK
        https://hardening.netboot.fr/configuration/powershell/private/get-hcorerandomtmp/

        .LINK
        https://github.com/HardeningPS/HardeningCore/blob/stable/HardeningCore/Private/Get-HCoreRandomTmp.ps1

        .NOTES
        - File Name : Get-HCoreRandomTmp.ps1
        - Author    : Thomas ILLIET
    #>

    [CmdletBinding( HelpUri = "https://hardening.netboot.fr/configuration/powershell/private/get-hcorerandomtmp/" )]
    [OutputType( [System.String] )]
    Param
    (
        [Parameter(
            Position = 0,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true
        )]
        [System.String]
        $Extension = 'tmp'
    )

    begin
    {
        Write-Verbose "[$($MyInvocation.MyCommand.Name)] Function started"
    }

    process
    {
        $path = [System.IO.Path]::GetTempPath()
        $fileName = [System.Guid]::NewGuid().ToString() + '.' + $Extension
        return [System.IO.Path]::Combine($path, $fileName)
    }

    end
    {
        Write-Verbose "[$($MyInvocation.MyCommand.Name)] Function ended"
    }
}
