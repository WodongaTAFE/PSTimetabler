function Get-CTCourseModule {
    [CmdletBinding(DefaultParameterSetName='notid')]
    param (
        [Parameter(Mandatory, Position=0, ParameterSetName='id', ValueFromPipelineByPropertyName)]
        [Parameter(ParameterSetName='notid', ValueFromPipelineByPropertyName)]
        [string] $CourseId,

        [Parameter(Mandatory, Position=1, ParameterSetName='id', ValueFromPipelineByPropertyName)]
        [Parameter(ParameterSetName='notid', ValueFromPipelineByPropertyName)]
        [string] $ModuleId,

        [Parameter(ParameterSetName='notid')]
        [int] $Page,

        [Parameter(ParameterSetName='notid')]
        [int] $LastId,

        [Parameter(ParameterSetName='notid')]
        [int] $PageSize,

        [ValidateSet('terse', 'normal', 'extended')]
        [string] $Detail
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
            $path = "/api/course-modules/$CourseId-$ModuleId"
        }
        else {
            $path = '/api/course-modules?'

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
            if ($CourseId) {
                $path += "courseId=$CourseId&"
            }
            if ($ModuleId) {
                $path += "moduleId=$ModuleId&"
            }
        }
        $uri = [uri]::new($url, $path)
        
        (Invoke-RestMethod -Uri $uri -Headers $headers)
    }
}