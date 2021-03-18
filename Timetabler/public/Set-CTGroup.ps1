function Set-CTGroup {
    [CmdletBinding(SupportsShouldProcess)]
    param (
        [Parameter(Mandatory, Position=0, ValueFromPipelineByPropertyName)]
        [Alias('Id')]
        [int] $GroupId,

        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [string]$UniqueName,

        [Parameter(ValueFromPipelineByPropertyName)]
        [string] $Name,

        [Parameter(ValueFromPipelineByPropertyName)]
        [int] $DepartmentId,

        [Parameter(ValueFromPipelineByPropertyName)]
        [Alias('Year')]
        [int] $AcademicYear,

        [Parameter(ValueFromPipelineByPropertyName)]
        [int] $StaffId1,

        [Parameter(ValueFromPipelineByPropertyName)]
        [int] $StaffId2,

        [Parameter(ValueFromPipelineByPropertyName)]
        [string] $Custom1,

        [Parameter(ValueFromPipelineByPropertyName)]
        [string] $Custom2,

        [Parameter(ValueFromPipelineByPropertyName)]
        [string] $Custom3,

        [Parameter(ValueFromPipelineByPropertyName)]
        [int] $WeeklyTarget,

        [Parameter(ValueFromPipelineByPropertyName)]
        [int] $TotalTarget,

        [Parameter(ValueFromPipelineByPropertyName)]
        [int] $TargetSize,

        [Parameter(ValueFromPipelineByPropertyName)]
        [bool] $Schedulable,

        [Parameter(ValueFromPipelineByPropertyName)]
        [Alias('EmailAddress')]
        [string] $Email,

        [Parameter(ValueFromPipelineByPropertyName)]
        [Alias('HomePage')]
        [string] $WebAddress,

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
        [string] $OriginalId,

        [switch] $PassThru
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
        $path = "/api/groups/$GroupId"

        $uri = [uri]::new($url, $path)
        
        $body = @{
            id = $GroupId
            uniqueName = $UniqueName
            name = $Name
            departmentId = if ($PSBoundParameters.ContainsKey('DepartmentId')) { $DepartmentId } else { $null }
            academicYear = if ($PSBoundParameters.ContainsKey('AcademicYear')) { $AcademicYear } else { $null }
            staffId1 = if ($PSBoundParameters.ContainsKey('StaffId1')) { $StaffId1 } else { $null }
            staffId2 = if ($PSBoundParameters.ContainsKey('StaffId2')) { $StaffId2 } else { $null }
            custom1 = $Custom1
            custom2 = $Custom1
            custom3 = $Custom3
            weeklyTarget = if ($PSBoundParameters.ContainsKey('WeeklyTarget')) { $WeeklyTarget } else { $null }
            totalTarget	 = if ($PSBoundParameters.ContainsKey('TotalTarget')) { $TotalTarget } else { $null }
            targetSize	 = if ($PSBoundParameters.ContainsKey('TargetSize')) { $TargetSize } else { $null }
            schedulable	 = if ($PSBoundParameters.ContainsKey('Schedulable')) { $Schedulable } else { $null }
            email = $Email
            webAddress = $WebAddress
            notes = $Notes
            lookupId1 = $LookupId1
            lookupId2 = $LookupId2
            lookupId3 = $LookupId3
            originId = if ($PSBoundParameters.ContainsKey('OriginId')) { $OriginId } else { $null }
            originalId = $OriginalId
        }

        if ($PSCmdlet.ShouldProcess("$UniqueName - $GroupId", 'Update group.')) {
            Invoke-RestMethod -Uri $uri -Headers $headers -Method Put -Body (ConvertTo-Json $body) -ContentType 'application/json' | Out-Null
        }

        if ($PassThru) {
            return $body
        }
    }
}