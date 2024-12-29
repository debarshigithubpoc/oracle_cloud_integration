// (String branchName, String dockerDirectory, String agentLabel, String dockerRegistrySecret , String dockerUsernameSecret, String dockerPassSecret)
@Library('dockerPipelineTemplate') _
dockerPipelineTemplate('development', 'Applications/DotnetDocker/dotnethelloworld', 'linux', 'dockerRegistry', 'dockerUsername', 'dockerPassword' )
