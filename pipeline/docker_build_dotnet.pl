// Jenkinsfile for Docker Build for dotnet
// variablesFormat(String branchName, String dockerDirectory, String dockerImageName, String agentLabel, String dockerRegistrySecret , String dockerUsernameSecret, String dockerPassSecret)
@Library('dockerPipelineTemplate') _
dockerPipelineTemplate('development', 'Applications/DotnetDocker/dotnethelloworld', 'dotnet', 'linux', 'dockerRegistry', 'dockerUsername', 'dockerPassword' )
