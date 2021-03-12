function Remove-CTTeam {
    [CmdletBinding(SupportsShouldProcess)]
    param (
        [Parameter(Mandatory, Position=0, ParameterSetName='id')]
        [Alias('Id')]
        [string] $TeamId
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
        $path = "/api/teams/$TeamId"

        $uri = [uri]::new($url, $path)

        if ($PSCmdlet.ShouldProcess($TeamId, 'Delete team.')) {
            Invoke-RestMethod -Uri $uri -Headers $headers -Method Delete
        }
    }
}