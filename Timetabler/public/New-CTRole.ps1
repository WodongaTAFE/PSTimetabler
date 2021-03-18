function New-CTRole {
    [CmdletBinding(SupportsShouldProcess)]
    param (
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [string] $Name,

        [Parameter(ValueFromPipelineByPropertyName)]
        [bool] $Admin = $false,

        [Parameter(ValueFromPipelineByPropertyName)]
        [bool] $UseSMS = $false,

        [Parameter(ValueFromPipelineByPropertyName)]
        [bool] $UseAttendance = $false,

        [Parameter(ValueFromPipelineByPropertyName)]
        [bool] $CanWithdrawStudentFromRegisters = $false,

        [Parameter(ValueFromPipelineByPropertyName)]
        [bool] $CanRemoveStudentFromRegister = $false,

        [Parameter(ValueFromPipelineByPropertyName)]
        [bool] $CanAddStudentToRegister = $false,

        [Parameter(ValueFromPipelineByPropertyName)]
        [bool] $SupervisorData = $false,

        [Parameter(ValueFromPipelineByPropertyName)]
        [bool] $OlaViewer = $false,

        [Parameter(ValueFromPipelineByPropertyName)]
        [bool] $UseExtendedAbsence = $false,

        [Parameter(ValueFromPipelineByPropertyName)]
        [bool] $CanUseRoomBooker = $false,

        [Parameter(ValueFromPipelineByPropertyName)]
        [bool] $CanUseExamScheduler = $false,

        [Parameter(ValueFromPipelineByPropertyName)]
        [bool] $CanUseCourseScheduler = $false,

        [Parameter(ValueFromPipelineByPropertyName)]
        [bool] $CanUseClient = $false,

        [Parameter(ValueFromPipelineByPropertyName)]
        [bool] $CanViewExamScheduler = $false,

        [Parameter(ValueFromPipelineByPropertyName)]
        [bool] $CanViewCourseScheduler = $false,

        [Parameter(ValueFromPipelineByPropertyName)]
        [bool] $CanModifyOrigins = $false,

        [Parameter(ValueFromPipelineByPropertyName)]
        [bool] $CanAcceptOwnClash = $false,

        [Parameter(ValueFromPipelineByPropertyName)]
        [bool] $CanAcceptAnyClash = $false,

        [Parameter(ValueFromPipelineByPropertyName)]
        [bool] $CanRunCsvImport = $false,

        [Parameter(ValueFromPipelineByPropertyName)]
        [bool] $CanRunCsvExport = $false,

        [Parameter(ValueFromPipelineByPropertyName)]
        [bool] $CanBlockMarkRegisters = $false,

        [Parameter(ValueFromPipelineByPropertyName)]
        [bool] $CanUnlockRegisters = $false,

        [Parameter(ValueFromPipelineByPropertyName)]
        [bool] $CanBookPortalRooms = $false,

        [Parameter(ValueFromPipelineByPropertyName)]
        [bool] $CanBookPortalMeetings = $false,

        [Parameter(ValueFromPipelineByPropertyName)]
        [string] $Description,

        [Parameter(ValueFromPipelineByPropertyName)]
        [datetime] $DateChange,

        [Parameter(ValueFromPipelineByPropertyName)]
        [int] $UserIdChange,

        [Parameter(ValueFromPipelineByPropertyName)]
        [string] $UserName,

        [Parameter(ValueFromPipelineByPropertyName)]
        [string] $ChangeOperation  
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
        $path = '/api/roles'

        $uri = [uri]::new($url, $path)
        
        $body = @{
            name = $Name
            admin = $Admin
            useSms = $UseSMS
            useAttendance = $UseAttendance
            canWithdrawStudentFromRegisters = $CanWithdrawStudentFromRegisters
            canRemoveStudentFromRegister = $CanRemoveStudentFromRegister
            canAddStudentToRegister	= $CanAddStudentToRegister
            supervisorData = $SupervisorData
            olaViewer = $OlaViewer
            useExtendedAbsence = $UseExtendedAbsence
            canUseRoomBooker = $CanUseRoomBooker
            canUseExamScheduler = $CanUseExamScheduler
            canUseCourseScheduler = $CanUseCourseScheduler
            canUseClient = $CanUseClient
            canViewExamScheduler = $CanViewExamScheduler
            canViewCourseScheduler = $CanViewCourseScheduler
            canModifyOrigins = $CanModifyOrigins
            canAcceptOwnClash = $CanAcceptOwnClash
            canAcceptAnyClash = $CanAcceptAnyClash
            canRunCsvImport = $CanRunCsvImport
            canRunCsvExport = $CanRunCsvExport
            canBlockMarkRegisters = $CanBlockMarkRegisters
            canUnlockRegisters = $CanUnlockRegisters
            canBookPortalRooms = $CanBookPortalRooms
            canBookPortalMeetings = $CanBookPortalMeetings
            description = $Description
            dateChange = $DateChange
            userIdChange = if ($PSBoundParameters.ContainsKey('UserIdChange')) { $UserIdChange } else { $null } 
            userName = $UserName
            changeOperation = $ChangeOperation
        }

        if ($PSBoundParameters.ContainsKey('Default')) {
            $body.Default = $Default
        }

        if ($PSCmdlet.ShouldProcess("$UserId-$RoleId", 'Create role.')) {
            (Invoke-RestMethod -Uri $uri -Headers $headers -Method Post -Body (ConvertTo-Json $body) -ContentType 'application/json')
        }
    }
}