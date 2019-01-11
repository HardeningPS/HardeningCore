#region Initialize
$systemUnderTest = ( Split-Path -Leaf $MyInvocation.MyCommand.Path ) -replace '\.Tests\.', '.'
$function = $systemUnderTest.Split( '.' )[0]
#endregion

#region Run Pester tests
$describe = 'Function/Private/{0}' -f $function
Describe -Name $describe -Tag 'Function', 'Private', $function -Fixture {

    #region Block Comments
    $help = Get-Help -Name $function -Full

    $splat = @{
        ExpectedFunctionName = $function
        FoundFunctionName    = $help.Name
    }
    Test-PesterFunctionName @splat

    Test-PesterFunctionHelpMain -Help $help

    $splat = @{
        Help  = $help
        Links = @(
            "^https://hardening.netboot.fr/configuration/powershell/(?:Private|Public)/$($function.ToLower())/$",
            "^https://github.com/HardeningPS/HardeningCore/blob/stable/HardeningCore/(?:Private|Public)/$function.ps1$"
        )
    }
    Test-PesterFunctionHelpLink @splat

    $splat = @{
        ExpectedOutputTypeNames = 'System.String'
        Help                    = $help
    }
    Test-PesterFunctionHelpOutput @splat

    Test-PesterFunctionHelpInput -Help $help

    $splat = @{
        ExpectedParameterNames = @( 'Sid' )
        Help                   = $help
    }
    Test-PesterFunctionHelpParameter @splat

    $splat = @{
        ExpectedNotes = "- File Name : $function.ps1`n- Author    : Thomas ILLIET"
        Help          = $help
    }
    Test-PesterFunctionHelpNote @splat
    #endregion

    #region CmdletBinding
    $splat = @{
        FunctionName = $function
        HelpUri      = "^https://hardening.netboot.fr/configuration/powershell/(?:Private|Public)/$($function.ToLower())/$"
    }
    Test-PesterFunctionCmdletBinding @splat
    #endregion

    #region Execution
    Context -Name 'Execution' -Fixture {
        $testCases = @(
            @{
                Identity = 'BUILTIN\Administrators'
                Sid      = 'S-1-5-32-544'
            },
            @{
                Identity = 'NT AUTHORITY\INTERACTIVE'
                Sid      = 'S-1-5-4'
            }
            @{
                Identity = 'Everyone'
                Sid      = 'S-1-1-0'
            }
            @{
                Identity = 'BUILTIN\Guests'
                Sid      = 'S-1-5-32-546'
            }
            @{
                Identity = 'BUILTIN\Users'
                Sid      = 'S-1-5-32-545'
            }
        )
        $testName = 'should not fail when set to: Sid: <Sid>'
        It -Name $testName -TestCases $testCases -Test {
            param ( [String] $Identity, [String] $Sid )
            ConvertTo-HCoreNTAccount -Sid $Sid | Should -Be $Identity
        }

        $testCases = @(
            @{
                Sid = 'S-1-5-42-42'
            }
        )
        $testName = 'should fail when set to: Sid: <Sid>'
        It -Name $testName -TestCases $testCases -Test {
            param ( [String] $Sid )
            { ConvertTo-HCoreNTAccount -Sid $Sid  } | Should -Throw
        }
    }
    #endregion

    #region Return Type
    Context -Name "Return Type" -Fixture {
        $testCases = @(
            @{
                FoundReturnType    = ( ConvertTo-HCoreNTAccount -Sid 'S-1-5-32-544' -ErrorAction 'Stop' ).GetType().FullName
                ExpectedReturnType = 'System.String'
            }
        )
        $testName = 'should return the expected data type: <ExpectedReturnType>'
        It -Name $testName -TestCases $testCases -Test {
            param ( [String] $FoundReturnType, [String] $ExpectedReturnType )
            $FoundReturnType | Should -Be $ExpectedReturnType
        }

        $testName = "has an 'OutputType' entry for <FoundReturnType>"
        It -Name $testName -TestCases $testCases -Test {
            param ( [String] $FoundReturnType, [String] $ExpectedReturnType )
            $FoundReturnType | Should -BeIn ( Get-Help -Name $function -Full ).ReturnValues.ReturnValue.Type.Name
        }
    }
    #endregion
}
#endregion
