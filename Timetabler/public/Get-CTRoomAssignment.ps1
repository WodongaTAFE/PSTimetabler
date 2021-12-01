function Get-CTRoomAssignment {
    [CmdletBinding(DefaultParameterSetName='notid')]
    param (
        [Parameter(Mandatory, Position=0, ParameterSetName='id')]
        [Alias('id')]
        [string] $RoomAssignmentId,

        [Parameter(ParameterSetName='notid')]
        [int] $Page,

        [Parameter(ParameterSetName='notid')]
        [int] $LastId,

        [Parameter(ParameterSetName='notid')]
        [int] $PageSize,

        [Parameter(ParameterSetName='notid',ValueFromPipelineByPropertyName)]
        [int] $EventId,

        [Parameter(ParameterSetName='notid',ValueFromPipelineByPropertyName)]
        [int] $RoomId,

        [switch] $WeekStartingDates,

        [switch] $PrettyWeeks,

        [int] $PrettyWeeksSchemeId,

        [switch] $Terse
    )

    begin {
        $url = $Script:_ctUri
        $token = $Script:_ctApiCode
        
        if (!$url -or !$token) {
            throw 'You must call the Connect-CT cmdlet before calling any other cmdlets.'
        }
    
        $headers = @{
            ApiCode = $token
        }

        if ($Script:_ctTimetableId) {
            $headers.TimetableId = $Script:_ctTimetableId
        }
    }

    process {
        if ($RoomAssignmentId) {
            $path = "/api/room-assignments/$RoomAssignmentId`?"
        }
        else {
            $path = '/api/room-assignments?'

            if ($Page) {
                $path += "page=$Page&"
            }
            if ($LastId) {
                $path += "lastId=$LastId&"
            }
            if ($PageSize) {
                $path += "pageSize=$PageSize&"
            }
            if ($EventId) {
                $path += "eventId=$EventId&"
            }
            if ($RoomId) {
                $path += "roomId=$RoomId&"
            }
        }
        
        if ($WeekStartingDates) {
            $path += 'weekStartingDates=true&'
        }
        if ($PrettyWeeks) {
            $path += 'prettyWeeks=true&'
        }
        if ($PrettyWeeksSchemeId) {
            $path += "prettyWeeksSchemeId=$PrettyWeeksSchemeId&"
        }
        $path += 'detail=' + (&{if ($Terse) { 'terse' } else { 'extended' }})
        
        $uri = [uri]::new($url, $path)
 
        try {
            $response = (Invoke-RestMethod -Uri $uri -Headers $headers)
            if ($response) {
                return $response
            }
        }
        catch {
            if ($_.Exception.Response.StatusCode -ne 404) {
                throw
            }
        }
    }
}