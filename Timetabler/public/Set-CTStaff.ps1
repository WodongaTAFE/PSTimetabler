function Set-CTStaff {
    [CmdletBinding(SupportsShouldProcess)]
    param (
        [Parameter(Mandatory, Position=0, ValueFromPipelineByPropertyName)]
        [Alias('Id')]
        [int]$StaffId,

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
        [string] $Custom1,

        [Parameter(ValueFromPipelineByPropertyName)]
        [string] $Custom2,

        [Parameter(ValueFromPipelineByPropertyName)]
        [string] $Custom3,

        [Parameter(ValueFromPipelineByPropertyName)]
        [int] $WeeklyAllowance,

        [Parameter(ValueFromPipelineByPropertyName)]
        [int] $TotalAllowance,

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
        [string] $StaffProfile,

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
        $path = "/api/staff/$StaffId"

        $uri = [uri]::new($url, $path)
        
        $body = [PSCustomObject]@{
            id = $StaffId
            uniqueName = $UniqueName
            name = $Name
            title = $Title
            departmentId = if ($PSBoundParameters.ContainsKey('DepartmentId') -and $DepartmentId) { $DepartmentId } else { $null }
            sex	= $Sex
            address1 = $Address1
            address2 = $Address2
            address3 = $Address3
            address4 = $Address4
            postcode = $Postcode
            roomId = if ($PSBoundParameters.ContainsKey('RoomId')) { $RoomId } else { $null }
            custom1 = $Custom1
            custom2 = $Custom2
            custom3 = $Custom3
            weeklyAllowance = if ($PSBoundParameters.ContainsKey('WeeklyAllowance')) { $WeeklyAllowance } else { $null }
            totalAllowance = if ($PSBoundParameters.ContainsKey('TotalAllowance')) { $TotalAllowance } else { $null }
            weeklyTarget = if ($PSBoundParameters.ContainsKey('WeeklyTarget')) { $WeeklyTarget } else { $null }
            totalTarget	 = if ($PSBoundParameters.ContainsKey('TotalTarget')) { $TotalTarget } else { $null }
            schedulable	 = if ($PSBoundParameters.ContainsKey('Schedulable')) { $Schedulable } else { $null }
            officeTelephone	= $OfficeTelephone
            homeTelephone = $HomeTelephone
            mobileTelephone = $MobileTelephone
            fax = $Fax
            email = $Email
            webAddress = $WebAddress
            profile = $StaffProfile
            deafLoop = if ($PSBoundParameters.ContainsKey('DeafLoop')) { $DeafLoop } else { $null }
            wheelchairAccess = if ($PSBoundParameters.ContainsKey('WheelchairAccess')) { $WheelchairAccess } else { $null }
            notes = $Notes
            lookupId1 = $LookupId1
            lookupId2 = $LookupId2
            lookupId3 = $LookupId3
            originId = if ($PSBoundParameters.ContainsKey('OriginId')) { $OriginId } else { $null }
            originalId = $OriginalId
        }

        if ($PSCmdlet.ShouldProcess("$UniqueName - $StaffId", 'Update staff.')) {
            Invoke-RestMethod -Uri $uri -Headers $headers -Method Put -Body (ConvertTo-Json $body) -ContentType 'application/json' | Out-Null
        }
        
        if ($PassThru) {
            return $body | Add-Member -MemberType AliasProperty -Name StaffId -Value Id -PassThru 
        }
    }
}