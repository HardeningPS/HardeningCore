Function Get-HCoreSecurityPolicy
{

    <#
        .SYNOPSIS
        Get Security Policy

        .DESCRIPTION
        Get Security Policy

        .PARAMETER Type
        This parameter is used to define the target.

        .PARAMETER Config
        Security policy Configuration

        .PARAMETER Parameter
        Dictionary of the parameters that are passed to a function

        .EXAMPLE
        PS C:\> Get-HCoreSecurityPolicy

        .INPUTS
        System.String

        .INPUTS
        System.Object

        .INPUTS
        System.Management.Automation.PSObject

        .OUTPUTS
        System.Void

        .LINK
        https://hardening.netboot.fr/configuration/powershell/private/get-hcoresecuritypolicy/

        .LINK
        https://github.com/HardeningPS/HardeningCore/blob/stable/HardeningCore/Private/Get-HCoreSecurityPolicy.ps1

        .NOTES
        - File Name : Get-HCoreSecurityPolicy.ps1
        - Author    : Thomas ILLIET
    #>

    [CmdletBinding( HelpUri = "https://hardening.netboot.fr/configuration/powershell/private/get-hcoresecuritypolicy/" )]
    [OutputType( [System.Object] )]
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
        $Config
    )

    begin
    {
        Write-Verbose "[$($MyInvocation.MyCommand.Name)] Function started"
    }

    process
    {
        $securityPolicy = Get-HCoreCache -Name "SecurityPolicy-${Type}"
        if ( [string]::IsNullOrEmpty($securityPolicy) )
        {
            switch ($Type)
            {
                'Local'
                {
                    $securityPolicy = Get-HCoreLocalSecurityPolicy -Area $Config.Metadata.Area
                }
                'Gpo'
                {
                    Write-Error "This feature is not implemented"
                }
            }
            New-HCoreCache -Name "SecurityPolicy-${Type}" -InputObject $securityPolicy
        }


        #
        # + Apply Filter
        foreach ($item in $Config.Data.GetEnumerator() )
        {

            # Filter
            if ($item.Value.Filter)
            {
                $filterStatus = Test-HCoreFilter -Name $item.Value.Filter
            }
            else
            {
                $filterStatus = $null
            }

            # Geting security policy value
            switch ($item.Value.Section)
            {
                'Registry Values'
                {
                    $value = $securityPolicy.Object.($item.Value.Section).($item.Value.Key).Value
                }
                Default
                {
                    $value = $securityPolicy.Object.($item.Value.Section).($item.Value.Key)
                }
            }

            [PSCustomObject]@{
                Name         = $item.Name
                Key          = $item.Value.Key
                Section      = $item.Value.Section
                FilterName   = $item.Value.Filter
                FilterStatus = $filterStatus
                InputType    = $item.Value.InputType
                OutputType   = $item.Value.OutputType
                Value        = $value
            }
        }
    }

    end
    {
        Write-Verbose "[$($MyInvocation.MyCommand.Name)] Function ended"
    }
}
