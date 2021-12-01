function Get-CTEvent {
    [CmdletBinding(DefaultParameterSetName='notid')]
    param (
        [Parameter(Mandatory, Position=0, ParameterSetName='id')]
        [Alias('id')]
        [int] $EventId,

        [Parameter(ParameterSetName='notid')]
        [int] $Page,

        [Parameter(ParameterSetName='notid')]
        [int] $LastId,

        [Parameter(ParameterSetName='notid')]
        [int] $PageSize,

        [Parameter(ParameterSetName='notid')]
        [string] $LookupId1,

        [Parameter(ParameterSetName='notid')]
        [string] $LookupId2,

        [Parameter(ParameterSetName='notid')]
        [string] $LookupId3,

        [Parameter(ParameterSetName='notid')]
        [int] $OriginId,

        [Parameter(ParameterSetName='notid')]
        [switch] $Global,

        [Parameter(ParameterSetName='notid')]
        [switch] $Protected,

        [Parameter(ParameterSetName='notid')]
        [switch] $Suspended,

        [Parameter(ParameterSetName='notid',ValueFromPipelineByPropertyName)]
        [int] $RoomId,

        [Parameter(ParameterSetName='notid',ValueFromPipelineByPropertyName)]
        [int] $StaffId,

        [Parameter(ParameterSetName='notid',ValueFromPipelineByPropertyName)]
        [int] $StudentId,

        [Parameter(ParameterSetName='notid',ValueFromPipelineByPropertyName)]
        [int] $GroupId,

        [Parameter(ParameterSetName='notid',ValueFromPipelineByPropertyName)]
        [int] $DepartmentId,

        [Parameter(ParameterSetName='notid',ValueFromPipelineByPropertyName)]
        [int] $TeamId,

        [Parameter(ParameterSetName='notid',ValueFromPipelineByPropertyName)]
        [int] $EquipmentId,

        [Parameter(ParameterSetName='notid',ValueFromPipelineByPropertyName)]
        [int] $ModuleId,

        [Parameter(ParameterSetName='notid')]
        [datetime] $Date,

        [Parameter(ParameterSetName='notid')]
        [int] $Week,

        [Parameter(ParameterSetName='notid')]
        [dayofweek] $DayOfWeek,

        [Parameter(ParameterSetName='notid')]
        [string] $Custom1,

        [Parameter(ParameterSetName='notid')]
        [string] $Custom2,

        [Parameter(ParameterSetName='notid')]
        [string] $Custom3,

        [switch] $Terse
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
        if ($EventId) {
            $path = "/api/events/$EventId`?"
        }
        else {
            $path = '/api/events?'

            if ($Page) {
                $path += "page=$Page&"
            }
            if ($LastId) {
                $path += "lastId=$LastId&"
            }
            if ($PageSize) {
                $path += "pageSize=$PageSize&"
            }
            if ($LookupId1) {
                $path += "lookupid1=$LookupId1&"
            }
            if ($LookupId2) {
                $path += "lookupid2=$LookupId2&"
            }
            if ($LookupId3) {
                $path += "lookupid3=$LookupId3&"
            }
            if ($OriginId) {
                $path += "originId=$OriginId&"
            }
            if ($Global) {
                $path += 'global=true&'
            }
            if ($Protected) {
                $path += 'protected=true&'
            }
            if ($Suspended) {
                $path += 'suspended=true&'
            }
            if ($RoomId) {
                $path += "roomId=$RoomId&"
            }
            if ($StaffId) {
                $path += "staffId=$StaffId&"
            }
            if ($StudentId) {
                $path += "studentId=$StudentId&"
            }
            if ($GroupId) {
                $path += "groupId=$GroupId&"
            }
            if ($DepartmentId) {
                $path += "departmentId=$DepartmentId&"
            }
            if ($TeamId) {
                $path += "teamId=$TeamId&"
            }
            if ($EquipmentId) {
                $path += "equipmentId=$EquipmentId&"
            }
            if ($ModuleId) {
                $path += "moduleId=$ModuleId&"
            }
            if ($Date) {
                $path += "date=$($Date.ToString('yyyy-MM-dd'))&"
            }
            if ($Week) {
                $path += "week=$Week&"
            }
            if ($DayOfWeek) {
                $path += "dayOfWeek=$DayOfWeek&"
            }
            if ($Custom1) {
                $path += "custom1=$Custom1&"
            }
            if ($Custom2) {
                $path += "custom2=$Custom2&"
            }
            if ($Custom3) {
                $path += "custom3=$Custom3&"
            }
        }
        $path += 'detail=' + (&{if ($Terse) { 'terse' } else { 'extended' }}) + '&'
        $path += 'weekStartingDates=true&'
        $uri = [uri]::new($url, $path)
        
        (Invoke-RestMethod -Uri $uri -Headers $headers) | Add-Member -MemberType AliasProperty -Name EventId -Value Id -PassThru 
    }
}