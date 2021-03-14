function Get-CTFaculty {
    [CmdletBinding(DefaultParameterSetName='notid')]
    param (
        [Parameter(Mandatory, Position=0, ParameterSetName='id')]
        [Alias('id')]
        [string] $FacultyId,

        [Parameter(ParameterSetName='notid')]
        [int] $Page,

        [Parameter(ParameterSetName='notid')]
        [int] $LastId,

        [Parameter(ParameterSetName='notid')]
        [int] $PageSize,

        [ValidateSet('terse', 'normal', 'extended')]
        [string] $Detail,

        [Parameter(ParameterSetName='notid')]
        [string] $LookupId1,

        [Parameter(ParameterSetName='notid')]
        [string] $LookupId2,

        [Parameter(ParameterSetName='notid')]
        [string] $LookupId3,

        [Parameter(ParameterSetName='notid')]
        [string] $OriginId,

        [Parameter(ParameterSetName='notid')]
        [string] $Name
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
        if ($FacultyId) {
            $path = "/api/faculties/$FacultyId"
        }
        else {
            $path = '/api/faculties?'

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
        $uri = [uri]::new($url, $path)
        
        (Invoke-RestMethod -Uri $uri -Headers $headers) | Add-Member -MemberType AliasProperty -Name FacultyId -Value Id -PassThru 
    }
}