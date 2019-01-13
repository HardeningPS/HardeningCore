@{
    Metadata = @{
        Version     = '1.0'
        Guid        = '7c35d566-a1e0-41ca-962a-555b79c41326'
        Description = ''
        Name        = 'AccountPolicy'
        Area        = 'SecurityPolicy'
    }
    Preset   = @{
        CIS_Windows_10   = @{
            Enforce_Password_History                    = 24
            Maximum_Password_Age                        = 60
            Minimum_Password_Age                        = 1
            Minimum_Password_Length                     = 14
            Password_Must_Meet_Complexity_Requirements  = $true
            Store_Passwords_Using_Reversible_Encryption = $false
            Account_Lockout_Duration                    = 15
            Account_Lockout_Threshold                   = 10
            Reset_Account_Lockout_Counter_After         = 15
        }
        CIS_Windows_2016 = @{
            Enforce_Password_History                    = 24
            Maximum_Password_Age                        = 60
            Minimum_Password_Age                        = 1
            Minimum_Password_Length                     = 14
            Password_Must_Meet_Complexity_Requirements  = $true
            Store_Passwords_Using_Reversible_Encryption = $false
            Account_Lockout_Duration                    = 20
            Account_Lockout_Threshold                   = 10
            Reset_Account_Lockout_Counter_After         = 20
        }
    }
    Data     = @{
        Enforce_Password_History                             = @{
            Key        = 'PasswordHistorySize'
            Section    = 'System Access'
            InputType  = 'System.Int32'
            OutputType = 'System.Int32'
            Filter     = $null
            Score      = 1
        }
        Maximum_Password_Age                                 = @{
            Key        = 'MaximumPasswordAge'
            Section    = 'System Access'
            InputType  = 'System.Int32'
            OutputType = 'System.Int32'
            Filter     = $null
            Score      = 1
        }
        Minimum_Password_Age                                 = @{
            Key        = 'MinimumPasswordAge'
            Section    = 'System Access'
            InputType  = 'System.Int32'
            OutputType = 'System.Int32'
            Filter     = $null
            Score      = 1
        }
        Minimum_Password_Length                              = @{
            Key        = 'MinimumPasswordLength'
            Section    = 'System Access'
            InputType  = 'System.Int32'
            OutputType = 'System.Int32'
            Filter     = $null
            Score      = 1
        }
        Password_Must_Meet_Complexity_Requirements           = @{
            Key        = 'PasswordComplexity'
            Section    = 'System Access'
            InputType  = 'System.Boolean'
            OutputType = 'System.Int32'
            Option     = @{
                True  = 1
                False = 0
            }
            Filter     = $null
            Score      = 1
        }
        Store_Passwords_Using_Reversible_Encryption          = @{
            Key        = 'ClearTextPassword'
            Section    = 'System Access'
            InputType  = 'System.Boolean'
            OutputType = 'System.Int32'
            Option     = @{
                True  = 1
                False = 0
            }
            Filter     = $null
            Score      = 1
        }
        Account_Lockout_Duration                             = @{
            Key        = 'LockoutDuration'
            Section    = 'System Access'
            InputType  = 'System.Int32'
            OutputType = 'System.Int32'
            Filter     = $null
            Score      = 1
        }
        Account_Lockout_Threshold                            = @{
            Key        = 'LockoutBadCount'
            Section    = 'System Access'
            InputType  = 'System.Int32'
            OutputType = 'System.Int32'
            Filter     = $null
            Score      = 1
        }
        Reset_Account_Lockout_Counter_After                  = @{
            Key        = 'ResetLockoutCount'
            Section    = 'System Access'
            InputType  = 'System.Int32'
            OutputType = 'System.Int32'
            Filter     = $null
            Score      = 1
        }
        Enforce_User_Logon_Restrictions                      = @{
            Key        = 'TicketValidateClient'
            Section    = 'Kerberos Policy'
            InputType  = 'System.Boolean'
            OutputType = 'System.Int32'
            Option     = @{
                True  = 1
                False = 0
            }
            Filter     = 'PartOfDomain'
            Score      = 0
        }
        Maximum_Lifetime_For_Service_Ticket                  = @{
            Key        = 'MaxServiceAge'
            Section    = 'Kerberos Policy'
            InputType  = 'System.Int32'
            OutputType = 'System.Int32'
            Filter     = 'PartOfDomain'
            Score      = 0
        }
        Maximum_Lifetime_For_User_Ticket                     = @{
            Key        = 'MaxTicketAge'
            Section    = 'Kerberos Policy'
            InputType  = 'System.Int32'
            OutputType = 'System.Int32'
            Filter     = 'PartOfDomain'
            Score      = 0
        }
        Maximum_Lifetime_For_User_Ticket_Renewal             = @{
            Key        = 'MaxRenewAge'
            Section    = 'Kerberos Policy'
            InputType  = 'System.Int32'
            OutputType = 'System.Int32'
            Filter     = 'PartOfDomain'
            Score      = 0
        }
        Maximum_Tolerance_For_Computer_Clock_Synchronization = @{
            Key        = 'MaxClockSkew'
            Section    = 'Kerberos Policy'
            InputType  = 'System.Int32'
            OutputType = 'System.Int32'
            Filter     = 'PartOfDomain'
            Score      = 0
        }
    }
}
