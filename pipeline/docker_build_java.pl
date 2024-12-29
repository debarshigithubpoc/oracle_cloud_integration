// Jenkinsfile for Docker Build for java
// variablesFormat(String branchName, String dockerDirectory, String agentLabel, String dockerRegistrySecret , String dockerUsernameSecret, String dockerPassSecret)
@Library('dockerPipelineTemplate') _
dockerPipelineTemplate('development', 'Applications/JavaDocker', 'linux', 'dockerRegistry', 'dockerUsername', 'dockerPassword' )