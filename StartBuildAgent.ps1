param ([string] $azureDevOpsTeam, [string] $azureDevOpsPat, [string] $azureDevOpsAgentPool, [string] $dockerImageName, [string] $dockerRegistry, [string] $dockerTag)
if ([string]::IsNullOrEmpty($azureDevOpsTeam) -or 
    [string]::IsNullOrEmpty($azureDevOpsAgentPool) -or
    [string]::IsNullOrEmpty($dockerImageName) -or
    [string]::IsNullOrEmpty($dockerTag)) {
        return "Please provide all the required parameters."
}

# $dockerImageName = "win"
# $dockerRegistry = ""
# $dockerTag = ":latest"
$dockerImage = $dockerRegistry + $dockerImageName + $dockerTag
$agentName = $dockerImageName + "-" + [System.guid]::NewGuid().toString().SubString(0, 6)

Write-Output "Running docker image: $dockerImage with agent name: $agentName"

docker run `
    -d `
    --name $agentName `
    --restart unless-stopped `
    -e AZP_POOL=$azureDevOpsAgentPool `
    -e AZP_URL="https://dev.azure.com/$azureDevOpsTeam" `
    -e AZP_TOKEN=$azureDevOpsPat `
    -e AZP_AGENT_NAME=$agentName `
    $dockerImage