function Remove-CTFaculty {
    [CmdletBinding(SupportsShouldProcess)]
    param (
        [Parameter(Mandatory, Position=0, ValueFromPipelineByPropertyName)]
        [Alias('Id')]
        [string] $FacultyId
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
        $path = "/api/faculties/$FacultyId"

        $uri = [uri]::new($url, $path)

        if ($PSCmdlet.ShouldProcess($FacultyId, 'Delete faculty.')) {
            Invoke-RestMethod -Uri $uri -Headers $headers -Method Delete
        }
    }
}