// Jenkinsfile for Docker Build for java
// variablesFormat(String branchName, String dockerDirectory, String dockerImageName, String agentLabel, String dockerRegistrySecret , String dockerUsernameSecret, String dockerPassSecret)
@Library('dockerPipelineTemplate') _
dockerPipelineTemplate('development', 'Applications/JavaDocker', 'java', 'linux', 'dockerRegistry', 'dockerUsername', 'dockerPassword', 'javahellorelease', './javahelloworld/')

