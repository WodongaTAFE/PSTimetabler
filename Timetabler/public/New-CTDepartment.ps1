function New-CTDepartment {
    [CmdletBinding(SupportsShouldProcess)]
    param (
        [Parameter(ValueFromPipelineByPropertyName)]
        [string] $Name,

        [Parameter(ValueFromPipelineByPropertyName)]
        [int] $FacultyId,

        [Parameter(ValueFromPipelineByPropertyName)]
        [int] $Colour,

        [Parameter(ValueFromPipelineByPropertyName)]
        [int] $StaffId1,

        [Parameter(ValueFromPipelineByPropertyName)]
        [int] $StaffId2,

        [Parameter(ValueFromPipelineByPropertyName)]
        [Alias('telephoneNumber')]        
        [string] $Telephone,

        [Parameter(ValueFromPipelineByPropertyName)]
        [Alias('EmailAddress')]
        [string] $Email,

        [Parameter(ValueFromPipelineByPropertyName)]
        [Alias('HomePage')]
        [string] $WebAdress,

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
        $path = '/api/departments'

        $uri = [uri]::new($url, $path)
        
        $body = @{
            name = $Name
            facultyId = if ($PSBoundParameters.ContainsKey('FacultyId')) { $FacultyId } else { $null }
            colour = if ($PSBoundParameters.ContainsKey('Colour')) { $Colour } else { $null }
            staffId1 = if ($PSBoundParameters.ContainsKey('StaffId1')) { $StaffId1 } else { $null }
            staffId2 = if ($PSBoundParameters.ContainsKey('StaffId2')) { $StaffId2 } else { $null }
            telephone = $Telephone
            email = $Email
            webAddress = $WebAdress
            lookupId1 = $LookupId1
            lookupId2 = $LookupId2
            lookupId3 = $LookupId3
            originId = if ($PSBoundParameters.ContainsKey('OriginId')) { $OriginId } else { $null }
            originalId = $OriginalId
        }

        if ($PSCmdlet.ShouldProcess($UniqueName, 'Create department.')) {
            Invoke-RestMethod -Uri $uri -Headers $headers -Method Post -Body (ConvertTo-Json $body) -ContentType 'application/json' | Add-Member -MemberType AliasProperty -Name DepartmentID -Value Id -PassThru 
        }
    }
}