function Get-CTWeekScheme {
    [CmdletBinding()]
    param (
        [int] $Page,

        [int] $LastId,

        [int] $PageSize,

        [string] $Name,

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
        $path = '/api/week-schemes?'

        if ($Page) {
            $path += "page=$Page&"
        }
        if ($LastId) {
            $path += "lastId=$LastId&"
        }
        if ($PageSize) {
            $path += "pageSize=$PageSize&"
        }
        if ($Name) {
            $path += "name=$Name&"
        }
        $path += 'detail=' + (&{if ($Terse) { 'terse' } else { 'extended' }})

        $uri = [uri]::new($url, $path)
        
        (Invoke-RestMethod -Uri $uri -Headers $headers) | Add-Member -MemberType AliasProperty -Name WeekId -Value Id -PassThru 
    }
}