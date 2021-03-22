function Set-CTUserRole {
    [CmdletBinding(SupportsShouldProcess)]
    param (
        [Parameter(Mandatory, Position=0, ValueFromPipelineByPropertyName)]
        [int] $UserId,

        [Parameter(Mandatory, Position=1, ValueFromPipelineByPropertyName)]
        [int] $RoleId,

        [Parameter(Mandatory, Position=2, ValueFromPipelineByPropertyName)]
        [Alias('Default')]
        [Alias('IsDefault')]
        [bool] $DefaultRole,

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
        $path = "/api/user-roles/$UserId-$RoleId"

        $uri = [uri]::new($url, $path)
        
        $body = [PSCustomObject]@{
            userId = $UserId
            roleId = $RoleId
            defaultRole = $DefaultRole
        }

        if ($PSCmdlet.ShouldProcess("$UserId-$RoleId", 'Update user role.')) {
            Invoke-RestMethod -Uri $uri -Headers $headers -Method Put -Body (ConvertTo-Json $body) -ContentType 'application/json' | Out-Null
        }
        
        if ($PassThru) {
            return $body
        }
    }
}