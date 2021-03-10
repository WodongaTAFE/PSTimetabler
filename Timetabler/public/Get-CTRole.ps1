function Get-CTRole {
    [CmdletBinding(DefaultParameterSetName='notid')]
    param (
        [Parameter(Mandatory, Position=0, ParameterSetName='id')]
        [Alias('id')]
        [string] $RoleId,

        [Parameter(ParameterSetName='notid')]
        [int] $Page,

        [Parameter(ParameterSetName='notid')]
        [int] $LastId,

        [Parameter(ParameterSetName='notid')]
        [int] $PageSize,

        [Parameter(ParameterSetName='notid')]
        [ValidateSet('terse', 'normal', 'extended')]
        [string] $Detail,

        [Parameter(ParameterSetName='notid',ValueFromPipelineByPropertyName)]
        [int] $DepartmentId,

        [Parameter(ParameterSetName='notid')]
        [string] $Name
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
        if ($RoleId) {
            $path = "/api/roles/$RoleId"
        }
        else {
            $path = '/api/roles?'

            if ($Page) {
                $path += "page=$Page&"
            }
            if ($LastId) {
                $path += "lastId=$LastId&"
            }
            if ($PageSize) {
                $path += "pageSize=$PageSize&"
            }
            if ($Detail) {
                $path += "detail=$Detail&"
            }
            if ($DepartmentId) {
                $path += "departmentId=$DepartmentId&"
            }
              if ($Name) {
                $path += "name=$Name&"
            }
        }
        $uri = [uri]::new($url, $path)
        
        Invoke-RestMethod -Uri $uri -Headers $headers | Add-Member -MemberType AliasProperty -Name RoleId -Value Id -PassThru 
    }
}