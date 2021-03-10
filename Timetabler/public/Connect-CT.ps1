<#
.SYNOPSIS
Connects to a Celcat Timetable.

.DESCRIPTION
Call Connect-CT to connect to a Celcat Timetable (using its URL and API code) before calling other Timetabler cmdlets.

.PARAMETER Uri
The base URI of the Celcat Timetabler API.

.PARAMETER ApiCode
The API code with which to connect to the API.

.PARAMETER TimetableId
The optional ID of the timetable to connect to.

.EXAMPLE

Connect-CT https://celcatapi.example.com -ApiCode 'myApiCode' -TimetableId 1

Connects to the first configured timetable via the API at celcatapi.example.com, using the API code 'myApiCode'.

.NOTES
See also: Disconnect-CT.
#>
function Connect-CT {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory,Position=0)]
        [Alias('Url')]
        [uri]$Uri,

        [Parameter(Mandatory,Position=1)]
        [string]$ApiCode,

        [Parameter(Position=2)]
        [int]$TimetableId
    )

    if ($Uri.OriginalString -notlike '*`/') {
        $Uri = [uri]::new($Uri.OriginalString + '/')
    }

    $Script:_ctUri = $Uri
    $Script:_ctApiCode = $ApiCode
    $Script:_ctTimetableId = $TimetableId
}