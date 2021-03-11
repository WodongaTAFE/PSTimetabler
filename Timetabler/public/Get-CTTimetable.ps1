function Get-CTTimetable {
    [CmdletBinding()]
    param (
        [Parameter()]
        [switch] $Config,

        [Parameter()]
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
        $path = '/api/timetables?'

        if ($Config) {
            $path += "config=$Config&"
        }
        if ($Name) {
            $path += "name=$Name&"
        }

        $uri = [uri]::new($url, $path)
        
        Invoke-RestMethod -Uri $uri -Headers $headers 
    }
}