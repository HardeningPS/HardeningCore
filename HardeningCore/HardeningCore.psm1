#region Define module variable
$Script:ModulePath = $PSScriptRoot
$Script:Cache = @{}
#endregion

#region Get powershell files
$public = @( Get-ChildItem -Path "$ModulePath\Public\*.ps1" -Recurse -ErrorAction Stop )
$private = @( Get-ChildItem -Path "$ModulePath\Private\*.ps1" -Recurse -ErrorAction Stop )
#endregion

#region Dot source all powershell function
@($public + $private) | ForEach-Object {
    Try
    {
        Write-Verbose "Load $($_.FullName)"
        . $_.FullName
    }
    Catch
    {
        write-Error -Message "Failed to import function $($_.FullName): $($_.Exception.Message)"
    }
}
#endregion
