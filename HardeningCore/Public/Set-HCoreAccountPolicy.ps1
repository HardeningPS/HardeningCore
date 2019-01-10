Function Set-HCoreAccountPolicy
{

    <#
        .SYNOPSIS
        This function allows you to define the configuration of the password policy and account lockout policy.

        .DESCRIPTION
        This function allows you to define the configuration of the password policy and account lockout policy.

        .PARAMETER Type
        This parameter is used to define the target.

        .PARAMETER Enforce_password_history
        This parameter determines the number of renewed, unique passwords that have to be associated with a user account before you can reuse an old password.

        .PARAMETER Maximum_password_age
        This parameter defines how long a user can use their password before it expires.
        Values for this parameter range from 0 to 999 days. If you set the value to 0, the password will never expire.

        .PARAMETER Minimum_password_age
        This parameter determines the number of days that you must use a password before you can change it.
        The range of values for this parameter is between 1 and 999 days.

        .PARAMETER Minimum_password_length
        This parameter determines the least number of characters that make up a password for a user account.

        .PARAMETER Password_must_meet_complexity_requirements
        This parameter checks all new passwords to ensure that they meet basic requirements for strong passwords.

        .PARAMETER Store_passwords_using_reversible_encryption
        This parameter determines whether the operating system stores passwords in a way that uses reversible encryption,
        which provides support for application protocols that require knowledge of the user's password for authentication purposes.
        Passwords that are stored with reversible encryption are essentially the same as plaintext versions of the passwords.

        .PARAMETER Account_Lockout_Duration
        This parameter determines the length of time that must pass before a locked account is unlocked and a user can try to log on again.
        The setting does this by specifying the number of minutes a locked out account will remain unavailable.

        .PARAMETER Account_Lockout_Threshold
        This parameter determines the number of failed logon attempts before the account is locked.

        .PARAMETER Reset_Account_Lockout_Counter_After
        This parameter determines the length of time before the Account lockout threshold resets to zero.

        .PARAMETER Preset
        This setting allows you to use the predefined configuration stored in the AccountPolicy configuration.

        .PARAMETER ConfigDirectory
        Define the custom configuration directory.

        .EXAMPLE
        PS C:\> Set-HCoreAccountPolicy -Preset 'CIS_Windows_2016'

        .EXAMPLE
        PS C:\> Set-HCoreAccountPolicy -Type 'Gpo' -Preset 'CIS_Windows_2016'

        .EXAMPLE
        PS C:\> Set-HCoreAccountPolicy -Maximum_password_age 90 -Minimum_password_age 1

        .EXAMPLE
        PS C:\> Set-HCoreAccountPolicy -Maximum_password_age 90 -Minimum_password_age 1 -ConfigDirectory 'c:\MyCustomConfigurationDirectory\'

        .INPUTS
        System.String

        .INPUTS
        System.Int32

        .INPUTS
        System.Boolean

        .INPUTS
        System.Management.Automation.PSObject

        .OUTPUTS
        System.Void

        .LINK
        https://hardening.netboot.fr/configuration/powershell/public/set-hcoreaccountpolicy/

        .LINK
        https://github.com/HardeningPS/HardeningCore/blob/stable/HardeningCore/Public/Set-HCoreAccountPolicy.ps1

        .NOTES
        - File Name : Set-HCoreAccountPolicy.ps1
        - Author    : Thomas ILLIET
    #>

    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSAvoidUsingPlainTextForPassword", "")]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSAvoidUsingUserNameAndPassWordParams", "")]
    [CmdletBinding(
        SupportsShouldProcess = $true,
        ConfirmImpact = 'Low',
        HelpUri = "https://hardening.netboot.fr/configuration/powershell/public/set-hcoreaccountpolicy/"
    )]
    [OutputType( [System.Void] )]
    Param(
        [Parameter(
            Position = 0,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true
        )]
        [ValidateSet( 'Local', 'Gpo' )]
        [System.String]
        $Type = 'Local',

        [Parameter(
            Position = 1,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            ParameterSetName = 'Manual'
        )]
        [System.Int32]
        $Enforce_password_history,

        [Parameter(
            Position = 2,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            ParameterSetName = 'Manual'
        )]
        [ValidateRange( 0, 999 )]
        [System.Int32]
        $Maximum_password_age,

        [Parameter(
            Position = 3,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            ParameterSetName = 'Manual'
        )]
        [ValidateRange( 1, 999 )]
        [System.Int32]
        $Minimum_password_age,

        [Parameter(
            Position = 4,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            ParameterSetName = 'Manual'
        )]
        [System.Int32]
        $Minimum_password_length,

        [Parameter(
            Position = 5,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            ParameterSetName = 'Manual'
        )]
        [System.Boolean]
        $Password_must_meet_complexity_requirements,

        [Parameter(
            Position = 6,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            ParameterSetName = 'Manual'
        )]
        [System.Boolean]
        $Store_passwords_using_reversible_encryption,

        [Parameter(
            Position = 7,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            ParameterSetName = 'Manual'
        )]
        [System.Boolean]
        $Account_Lockout_Duration,

        [Parameter(
            Position = 8,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            ParameterSetName = 'Manual'
        )]
        [System.Boolean]
        $Account_Lockout_Threshold,

        [Parameter(
            Position = 9,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            ParameterSetName = 'Manual'
        )]
        [System.Boolean]
        $Reset_Account_Lockout_Counter_After,

        [Parameter(
            Position = 10,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            ParameterSetName = 'Preset'
        )]
        [ValidateNotNullOrEmpty()]
        [String]
        $Preset,

        [Parameter(
            Position = 11,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true
        )]
        [ValidateNotNullOrEmpty()]
        [System.String]
        $ConfigDirectory
    )

    begin
    {
        Write-Verbose "[$($MyInvocation.MyCommand.Name)] Function started."
    }

    process
    {
        if ( $PSCmdlet.ShouldProcess( ( $PSBoundParameters | Out-String ) ) )
        {
            $splats = @{
                Type      = $Type
                Config    = ( Get-HCoreConfig -Name 'AccountPolicy' -Path $ConfigDirectory )
                Parameter = $PSBoundParameters
            }
            Set-HCoreSecurityPolicy @splats
        }
    }

    end
    {
        Write-Verbose "[$($MyInvocation.MyCommand.Name)] Complete."
    }
}
