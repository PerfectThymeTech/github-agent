# Define script arguments
[CmdletBinding()]
param (
    [Parameter(Mandatory = $true)]
    [String]
    $AzureDevOpsOrganizationUrl,

    [Parameter(Mandatory = $true)]
    [String]
    $AzureDevOpsAgentPoolId,

    [Parameter(Mandatory = $false, ValueFromRemainingArguments = $true)]
    [string[]]
    $Remaining
)

# Change the ErrorActionPreference to 'Stop' to fail in case of an error
$ErrorActionPreference = "Stop"

function Set-AdoAgent {
    param (
        [Parameter(Mandatory = $true)]
        [String]
        $AzureDevOpsOrganizationUrl,

        [Parameter(Mandatory = $true)]
        [String]
        $AzureDevOpsAgentPoolId
    )

    # Get token for Azure REST API
    $token = (az account get-access-token --resource "499b84ac-1321-427f-aa17-267ca6975798" --query "accessToken" -o tsv).Trim('"')

    # Prepare REST API call to create dummy agent
    $url = "${AzureDevOpsOrganizationUrl}/_apis/distributedtask/pools/${AzureDevOpsAgentPoolId}/agents?api-version=7.1"
    $headers = @{
        'Content-Type'  = 'application/json'
        'Authorization' = "Bearer ${token}"
    }
    $body = @{
        'name'    = "DummyAgent-$(New-Guid)"
        'enabled' = $false
        'status'  = 'offline'
        'version' = '4.268.0'
    } | ConvertTo-Json
    $parameters = @{
        'Uri'         = $url
        'Method'      = 'Post'
        'Headers'     = $headers
        'ContentType' = 'application/json'
        'Body'        = $body
    }

    # Run REST API call to create dummy agent
    try {
        Invoke-RestMethod @parameters
        Write-Host "Successfully created dummy agent in Azure DevOps organization '${AzureDevOpsOrganizationUrl}'"
    }
    catch {
        $message = "REST API call to create dummy agent failed"
        Write-Error $message
        throw $message
        exit 1
    }
}

# Add dummy agent to Azure DevOps organization
Set-AdoAgent `
    -AzureDevOpsOrganizationUrl $AzureDevOpsOrganizationUrl  `
    -AzureDevOpsAgentPoolId $AzureDevOpsAgentPoolId
