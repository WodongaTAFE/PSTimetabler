function Get-CTStaff {
    [CmdletBinding(DefaultParameterSetName='notid')]
    param (
        [Parameter(Mandatory, Position=0, ParameterSetName='id', ValueFromPipelineByPropertyName)]
        [Alias('id')]
        [int] $StaffId,

        [Parameter(ParameterSetName='notid')]
        [int] $Page,

        [Parameter(ParameterSetName='notid')]
        [int] $LastId,

        [Parameter(ParameterSetName='notid')]
        [int] $PageSize,

        [Parameter(ParameterSetName='notid')]
        [string] $Custom1,

        [Parameter(ParameterSetName='notid')]
        [string] $Custom2,

        [Parameter(ParameterSetName='notid')]
        [string] $Custom3,

        [Parameter(ParameterSetName='notid',ValueFromPipelineByPropertyName)]
        [int] $DepartmentId,

        [Parameter(ParameterSetName='notid')]
        [string] $LookupId1,

        [Parameter(ParameterSetName='notid')]
        [string] $LookupId2,

        [Parameter(ParameterSetName='notid')]
        [string] $LookupId3,

        [Parameter(ParameterSetName='notid')]
        [int] $OriginId,

        [Parameter(ParameterSetName='notid')]
        [string] $Name,

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
        if ($StaffId) {
            $path = "/api/staff/$StaffId`?"
        }
        else {
            $path = '/api/staff?'

            if ($Page) {
                $path += "page=$Page&"
            }
            if ($LastId) {
                $path += "lastId=$LastId&"
            }
            if ($PageSize) {
                $path += "pageSize=$PageSize&"
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
            if ($DepartmentId) {
                $path += "departmentId=$DepartmentId&"
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
            if ($Name) {
                $path += "name=$Name&"
            }
        }
        $path += 'detail=' + (&{if ($Terse) { 'terse' } else { 'extended' }})
        $uri = [uri]::new($url, $path)
 
        try {
            $result = (Invoke-RestMethod -Uri $uri -Headers $headers) 
            if ($result) {
                $result | Add-Member -MemberType AliasProperty -Name StaffId -Value Id -PassThru 
            }
        }
        catch {
            if ($_.Exception.Response.StatusCode -ne 404) {
                throw
            }
        }
    }
}