Function Set-HCoreSecurityPolicy
{

    <#
        .SYNOPSIS
        Set Security Policy

        .DESCRIPTION
        Set Security Policy

        .PARAMETER Type
        This parameter is used to define the target.

        .PARAMETER Config
        Security policy Configuration

        .PARAMETER Parameter
        Dictionary of the parameters that are passed to a function

        .EXAMPLE
        PS C:\> Set-HCoreSecurityPolicy

        .INPUTS
        System.String

        .INPUTS
        System.Object

        .INPUTS
        System.Management.Automation.PSObject

        .OUTPUTS
        System.Void

        .LINK
        https://hardening.netboot.fr/configuration/powershell/private/set-hcoresecuritypolicy/

        .LINK
        https://github.com/HardeningPS/HardeningCore/blob/stable/HardeningCore/Private/Set-HCoreSecurityPolicy.ps1

        .NOTES
        - File Name : Set-HCoreSecurityPolicy.ps1
        - Author    : Thomas ILLIET
    #>

    [CmdletBinding(
        SupportsShouldProcess = $true,
        ConfirmImpact = 'Low',
        HelpUri = "https://hardening.netboot.fr/configuration/powershell/private/set-hcoresecuritypolicy/"
    )]
    [OutputType( [System.Void] )]
    Param(
        [Parameter(
            Position = 0,
            Mandatory = $true,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true
        )]
        [ValidateSet('Local', 'Gpo')]
        [System.String]
        $Type,

        [Parameter(
            Position = 1,
            Mandatory = $true,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true
        )]
        [ValidateNotNullOrEmpty()]
        [System.Object]
        $Config,

        [Parameter(
            Position = 2,
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
        $tmpPath = Get-HCoreRandomTmp
    }

    process
    {
        if ( $PSCmdlet.ShouldProcess( $tmpPath ) )
        {
            # Creating the template object of the security policy
            $securityPolicyObject = New-Object System.Collections.Specialized.OrderedDictionary([System.StringComparer]::OrdinalIgnoreCase)
            $securityPolicyObject['Unicode'] = New-Object System.Collections.Specialized.OrderedDictionary([System.StringComparer]::OrdinalIgnoreCase)
            $securityPolicyObject['Unicode']['Unicode'] = 'Yes'
            $securityPolicyObject['System Access'] = New-Object System.Collections.Specialized.OrderedDictionary([System.StringComparer]::OrdinalIgnoreCase)
            $securityPolicyObject['Event Audit'] = New-Object System.Collections.Specialized.OrderedDictionary([System.StringComparer]::OrdinalIgnoreCase)
            $securityPolicyObject['Version'] = New-Object System.Collections.Specialized.OrderedDictionary([System.StringComparer]::OrdinalIgnoreCase)
            $securityPolicyObject['Version']['signature'] = '$CHICAGO$'
            $securityPolicyObject['Version']['Revision'] = 1
            $securityPolicyObject['Registry Values'] = New-Object System.Collections.Specialized.OrderedDictionary([System.StringComparer]::OrdinalIgnoreCase)

            # Converting parameters to hashtable
            $parameterFormated = Format-HCoreParameter -Config $Config -Parameter $Parameter

            # Creating the security policy object
            try
            {
                foreach ($item in $parameterFormated.getenumerator())
                {
                    $itemData = $Config.Data.($item.name)
                    Write-Verbose "[$($MyInvocation.MyCommand.Name)] Adding key: $($item.name)"
                    if (($Config.Data.($item.name)).ContainsKey('Option'))
                    {
                        $securityPolicyObject[$itemData.Section][$itemData.Key] = $Config.Data.($item.name).Option.Item([String]$item.Value)
                    }
                    else
                    {
                        $securityPolicyObject[$itemData.Section][$itemData.Key] = $item.Value
                    }
                }
            }
            catch
            {
                Write-Error "Could not create the security policy object : $($_.Exception.Message)"
            }

            ## Create Security policy content
            Set-HCoreSecurityPolicyContent -FilePath $tmpPath -InputObject $securityPolicyObject

            # Apply configuration
            Set-HCoreLocalSecurityPolicy -Path $tmpPath -Confirm:$false
        }
    }
    end
    {
        Remove-HCoreTmp -Path $tmpPath
        Write-Verbose "[$($MyInvocation.MyCommand.Name)] Function ended"
    }
}
