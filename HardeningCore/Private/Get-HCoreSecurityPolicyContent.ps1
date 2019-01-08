Function Get-HCoreSecurityPolicyContent
{
    <#
        .SYNOPSIS
        Gets the content of an INI file

        .DESCRIPTION
        Gets the content of an INI file and returns it as a hashtable

        .INPUTS
        System.String

        .INPUTS
        System.Management.Automation.PSObject

        .OUTPUTS
        System.Collections.Specialized.OrderedDictionary

        .PARAMETER FilePath
        Specifies the path to the input file.

        .EXAMPLE
        PS C:\> $fileContent = Get-HCoreSecurityPolicyContent "C:\myinifile.ini"
        Saves the content of the c:\myinifile.ini in a hashtable called $FileContent

        .EXAMPLE
        PS C:\> $inifilepath | $fileContent = Get-HCoreSecurityPolicyContent
        Gets the content of the ini file passed through the pipe into a hashtable called $FileContent

        .LINK
        https://hardening.netboot.fr/configuration/powershell/private/get-hcoresecuritypolicycontent/

        .LINK
        https://github.com/HardeningPS/HardeningCore/blob/stable/HardeningCore/Private/Get-HCoreSecurityPolicyContent.ps1

        .LINK
        https://msdn.microsoft.com/en-us/library/cc761131.aspx

        .NOTES
        - File Name : Get-HCoreSecurityPolicyContent.ps1
        - Author    : Thomas ILLIET
    #>

    [CmdletBinding( HelpUri = "https://hardening.netboot.fr/configuration/powershell/private/get-hcoresecuritypolicycontent/" )]
    [OutputType( [System.Collections.Specialized.OrderedDictionary] )]
    Param(
        [Parameter(
            Position = 0,
            Mandatory = $true,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true
        )]
        [ValidateNotNullOrEmpty()]
        [ValidateScript( { ( Test-Path $_ ) } )]
        [System.String]
        $FilePath
    )

    begin
    {
        Write-Verbose "[$($MyInvocation.MyCommand.Name)] Function started"
        $RegistryType = @{
            1 = "REG_SZ"
            2 = "REG_EXPAND_SZ"
            3 = "REG_BINARY"
            4 = "REG_DWORD"
            7 = "REG_MULTI_SZ"
        }
        Function Format-HCoreValue($Data)
        {
            <#
                .SYNOPSIS
                Convert input value to the correct type
            #>
            if ($Data -match "^\d+$")
            {
                return [Int]$Data
            }
            else
            {
                return [String]$Data
            }
        }
    }

    Process
    {
        Write-Verbose "[$($MyInvocation.MyCommand.Name)] Processing file: $path"
        $ini = New-Object System.Collections.Specialized.OrderedDictionary([System.StringComparer]::OrdinalIgnoreCase)
        switch -regex -file $FilePath
        {
            # Section
            "^\s*\[(.+)\]\s*$"
            {
                $Section = $matches[1]
                Write-Verbose "[$($MyInvocation.MyCommand.Name)] Adding section : $section"
                $ini[$section] = New-Object System.Collections.Specialized.OrderedDictionary([System.StringComparer]::OrdinalIgnoreCase)
            }
            # Key
            "(.+?)\s*=\s*(.*)"
            {
                $name, $value = $matches[1..2]
                Write-Verbose "[$($MyInvocation.MyCommand.Name)] Adding key $name with value: $value"
                switch ($section)
                {
                    'Registry Values'
                    {
                        $ini[$section][$name] = New-Object System.Collections.Specialized.OrderedDictionary([System.StringComparer]::OrdinalIgnoreCase)
                        $ini[$section][$name]['Type'] = $RegistryType.Item([int]$value.split(',')[0])
                        switch ($ini[$section][$name]['Type'])
                        {
                            'REG_SZ'
                            {
                                $ini[$section][$name]['Value'] = Format-HCoreValue($value.split(',')[1] -replace '"')
                            }
                            'REG_MULTI_SZ'
                            {
                                $ini[$section][$name]['Value'] = $value.split(',') | select-object -skip 1
                            }
                            Default
                            {
                                $ini[$section][$name]['Value'] = Format-HCoreValue($value.split(',')[1])
                            }
                        }
                    }
                    'System Access'
                    {
                        $ini[$section][$name] = Format-HCoreValue($Value -replace '"')
                    }
                    Default
                    {
                        $ini[$section][$name] = Format-HCoreValue($Value)
                    }
                }
            }
        }
        Write-Verbose "[$($MyInvocation.MyCommand.Name)] Finished Processing file: $FilePath"
        return $ini
    }

    end
    {
        Write-Verbose "[$($MyInvocation.MyCommand.Name)] Function ended"
    }
}
