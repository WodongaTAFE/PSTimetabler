function Get-CTTeamMembership {
    [CmdletBinding()]
    param (
        [Parameter(ValueFromPipelineByPropertyName)]
        [string] $TeamId,

        [Parameter(ValueFromPipelineByPropertyName)]
        [string] $StaffId,

        [int] $Page,

        [int] $LastId,

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
        $path = '/api/team-membership?'

        if ($Page) {
            $path += "page=$Page&"
        }
        if ($LastId) {
            $path += "lastId=$LastId&"
        }
        if ($PageSize) {
            $path += "pageSize=$PageSize&"
        }
        if ($StaffId) {
            $path += "staffId=$StaffId&"
        }
        if ($TeamId) {
            $path += "teamId=$TeamId&"
        }
        $path += 'detail=' + (&{if ($Terse) { 'terse' } else { 'extended' }})

        $uri = [uri]::new($url, $path)
        
        (Invoke-RestMethod -Uri $uri -Headers $headers)
    }
}