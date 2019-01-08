Function Set-HCoreSecurityPolicyContent
{

    <#
        .SYNOPSIS
        Write hash content to INI file

        .DESCRIPTION
        Write hash content to INI file

        .PARAMETER FilePath
        Specifies the path to the output file.

        .PARAMETER InputObject
        Specifies the Hashtable to be written to the file. Enter a variable that contains the objects or type a command or expression that gets the objects.

        .EXAMPLE
        PS C:\> Set-HCoreSecurityPolicyContent -InputObject @{"Category1"=@{"Key1"="Value1"}} -FilePath "C:\MyNewFile.ini"
        Creating a custom Hashtable and saving it to C:\MyNewFile.ini

        .INPUTS
        System.String

        .INPUTS
        System.Object

        .INPUTS
        System.Management.Automation.PSObject

        .OUTPUTS
        System.Void

        .LINK
        https://hardening.netboot.fr/configuration/powershell/private/set-hcoresecuritypolicycontent/

        .LINK
        https://github.com/HardeningPS/HardeningCore/blob/stable/HardeningCore/Private/Set-HCoreSecurityPolicyContent.ps1

        .NOTES
        - File Name : Set-HCoreSecurityPolicyContent.ps1
        - Author    : Thomas ILLIET
    #>

    [CmdletBinding()]
    [OutputType( [System.Void] )]
    Param(
        [Parameter(
            Position = 0,
            Mandatory = $True,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true
        )]
        [ValidateNotNullOrEmpty()]
        [System.String]
        $FilePath,

        [Parameter(
            Position = 1,
            Mandatory = $True,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true
        )]
        [System.Object]
        $InputObject
    )

    Begin
    {
        Write-Verbose "[$($MyInvocation.MyCommand.Name)] Function started"
        $stream = [System.IO.StreamWriter] $Filepath
        $RegistryType = @{
            "REG_SZ"        = 1
            "REG_EXPAND_SZ" = 2
            "REG_BINARY"    = 3
            "REG_DWORD"     = 4
            "REG_MULTI_SZ"  = 7
        }
    }

    Process
    {
        Write-Verbose "[$($MyInvocation.MyCommand.Name)] Writing to file: $Filepath"
        foreach ($section in $InputObject.get_keys())
        {
            # writing section
            Write-Verbose "[$($MyInvocation.MyCommand.Name)] Writing Section: [$section]"
            $stream.WriteLine("[$section]")

            # writing key
            if ($InputObject[$section].Count)
            {
                Foreach ($key in $InputObject[$section].get_keys())
                {
                    Write-Verbose "[$($MyInvocation.MyCommand.Name)] Writing key: $key"
                    switch ($section)
                    {
                        'Registry Values'
                        {
                            switch ($InputObject[$section][$key]['Type'])
                            {
                                'REG_SZ'
                                {
                                    $registryValue = "`"$InputObject[$section][$key]['value']`""
                                }
                                'REG_MULTI_SZ'
                                {
                                    $registryValue = $InputObject[$section][$key]['value'] -join ','
                                }
                                Default
                                {
                                    $registryValue = $InputObject[$section][$key]['value']
                                }
                            }
                            $registryTypeId = $RegistryType.Item($InputObject[$section][$key]['Type'])
                            $stream.WriteLine("$key=$registryTypeId,$registryValue")
                        }
                        'System Access'
                        {
                            if ($InputObject[$section][$key] -match "^\d+$")
                            {
                                $stream.WriteLine("$key=$($InputObject[$section][$key])")
                            }
                            else
                            {
                                $stream.WriteLine("$key=`"$($InputObject[$section][$key])`"")
                            }
                        }
                        Default
                        {
                            $stream.WriteLine("$key=$($InputObject[$section][$key])")
                        }
                    }
                }
            }
        }
        Write-Verbose "[$($MyInvocation.MyCommand.Name)] Finished Writing to file: $FilePath"
    }

    End
    {
        $stream.close()
        Write-Verbose "[$($MyInvocation.MyCommand.Name)] Function ended"
    }
}
