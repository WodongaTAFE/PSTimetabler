<#
.SYNOPSIS
Disconnects from the connected Timetabler instance.
.DESCRIPTION
Clears cached credentials for the connected Timetabler instance.
#>
function Disconnect-IC {
    [CmdletBinding()]
    param()

    Remove-Variable -Scope Script -Name _ctUri
    Remove-Variable -Scope Script -Name _ctApiCode
    Remove-Variable -Scope Script -Name _ctTimetableId
}