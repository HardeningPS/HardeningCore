#region Initialize
$systemUnderTest = ( Split-Path -Leaf $MyInvocation.MyCommand.Path ) -replace '\.Tests\.', '.'
$function = $systemUnderTest.Split( '.' )[0]
#endregion

#region Run Pester tests
$describe = 'Function/Public/{0}' -f $function
Describe -Name $describe -Tag 'Function', 'Public', $function -Fixture {

    #region Block Comments
    $help = Get-Help -Name $function -Full
    $config = Import-PowerShellDataFile -Path ( Join-Path -Path $BUILD_CONFIG['MODULE_DST_PATH'] -ChildPath 'Config\AccountPolicy.psd1' )

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
        ExpectedOutputTypeNames = 'System.Boolean'
        Help                    = $help
    }
    Test-PesterFunctionHelpOutput @splat

    Test-PesterFunctionHelpInput -Help $help

    [System.Collections.ArrayList]$expectedParameterNames = $Config.Data.GetEnumerator().Name
    $expectedParameterNames.Add('Type')
    $expectedParameterNames.Add('Preset')
    $expectedParameterNames.Add('ConfigDirectory')
    $splat = @{
        ExpectedParameterNames = $ExpectedParameterNames
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

    #region Return Type
    Context -Name "Return Type" -Fixture {
        New-HCoreCache -Name 'MyTestCache' -InputObject ([PSCustomObject]@{ test = "test" })
        $testCases = @(
            @{
                FoundReturnType    = ( Test-HCoreAccountPolicy -Maximum_password_age 90 -ErrorAction 'Stop' ).GetType().FullName
                ExpectedReturnType = 'System.Boolean'
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
