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
            Mock -CommandName Get-CimInstance -Verifiable -MockWith { @{ PartOfDomain = $true } }
            $testName = 'should be return $true if the computer is part of a domain (without cache)'
            It -Name $testName -TestCases $testCases -Test {
                Test-HCoreFilterPartOfDomain | Should -Be $true
                Test-HCoreFilterPartOfDomain | Should -BeOfType System.Boolean
            }
            Assert-VerifiableMock
            Assert-MockCalled -CommandName Get-HCoreCache -Times 1
            Assert-MockCalled -CommandName Get-CimInstance -Times 1

            Mock -CommandName Get-HCoreCache -Verifiable -MockWith {}
            Mock -CommandName Get-CimInstance -Verifiable -MockWith { @{ PartOfDomain = $false } }
            $testName = 'should be return $false if the computer is not part of a domain (without cache)'
            It -Name $testName -TestCases $testCases -Test {
                Test-HCoreFilterPartOfDomain | Should -Be $false
                Test-HCoreFilterPartOfDomain | Should -BeOfType System.Boolean
            }
            Assert-VerifiableMock
            Assert-MockCalled -CommandName Get-HCoreCache -Times 1
            Assert-MockCalled -CommandName Get-CimInstance -Times 1

            Mock -CommandName Get-HCoreCache -Verifiable -MockWith { @{ PartOfDomain = $true } }
            $testName = 'should be return $true if the computer is part of a domain (with cache)'
            It -Name $testName -TestCases $testCases -Test {
                Test-HCoreFilterPartOfDomain | Should -Be $true
                Test-HCoreFilterPartOfDomain | Should -BeOfType System.Boolean
            }
            Assert-VerifiableMock
            Assert-MockCalled -CommandName Get-HCoreCache -Times 1

            Mock -CommandName Get-HCoreCache -Verifiable -MockWith { @{ PartOfDomain = $false } }
            $testName = 'should be return $false if the computer is not part of a domain (with cache)'
            It -Name $testName -TestCases $testCases -Test {
                Test-HCoreFilterPartOfDomain | Should -Be $false
                Test-HCoreFilterPartOfDomain | Should -BeOfType System.Boolean
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
                FoundReturnType    = ( Test-HCoreFilterPartOfDomain -ErrorAction 'Stop' ).GetType().FullName
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
