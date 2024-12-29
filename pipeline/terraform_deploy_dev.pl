// Jenkinsfile for Terraform Deployment in development environment
// variablesFormat(String branchName, String terraformDir, String agentLabel)
@Library('pipelineTemplate') _
pipelineTemplate('development', 'Terraform/main/dev', 'windows')