function New-CTCourse {
    [CmdletBinding(SupportsShouldProcess)]
    param (
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [string] $Name,

        [Parameter(ValueFromPipelineByPropertyName)]
        [int] $DepartmentId,

        [Parameter(ValueFromPipelineByPropertyName)]
        [int] $StaffId1,

        [Parameter(ValueFromPipelineByPropertyName)]
        [int] $StaffId2,

        [Parameter(ValueFromPipelineByPropertyName)]
        [Alias('HomePage')]
        [string] $WebAdress,

        [Parameter(ValueFromPipelineByPropertyName)]
        [string] $Notes,

        [Parameter(ValueFromPipelineByPropertyName)]
        [string] $LookupId1,

        [Parameter(ValueFromPipelineByPropertyName)]
        [string] $LookupId2,

        [Parameter(ValueFromPipelineByPropertyName)]
        [string] $LookupId3,

        [Parameter(ValueFromPipelineByPropertyName)]
        [int] $OriginId,

        [Parameter(ValueFromPipelineByPropertyName)]
        [string] $OriginalId
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
        $path = '/api/courses'

        $uri = [uri]::new($url, $path)
        
        $body = @{
            name = $Name
            departmentId = if ($PSBoundParameters.ContainsKey('DepartmentId')) { $DepartmentId } else { $null }
            staffId1 = if ($PSBoundParameters.ContainsKey('StaffId1')) { $StaffId1 } else { $null }
            staffId2 = if ($PSBoundParameters.ContainsKey('StaffId2')) { $StaffId2 } else { $null }
            webAddress = $WebAdress
            notes = $Notes
            lookupId1 = $LookupId1
            lookupId2 = $LookupId2
            lookupId3 = $LookupId3
            originId = if ($PSBoundParameters.ContainsKey('OriginId')) { $OriginId } else { $null }
            originalId = $OriginalId
         }

        if ($PSCmdlet.ShouldProcess($Name, 'Create course.')) {
            (Invoke-RestMethod -Uri $uri -Headers $headers -Method Post -Body (ConvertTo-Json $body) -ContentType 'application/json') | Add-Member -MemberType AliasProperty -Name CourseID -Value Id -PassThru 
        }
    }
}