function Get-CTAttendance {
    [CmdletBinding(DefaultParameterSetName='notid')]
    param (
        [Parameter(ParameterSetName='notid',ValueFromPipelineByPropertyName)]
        [Parameter(ParameterSetName='id',Mandatory,Position=0,ValueFromPipelineByPropertyName)]
        [int] $EventId,

        [Parameter(ParameterSetName='notid')]
        [Parameter(ParameterSetName='id',Mandatory,Position=1)]
        [int] $Week,

        [Parameter(ParameterSetName='notid',ValueFromPipelineByPropertyName)]
        [Parameter(ParameterSetName='id',Mandatory,Position=2,ValueFromPipelineByPropertyName)]
        [int] $StudentId,

        [Parameter(ParameterSetName='notid')]
        [int] $Page,

        [Parameter(ParameterSetName='notid')]
        [int] $LastId,

        [Parameter(ParameterSetName='notid')]
        [int] $PageSize,

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
            $path = "/api/attendance/$EventId-$Week-$StudentId"
        }
        else {
            $path = '/api/attendance?'

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
            if ($Week) {
                $path += "week=$Week&"
            }
            if ($StudentId) {
                $path += "studentId=$StudentId&"
            }
            $path += 'detail=' + (&{if ($Terse) { 'terse' } else { 'extended' }})
        }
        $uri = [uri]::new($url, $path)
        
        (Invoke-RestMethod -Uri $uri -Headers $headers)
    }
}