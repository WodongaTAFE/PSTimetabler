function New-CTUser {
    [CmdletBinding(SupportsShouldProcess)]
    param (
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [string] $Name,

        [Parameter(ValueFromPipelineByPropertyName)]
        [Alias('IsActive')]
        [Alias('Enabled')]
        [nullable[bool]] $Active,

        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [securestring] $Password,

        [Parameter(ValueFromPipelineByPropertyName)]
        [Alias('samAccountName')]
        [string] $NTName,

        [Parameter(ValueFromPipelineByPropertyName)]
        [Alias('DistinguishedName')]
        [string] $LDAPBindDN,

        [Parameter(ValueFromPipelineByPropertyName)]
        [int] $DepartmentId,

        [Parameter(ValueFromPipelineByPropertyName)]
        [int] $StaffId,

        [Parameter(ValueFromPipelineByPropertyName)]
        [int] $StudentId,

        [Parameter(ValueFromPipelineByPropertyName)]
        [bool] $MustChangePassword,

        [Parameter(ValueFromPipelineByPropertyName)]
        [bool] $CanChangePassword,

        [Parameter(ValueFromPipelineByPropertyName)]
        [Alias('EmailAddress')]
        [string] $Email,

        [Parameter(ValueFromPipelineByPropertyName)]
        [bool] $WantBookingMail,

        [Parameter(ValueFromPipelineByPropertyName)]
        [bool] $BookingAdmin,

        [Parameter(ValueFromPipelineByPropertyName)]
        [string] $LookupId1,

        [Parameter(ValueFromPipelineByPropertyName)]
        [string] $LookupId2,

        [Parameter(ValueFromPipelineByPropertyName)]
        [string] $LookupId3
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
        $path = '/api/users'

        $uri = [uri]::new($url, $path)

        # Extract plain text password from credential
        $marshal = [Runtime.InteropServices.Marshal]
        $pw = $marshal::PtrToStringAuto( $marshal::SecureStringToBSTR($Password) )

        $body = @{
            name = $Name
            active = if ($PSBoundParameters.ContainsKey('Active')) { $Active } else { $null }
            password = $pw
            ntName = $NTName
            ldapBindDn = $LDAPBindDN
            departmentId = if ($PSBoundParameters.ContainsKey('DepartmentId') -and $DepartmentId) { $DepartmentId } else { $null }
            staffId = if ($PSBoundParameters.ContainsKey('StaffId')) { $StaffId } else { $null }
            studentId = if ($PSBoundParameters.ContainsKey('StudentId')) { $StudentId } else { $null }
            mustChangePassword = if ($PSBoundParameters.ContainsKey('MustChangePassword')) { $MustChangePassword } else { $null }
            canChangePassword = if ($PSBoundParameters.ContainsKey('CanChangePassword')) { $CanChangePassword } else { $null }
            email = $Email
            wantBookingMail = if ($PSBoundParameters.ContainsKey('WantBookingMail')) { $WantBookingMail } else { $null }
            bookingAdmin = if ($PSBoundParameters.ContainsKey('BookingAdmin')) { $BookingAdmin } else { $null }
            lookupId1 = $LookupId1
            lookupId2 = $LookupId2
            lookupId3 = $LookupId3
         }

        if ($PSCmdlet.ShouldProcess($Name, 'Create user.')) {
            (Invoke-RestMethod -Uri $uri -Headers $headers -Method Post -Body (ConvertTo-Json $body) -ContentType 'application/json') | Add-Member -MemberType AliasProperty -Name UserId -Value Id -PassThru 
        }
    }
}