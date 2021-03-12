function Remove-CTDepartment {
    [CmdletBinding(SupportsShouldProcess)]
    param (
        [Parameter(Mandatory, Position=0, ParameterSetName='id')]
        [Alias('Id')]
        [string] $DepartmentId
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
        $path = "/api/departments/$DepartmentId"

        $uri = [uri]::new($url, $path)

        if ($PSCmdlet.ShouldProcess($DepartmentId, 'Delete department.')) {
            Invoke-RestMethod -Uri $uri -Headers $headers -Method Delete
        }
    }
}