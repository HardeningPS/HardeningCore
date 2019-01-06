Function Invoke-HCoreSecedit
{

    <#
        .SYNOPSIS
        Wrapper around secedit.exe used to make changes

        .DESCRIPTION
        Wrapper around secedit.exe used to make changes

        .PARAMETER Command
        Executes the specified commands (with any parameters) as though they were entered using the Secedit executable

        .PARAMETER Timeout
        Instructs the Process component to wait X milliseconds for the associated process to exit

        .EXAMPLE
        PS C:\> Invoke-HCoreSecedit -Command "/export /cfg C:\fd9dda1a-83c8-4eee-bfb0-bb8bd46e0f1e.inf /areas SecurityPolicy"

        .INPUTS
        System.String

        .INPUTS
        System.Int32

        .INPUTS
        System.Management.Automation.PSObject

        .OUTPUTS
        System.Void

        .LINK
        https://hardening.netboot.fr/configuration/powershell/private/invoke-hcoresecedit/

        .LINK
        https://github.com/HardeningPS/HardeningCore/blob/stable/HardeningCore/Private/Invoke-HCoreSecedit.ps1

        .NOTES
        - File Name : Invoke-HCoreSecedit.ps1
        - Author    : Thomas ILLIET
    #>

    [CmdletBinding( HelpUri = "https://hardening.netboot.fr/configuration/powershell/private/invoke-hcoresecedit/" )]
    [OutputType( [System.Void] )]
    Param (
        [Parameter(
            Mandatory = $true,
            Position = 0,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true
        )]
        [ValidateNotNullOrEmpty()]
        [System.String]
        $Command,

        [Parameter(
            Position = 1,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true
        )]
        [ValidateNotNullOrEmpty()]
        [System.Int32]
        $Timeout = 60000
    )

    begin
    {
        Write-Verbose "[$($MyInvocation.MyCommand.Name)] Function started"
    }

    process
    {
        Write-Verbose "[$($MyInvocation.MyCommand.Name)] Configure secedit process"
        $startInfo = New-Object System.Diagnostics.ProcessStartInfo
        $startInfo.FileName = "C:\Windows\System32\Secedit.exe"
        $startInfo.Arguments = $Command
        $startInfo.RedirectStandardOutput = $true
        $startInfo.StandardOutputEncoding = [System.Text.Encoding]::UTF8
        $startInfo.UseShellExecute = $false
        $startinfo.CreateNoWindow = $true

        Write-Verbose "[$($MyInvocation.MyCommand.Name)] Start secedit process"
        $process = New-Object System.Diagnostics.Process
        $process.StartInfo = $startInfo
        $process.Start() | Out-Null

        # Add standard output in variable $StandardOut
        $standardOut = @()
        while ( $process.StandardOutput.Peek() -gt -1 )
        {
            Write-Verbose "[$($MyInvocation.MyCommand.Name)] $($process.StandardOutput.ReadLine())"
            $standardOut += $process.StandardOutput.ReadLine()
        }

        # Instructs the Process component to wait X milliseconds for the associated process to exit
        $process.WaitForExit($Timeout) | Out-Null

        # Gets the exit code of the process.
        if ( $process.ExitCode -eq 0 )
        {
            Write-Verbose "[$($MyInvocation.MyCommand.Name)] The operation completed successfully"
        }
        else
        {
            Write-Error ( $standardOut | out-string )
        }
    }

    end
    {
        Write-Verbose "[$($MyInvocation.MyCommand.Name)] Function ended"
    }
}
