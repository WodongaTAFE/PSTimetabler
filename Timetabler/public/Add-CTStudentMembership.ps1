function Add-CTStudentMembership {
    [CmdletBinding(SupportsShouldProcess)]
    param (
        [Parameter(Mandatory, Position=0, ValueFromPipelineByPropertyName)]
        [int] $GroupId,

        [Parameter(Mandatory, Position=1, ValueFromPipelineByPropertyName)]
        [int] $StudentId
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
        $path = '/api/student-membership'

        $uri = [uri]::new($url, $path)
        
        $body = @{
            groupId = $GroupId
            studentId = $StudentId
         }

        if ($PSCmdlet.ShouldProcess("$GroupId-$StudentId", 'Create student membership.')) {
            (Invoke-RestMethod -Uri $uri -Headers $headers -Method Post -Body (ConvertTo-Json $body) -ContentType 'application/json')
        }
    }
}