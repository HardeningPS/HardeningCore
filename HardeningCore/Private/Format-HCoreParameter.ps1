Function Format-HCoreParameter
{
    <#
        .SYNOPSIS
        Format powershell bound parameters to system object

        .DESCRIPTION
        Format powershell bound parameters to system object

        .PARAMETER Config
        Security policy Configuration

        .PARAMETER Parameter
        Dictionary of the parameters that are passed to a function

        .EXAMPLE
        PS C:\> Format-HCoreParameter

        .INPUTS
        System.Object

        .INPUTS
        System.Management.Automation.PSObject

        .OUTPUTS
        System.Collections.Hashtable

        .LINK
        https://hardening.netboot.fr/configuration/powershell/public/format-hcoreparameter/

        .LINK
        https://github.com/HardeningPS/HardeningCore/blob/stable/HardeningCore/Private/Format-HCoreParameter.ps1

        .NOTES
        - File Name : Format-HCoreParameter.ps1
        - Author    : Thomas ILLIET
    #>

    [CmdletBinding( HelpUri = "https://hardening.netboot.fr/configuration/powershell/public/format-hcoreparameter/" )]
    [OutputType( [System.Collections.Hashtable] )]
    Param(
        [Parameter(
            Position = 0,
            Mandatory = $true,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true
        )]
        [ValidateNotNullOrEmpty()]
        [System.Object]
        $Config,

        [Parameter(
            Position = 0,
            Mandatory = $true,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true
        )]
        [ValidateNotNullOrEmpty()]
        [System.Object]
        $Parameter
    )

    begin
    {
        Write-Verbose "[$($MyInvocation.MyCommand.Name)] Function started"
    }

    process
    {
        if ( $Parameter.ContainsKey('Preset') )
        {
            if ( $Config.Preset.ContainsKey($Parameter.Preset) )
            {
                # Return preset configuration
                foreach ( $item in $Config.Preset.($Parameter.Preset).GetEnumerator() )
                {
                    [PSCustomObject]@{
                        Name  = $item.key
                        Value = $item.value
                    }
                }
            }
            else
            {
                Write-Error "Could not find preset '$($Parameter.Preset)' in '$($config.Metadata.Name)' configuration"
            }
        }
        else
        {
            # Remove useless parameters
            $Parameter.Remove('Type') | Out-Null
            $Parameter.Remove('Verbose') | Out-Null
            $Parameter.Remove('ConfigDirectory') | Out-Null
            $Parameter.Remove('Config') | Out-Null
            $Parameter.Remove('Parameter') | Out-Null

            # Convert PSBoundParametersDictionary to Object
            foreach ( $item in $Parameter.GetEnumerator() )
            {
                [PSCustomObject]@{
                    Name  = $item.key
                    Value = $item.value
                }
            }
        }
    }

    end
    {
        Write-Verbose "[$($MyInvocation.MyCommand.Name)] Function ended"
    }
}
