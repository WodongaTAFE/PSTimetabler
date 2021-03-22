function Get-CTUserRole {
    [CmdletBinding(DefaultParameterSetName='notid')]
    param (
        [Parameter(Mandatory, Position=0, ParameterSetName='id', ValueFromPipelineByPropertyName)]
        [Parameter(ParameterSetName='notid', ValueFromPipelineByPropertyName)]
        [string] $UserId,

        [Parameter(Mandatory, Position=1, ParameterSetName='id', ValueFromPipelineByPropertyName)]
        [Parameter(ParameterSetName='notid', ValueFromPipelineByPropertyName)]
        [string] $RoleId,

        [Parameter(ParameterSetName='notid')]
        [int] $Page,

        [Parameter(ParameterSetName='notid')]
        [int] $LastId,

        [Parameter(ParameterSetName='notid')]
        [int] $PageSize,

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
        if ($PSCmdlet.ParameterSetName -eq 'id') {
            $path = "/api/user-roles/$UserId-$RoleId`?"
        }
        else {
            $path = '/api/user-roles?'

            if ($Page) {
                $path += "page=$Page&"
            }
            if ($LastId) {
                $path += "lastId=$LastId&"
            }
            if ($PageSize) {
                $path += "pageSize=$PageSize&"
            }
            if ($UserId) {
                $path += "userId=$UserId&"
            }
            if ($RoleId) {
                $path += "roleId=$RoleId&"
            }
        }
        $path += 'detail=' + (&{if ($Terse) { 'terse' } else { 'extended' }})
        $uri = [uri]::new($url, $path)
        
        (Invoke-RestMethod -Uri $uri -Headers $headers)
    }
}