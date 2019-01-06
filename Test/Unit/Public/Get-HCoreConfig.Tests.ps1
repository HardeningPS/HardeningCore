#region Initialize
$systemUnderTest = ( Split-Path -Leaf $MyInvocation.MyCommand.Path ) -replace '\.Tests\.', '.'
$function = $systemUnderTest.Split( '.' )[0]
#endregion

#region Run Pester tests
$describe = 'Function/Public/{0}' -f $function
Describe -Name $describe -Tag 'Function', 'Public', $function -Fixture {

    #region Block comments
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
        ExpectedParameterNames = @( 'Name', 'Path' )
        Help                   = $help
    }
    Test-PesterFunctionHelpParameter @splat

    $splat = @{
        ExpectedOutputTypeNames = 'System.Collections.Hashtable'
        Help                    = $help
    }
    Test-PesterFunctionHelpOutput @splat

    Test-PesterFunctionHelpInput -Help $help

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

    #region Configuration
    $configList = Get-ChildItem -Path ( Join-Path -Path $BUILD_CONFIG['MODULE_DST_PATH'] -ChildPath 'config' ) -Filter '*.psd1'
    foreach ( $config in $configList )
    {
        Context -Name "Validating the $($config.BaseName) configuration" -Fixture {
            $config = Get-HCoreConfig -Name $config.BaseName -ErrorAction 'Stop'

            Context -Name "Metadata section" -Fixture {
                $testName = 'should have a valid GUID'
                It -Name $testName -Test {
                    $config.Metadata.Guid -match '[0-9a-fA-F]{8}\-[0-9a-fA-F]{4}\-[0-9a-fA-F]{4}\-[0-9a-fA-F]{4}\-[0-9a-fA-F]{12}$' | Should -Be $true
                }
                $testName = 'should have a Name'
                It -Name $testName -Test {
                    $config.Metadata.Name | Should -Not -BeNullOrEmpty
                }
                $testName = 'should have a Area'
                It -Name $testName -Test {
                    $config.Metadata.Area | Should -Not -BeNullOrEmpty
                }
            }

            Context -Name "Preset section" -Fixture {
                foreach ( $preset in $config.Preset.GetEnumerator() )
                {
                    foreach ( $presetConfig in $preset.Value.GetEnumerator() )
                    {
                        $testName = "should have in the preset $($preset.Name) a valid configuration for $($presetConfig.Name)"
                        It -Name $testName -Test {
                            $config.Data.ContainsKey($presetConfig.Name) | Should -Be $true
                        }
                    }
                }
            }

            Context -Name "Data section" -Fixture {
                foreach ( $data in $config.Data.GetEnumerator() )
                {
                    $testName = "should have in $($data.Name) a Key"
                    It -Name $testName -Test {
                        $data.Value.Key | Should -Not -BeNullOrEmpty
                    }
                    $testName = "should have in $($data.Name) a Section"
                    It -Name $testName -Test {
                        $data.Value.Section | Should -Not -BeNullOrEmpty
                    }
                    $testName = "should have in $($data.Name) a InputType"
                    It -Name $testName -Test {
                        $data.Value.InputType | Should -Not -BeNullOrEmpty
                    }
                    $testName = "should have in $($data.Name) a OutputType"
                    It -Name $testName -Test {
                        $data.Value.OutputType | Should -Not -BeNullOrEmpty
                    }
                    $testName = "should have in $($data.Name) a Filter"
                    It -Name $testName -Test {
                        { $data.Value.Filter } | Should -Not -Throw
                    }
                    $testName = "should have in $($data.Name) a Score"
                    It -Name $testName -Test {
                        $data.Value.Score | Should -Not -BeNullOrEmpty
                    }
                }
            }
        }
    }
    #endregion

    #region Return Type
    Context -Name "Return Type" -Fixture {
        $testCases = @(
            @{
                FoundReturnType    = ( Get-HCoreConfig -Name 'AccountPolicy' -ErrorAction 'Stop' ).GetType().FullName
                ExpectedReturnType = 'System.Collections.Hashtable'
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
