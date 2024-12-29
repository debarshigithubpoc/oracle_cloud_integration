// call(String branchName, String dockerDirectory, String agentLabel, String dockerRegistrySecret , String dockerUsernameSecret, String dockerPasswordSecret)
@Library('dockerPipelineTemplate') _
dockerPipelineTemplate('development', 'Applications/DotnetDocker/dotnethelloworld', '/home/jenkins/workspace/docker_build_image/oracle_cloud_integration/Applications/DotnetDocker/dotnethelloworld', 'linux', 'dockerRegistry', 'dockerUsername', 'dockerPassword' )
