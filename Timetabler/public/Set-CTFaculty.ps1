function Set-CTFaculty {
    [CmdletBinding(SupportsShouldProcess)]
    param (
        [Parameter(Mandatory, Position=0, ValueFromPipelineByPropertyName)]
        [Alias('Id')]
        [int] $FacultyId,

        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [string] $Name,

        [Parameter(ValueFromPipelineByPropertyName)]
        [Alias('Color')]
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
        $path = "/api/faculties/$FacultyId"

        $uri = [uri]::new($url, $path)
        
        $body = @{
            id = $FacultyId
            name = $Name
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

        if ($PSCmdlet.ShouldProcess("$Name - $FacultyId", 'Update faculty.')) {
            Invoke-RestMethod -Uri $uri -Headers $headers -Method Put -Body (ConvertTo-Json $body) -ContentType 'application/json'
        }
    }
}