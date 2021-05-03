# devops-build-agent

Based on [this MS article](https://docs.microsoft.com/en-us/azure/devops/pipelines/agents/docker?view=azure-devops)

## How to build

Simply check out the relevant docker file, then docker build.

## How to run

```ps1
.\StartBuildAgent.ps1 -azureDevOpsTeam "YOUR-TEAM" -azureDevOpsPat "xyz..." -azureDevOpsAgentPool "AGENT-POOL" -dockerImageName "win or win-java" -dockerRegistry "OPTIONAL" -dockerTag ":latest"
```
