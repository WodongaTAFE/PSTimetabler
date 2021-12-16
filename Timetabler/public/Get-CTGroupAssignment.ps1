function Get-CTGroupAssignment {
    [CmdletBinding(DefaultParameterSetName='notid')]
    param (
        [Parameter(ParameterSetName='notid',ValueFromPipelineByPropertyName)]
        [Parameter(Mandatory, Position=0, ParameterSetName='id')]
        [int] $EventId,

        [Parameter(ParameterSetName='notid',ValueFromPipelineByPropertyName)]
        [Parameter(Mandatory, Position=1, ParameterSetName='id')]
        [int] $GroupId,

        [Parameter(ParameterSetName='notid')]
        [int] $Page,

        [Parameter(ParameterSetName='notid')]
        [int] $LastId,

        [Parameter(ParameterSetName='notid')]
        [int] $PageSize,

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
        if ($PSCmdlet.ParameterSetName -eq 'id') {
            $path = "/api/group-assignments/$EventId-$GroupId`?"
        }
        else {
            $path = '/api/group-assignments?'

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
            if ($GroupId) {
                $path += "groupId=$GroupId&"
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
            $result = (Invoke-RestMethod -Uri $uri -Headers $headers) 
            if ($result) {
                $result
            }
        }
        catch {
            if ($_.Exception.Response.StatusCode -ne 404) {
                throw
            }
        }
    }
}

New-Alias -Name Get-CTEventGroup -Value Get-CTGroupAssignment
