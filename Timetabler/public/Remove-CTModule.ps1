function Remove-CTModule {
    [CmdletBinding(SupportsShouldProcess)]
    param (
        [Parameter(Mandatory, Position=0, ValueFromPipelineByPropertyName)]
        [Alias('id')]
        [string] $ModuleId
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
        $path = "/api/modules/$ModuleId"

        $uri = [uri]::new($url, $path)

        if ($PSCmdlet.ShouldProcess($ModuleId, 'Delete module.')) {
            Invoke-RestMethod -Uri $uri -Headers $headers -Method Delete
        }
    }
}