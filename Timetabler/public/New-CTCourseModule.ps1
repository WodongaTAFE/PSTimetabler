function New-CTCourseModule {
    [CmdletBinding(SupportsShouldProcess)]
    param (
        [Parameter(Mandatory, Position=0, ValueFromPipelineByPropertyName)]
        [int] $CourseId,

        [Parameter(Mandatory, Position=1, ValueFromPipelineByPropertyName)]
        [int] $ModuleId,

        [Parameter(ValueFromPipelineByPropertyName)]
        [ValidateSet('C', 'O')]
        [string] $CoreOption
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
        $path = '/api/course-modules'

        $uri = [uri]::new($url, $path)
        
        $body = @{
            courseId = $CourseId
            moduleId = $ModuleId
            coreOption = $CoreOption
         }

        if ($PSCmdlet.ShouldProcess("$CourseId-$ModuleId", 'Create course module.')) {
            (Invoke-RestMethod -Uri $uri -Headers $headers -Method Post -Body (ConvertTo-Json $body) -ContentType 'application/json')
        }
    }
}