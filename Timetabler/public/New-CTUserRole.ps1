function New-CTUserRole {
    [CmdletBinding(SupportsShouldProcess)]
    param (
        [Parameter(Mandatory, Position=0, ValueFromPipelineByPropertyName)]
        [int] $UserId,

        [Parameter(Mandatory, Position=1, ValueFromPipelineByPropertyName)]
        [int] $RoleId,

        [Parameter(ValueFromPipelineByPropertyName)]
        [Alias('IsDefault')]
        [bool] $Default
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
        $path = '/api/user-roles'

        $uri = [uri]::new($url, $path)
        
        $body = @{
            userId = $UserId
            roleId = $RoleId
        }

        if ($PSBoundParameters.ContainsKey('Default')) {
            $body.Default = $Default
        }

        if ($PSCmdlet.ShouldProcess("$UserId-$RoleId", 'Create user role.')) {
            (Invoke-RestMethod -Uri $uri -Headers $headers -Method Post -Body (ConvertTo-Json $body) -ContentType 'application/json')
        }
    }
}