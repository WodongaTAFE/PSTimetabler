function New-CTStudent {
    [CmdletBinding(SupportsShouldProcess)]
    param (
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [string]$UniqueName,

        [Parameter(ValueFromPipelineByPropertyName)]
        [string] $Name,

        [Parameter(ValueFromPipelineByPropertyName)]
        [string] $Title,

        [Parameter(ValueFromPipelineByPropertyName)]
        [int] $DepartmentId,

        [Parameter(ValueFromPipelineByPropertyName)]
        [string] $Sex,

        [Parameter(ValueFromPipelineByPropertyName)]
        [datetime] $DateOfBirth,

        [Parameter(ValueFromPipelineByPropertyName)]
        [string] $Address1,

        [Parameter(ValueFromPipelineByPropertyName)]
        [string] $Address2,

        [Parameter(ValueFromPipelineByPropertyName)]
        [string] $Address3,

        [Parameter(ValueFromPipelineByPropertyName)]
        [string] $Address4,

        [Parameter(ValueFromPipelineByPropertyName)]
        [string] $Postcode,

        [Parameter(ValueFromPipelineByPropertyName)]
        [int] $RoomId,

        [Parameter(ValueFromPipelineByPropertyName)]
        [string] $AcademicYear,

        [Parameter(ValueFromPipelineByPropertyName)]
        [int] $TutorId,

        [Parameter(ValueFromPipelineByPropertyName)]
        [string] $Custom1,

        [Parameter(ValueFromPipelineByPropertyName)]
        [string] $Custom2,

        [Parameter(ValueFromPipelineByPropertyName)]
        [string] $Custom3,

        [Parameter(ValueFromPipelineByPropertyName)]
        [string] $CardNumber,

        [Parameter(ValueFromPipelineByPropertyName)]
        [int] $WeeklyTarget,

        [Parameter(ValueFromPipelineByPropertyName)]
        [int] $TotalTarget,

        [Parameter(ValueFromPipelineByPropertyName)]
        [bool] $Schedulable,

        [Parameter(ValueFromPipelineByPropertyName)]
        [Alias('OfficePhone')]
        [string] $OfficeTelephone,

        [Parameter(ValueFromPipelineByPropertyName)]
        [Alias('HomePhone')]
        [string] $HomeTelephone,

        [Parameter(ValueFromPipelineByPropertyName)]
        [Alias('Mobile')]
        [Alias('MobilePhone')]
        [string] $MobileTelephone,

        [Parameter(ValueFromPipelineByPropertyName)]
        [string] $Fax,

        [Parameter(ValueFromPipelineByPropertyName)]
        [Alias('EmailAddress')]
        [string] $Email,

        [Parameter(ValueFromPipelineByPropertyName)]
        [Alias('HomePage')]
        [string] $WebAddress,

        [Parameter(ValueFromPipelineByPropertyName)]
        [string] $StudentProfile,

        [Parameter(ValueFromPipelineByPropertyName)]
        [string] $PhotoFile,

        [Parameter(ValueFromPipelineByPropertyName)]
        [bool] $DeafLoop,

        [Parameter(ValueFromPipelineByPropertyName)]
        [bool] $WheelchairAccess,

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
        $path = '/api/student'

        $uri = [uri]::new($url, $path)
        
        $body = @{
            uniqueName = $UniqueName
            name = $Name
            title = $Title
            departmentId = if ($PSBoundParameters.ContainsKey('DepartmentId')) { $DepartmentId } else { $null }
            sex	= $Sex
            dateOfBirth = $DateOfBirth
            address1 = $Address1
            address2 = $Address2
            address3 = $Address3
            address4 = $Address4
            postcode = $Postcode
            roomId = if ($PSBoundParameters.ContainsKey('RoomId')) { $RoomId } else { $null }
            academicYear = $AcademicYear
            tutorId = if ($PSBoundParameters.ContainsKey('TutorId')) { $TutorId } else { $null }
            custom1 = $Custom1
            custom2 = $Custom2
            custom3 = $Custom3
            cardNumber = $CardNumber
            weeklyTarget = if ($PSBoundParameters.ContainsKey('WeeklyTarget')) { $WeeklyTarget } else { $null }
            totalTarget	 = if ($PSBoundParameters.ContainsKey('TotalTarget')) { $TotalTarget } else { $null }
            schedulable	 = if ($PSBoundParameters.ContainsKey('Schedulable')) { $Schedulable } else { $null }
            officeTelephone	= $OfficeTelephone
            homeTelephone = $HomeTelephone
            mobileTelephone = $MobileTelephone
            fax = $Fax
            email = $Email
            webAddress = $WebAddress
            profile = $StudentProfile
            deafLoop = if ($PSBoundParameters.ContainsKey('DeafLoop')) { $DeafLoop } else { $null }
            wheelchairAccess = if ($PSBoundParameters.ContainsKey('WheelchairAccess')) { $WheelchairAccess } else { $null }
            notes = $Notes
            lookupId1 = $LookupId1
            lookupId2 = $LookupId2
            lookupId3 = $LookupId3
            originId = if ($PSBoundParameters.ContainsKey('OriginId')) { $OriginId } else { $null }
            originalId = $OriginalId
        }

        if ($PSCmdlet.ShouldProcess($UniqueName, 'Create student.')) {
            (Invoke-RestMethod -Uri $uri -Headers $headers -Method Post -Body (ConvertTo-Json $body) -ContentType 'application/json') | Add-Member -MemberType AliasProperty -Name StudentId -Value Id -PassThru 
        }
    }
}