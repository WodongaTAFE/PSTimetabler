function Remove-CTCourseModule {
    [CmdletBinding(SupportsShouldProcess)]
    param (
        [Parameter(Mandatory, Position=0, ValueFromPipelineByPropertyName)]
        [int] $CourseId,

        [Parameter(Mandatory, Position=1, ValueFromPipelineByPropertyName)]
        [int] $ModuleId
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
        $path = "/api/course-modules/$CourseId-$ModuleId"

        $uri = [uri]::new($url, $path)

        if ($PSCmdlet.ShouldProcess("$CourseId-$ModuleId", 'Delete course module.')) {
            Invoke-RestMethod -Uri $uri -Headers $headers -Method Delete
        }
    }
}