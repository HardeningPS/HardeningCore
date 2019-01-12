@{
    Rules = @{
        PSPlaceOpenBrace                            = @{
            Enable             = $true
            OnSameLine         = $false
            NewLineAfter       = $true
            IgnoreOneLineBlock = $true
        }

        PSPlaceCloseBrace                           = @{
            Enable             = $true
            NewLineAfter       = $true
            IgnoreOneLineBlock = $true
            NoEmptyLineBefore  = $false
        }

        PSUseConsistentIndentation                  = @{
            Enable          = $true
            Kind            = 'space'
            IndentationSize = 4
        }

        PSAlignAssignmentStatement                  = @{
            Enable = $true
        }

        PSUseShouldProcessForStateChangingFunctions = @{
            Enable = $true
        }

        PSProvideCommentHelp                        = @{
            Enable                  = $true
            ExportedOnly            = $false
            BlockComment            = $true
            VSCodeSnippetCorrection = $false
            Placement               = "before"
        }
    }
}
