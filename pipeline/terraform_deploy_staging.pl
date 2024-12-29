// Jenkinsfile for Terraform Deployment in Staging environment
// variablesFormat(String branchName, String terraformDir, String agentLabel)
@Library('pipelineTemplate') _
pipelineTemplate('staging', 'Terraform/main/staging', 'windows')