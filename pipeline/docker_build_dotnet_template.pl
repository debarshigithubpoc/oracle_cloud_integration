// call(String branchName, String dockerDirectory, String agentLabel, String dockerRegistrySecret , String dockerUsernameSecret, String dockerPasswordSecret)
@Library('dockerPipelineTemplate') _
pipelineTemplate('development', 'Applications/DotnetDocker/dotnethelloworld', 'linux', 'dockerRegistry', 'dockerUsername', 'dockerPassword' )