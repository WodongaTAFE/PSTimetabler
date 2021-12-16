function Get-CTRoomLayout {
    [CmdletBinding(DefaultParameterSetName='notid')]
    param (
        [Parameter(ParameterSetName='notid',ValueFromPipelineByPropertyName)]
        [Parameter(ParameterSetName='id',Mandatory,Position=0)]
        [int] $RoomId,
        
        [Parameter(ParameterSetName='notid',ValueFromPipelineByPropertyName)]
        [Parameter(ParameterSetName='id',Mandatory,Position=1)]
        [int] $LayoutId,

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
            $path = "/api/room-layouts/$RoomId-$LayoutId`?"
        }
        else {
            $path = '/api/room-layouts?'

            if ($Page) {
                $path += "page=$Page&"
            }
            if ($LastId) {
                $path += "lastId=$LastId&"
            }
            if ($PageSize) {
                $path += "pageSize=$PageSize&"
            }
            if ($LayoutId) {
                $path += "layoutId=$LayoutId&"
            }
            if ($RoomId) {
                $path += "roomId=$RoomId&"
            }
        }
        $path += 'detail=' + (&{if ($Terse) { 'terse' } else { 'extended' }})
        
        $uri = [uri]::new($url, $path)
 
        try {
            $result = (Invoke-RestMethod -Uri $uri -Headers $headers) 
            if ($result) {
                $result
            }
        }
        catch {
            if ($_.Exception.Response.StatusCode -ne 404) {
                throw
            }
        }
    }
}