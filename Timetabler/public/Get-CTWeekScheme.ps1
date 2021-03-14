function Get-CTWeekScheme {
    [CmdletBinding()]
    param (
        [int] $Page,

        [int] $LastId,

        [int] $PageSize,

        [ValidateSet('terse', 'normal', 'extended')]
        [string] $Detail,

        [string] $Name
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
        if ($Detail) {
            $path += "detail=$Detail&"
        }
        if ($Name) {
            $path += "name=$Name&"
        }

        $uri = [uri]::new($url, $path)
        
        (Invoke-RestMethod -Uri $uri -Headers $headers) | Add-Member -MemberType AliasProperty -Name WeekId -Value Id -PassThru 
    }
}