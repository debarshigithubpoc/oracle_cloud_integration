// Jenkinsfile for development
// variablesFormat(String branchName, String terraformDir, String agentLabel)
@Library('pipelineTemplate') _
pipelineTemplate('development', 'Terraform/main/dev', 'windows')