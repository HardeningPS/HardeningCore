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
        ExpectedOutputTypeNames = 'System.Boolean'
        Help                    = $help
    }
    Test-PesterFunctionHelpOutput @splat

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
        InModuleScope -ModuleName $BUILD_CONFIG['MODULE_NAME'] -ScriptBlock {

            Mock -CommandName Get-HCoreCache -Verifiable -MockWith {}
            Mock -CommandName Get-CimInstance -Verifiable -MockWith { @{ ProductType = 3 } }
            $testName = 'should be return $true if the computer is a Server (without cache)'
            It -Name $testName -TestCases $testCases -Test {
                Test-HCoreFilterServer | Should -Be $true
                Test-HCoreFilterServer | Should -BeOfType System.Boolean
            }
            Assert-VerifiableMock
            Assert-MockCalled -CommandName Get-HCoreCache -Times 1
            Assert-MockCalled -CommandName Get-CimInstance -Times 1

            Mock -CommandName Get-HCoreCache -Verifiable -MockWith {}
            Mock -CommandName Get-CimInstance -Verifiable -MockWith { @{ ProductType = 1 } }
            $testName = 'should be return $false if the computer is not a Server (without cache)'
            It -Name $testName -TestCases $testCases -Test {
                Test-HCoreFilterServer | Should -Be $false
                Test-HCoreFilterServer | Should -BeOfType System.Boolean
            }
            Assert-VerifiableMock
            Assert-MockCalled -CommandName Get-HCoreCache -Times 1
            Assert-MockCalled -CommandName Get-CimInstance -Times 1

            Mock -CommandName Get-HCoreCache -Verifiable -MockWith { @{ ProductType = 3 } }
            $testName = 'should be return $true if the computer is a Server (with cache)'
            It -Name $testName -TestCases $testCases -Test {
                Test-HCoreFilterServer | Should -Be $true
                Test-HCoreFilterServer | Should -BeOfType System.Boolean
            }
            Assert-VerifiableMock
            Assert-MockCalled -CommandName Get-HCoreCache -Times 1

            Mock -CommandName Get-HCoreCache -Verifiable -MockWith { @{ ProductType = 1 } }
            $testName = 'should be return $false if the computer is not a Server (with cache)'
            It -Name $testName -TestCases $testCases -Test {
                Test-HCoreFilterServer | Should -Be $false
                Test-HCoreFilterServer | Should -BeOfType System.Boolean
            }
            Assert-VerifiableMock
            Assert-MockCalled -CommandName Get-HCoreCache -Times 1
        }
    }
    #endregion

    #region Return Type
    Context -Name "Return Type" -Fixture {
        New-HCoreCache -Name 'MyTestCache' -InputObject ([PSCustomObject]@{ test = "test" })
        $testCases = @(
            @{
                FoundReturnType    = ( Test-HCoreFilterServer -ErrorAction 'Stop' ).GetType().FullName
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
