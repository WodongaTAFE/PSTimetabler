function Remove-CTStaff {
    [CmdletBinding(SupportsShouldProcess)]
    param (
        [Parameter(Mandatory, Position=0, ParameterSetName='id')]
        [Alias('id')]
        [string] $StaffId
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

        if ($PSCmdlet.ShouldProcess($StaffId, 'Delete staff.')) {
            Invoke-RestMethod -Uri $uri -Headers $headers -Method Delete
        }
    }
}