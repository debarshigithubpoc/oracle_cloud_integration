// Jenkinsfile for main
// variablesFormat(String branchName, String terraformDir, String agentLabel)
@Library('pipelineTemplate') _
pipelineTemplate('main', 'Terraform/main/prod', 'windows')