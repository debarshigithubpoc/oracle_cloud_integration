// vars/pipelineTemplate.groovy
def call(String branchName, String terraformDir, String agentLabel) {
    pipeline {
        agent { label agentLabel }
        
        environment {
            WORKSPACE_DIR = "C:\\jenkins_workspace"
            GITHUB_REPO   = "https://github.com/debarshigithubpoc/oracle_cloud_integration.git"
        }
        
        parameters {
            booleanParam(name: 'FORCE_RUN', defaultValue: false, description: 'Force run the pipeline stages')
        }
        
        triggers {
            pollSCM('* * * * *') // This will poll the SCM every 1 minute
        }

        tools {
            git 'Default'
        }

        stages {
            stage('Checkout') {
                when {
                    anyOf {
                        branch branchName
                        expression { return params.FORCE_RUN || currentBuild.changeSets.any { it.affectedFiles.any { it.path.startsWith(terraformDir) } } }
                    }
                }
                steps {
                    bat """
                        if exist "%WORKSPACE_DIR%" rmdir /s /q "%WORKSPACE_DIR%"
                        mkdir "%WORKSPACE_DIR%"
                        cd "%WORKSPACE_DIR%"
                        git clone %GITHUB_REPO% 
                    """
                }
            }
            
            stage('Terraform Init') {
                when {
                    anyOf {
                        branch branchName
                        expression { return params.FORCE_RUN || currentBuild.changeSets.any { it.affectedFiles.any { it.path.startsWith(terraformDir) } } }
                    }
                }
                steps {
                    bat """
                        cd "%WORKSPACE_DIR%\\oracle_cloud_integration\\${terraformDir}"
                        terraform init
                    """
                }
            }

            stage('Terraform Format & Validate') {
                when {
                    anyOf {
                        branch branchName
                        expression { return params.FORCE_RUN || currentBuild.changeSets.any { it.affectedFiles.any { it.path.startsWith(terraformDir) } } }
                    }
                }
                steps {
                    bat """
                        cd "%WORKSPACE_DIR%\\oracle_cloud_integration\\${terraformDir}"
                        terraform fmt -check
                        terraform validate
                    """
                }
            }
            
            stage('Terraform Plan') {
                when {
                    anyOf {
                        branch branchName
                        expression { return params.FORCE_RUN || currentBuild.changeSets.any { it.affectedFiles.any { it.path.startsWith(terraformDir) } } }
                    }
                }
                steps {
                    bat """
                        cd "%WORKSPACE_DIR%\\oracle_cloud_integration\\${terraformDir}"
                        terraform plan -out=tfplan
                    """
                }
            }
            
            stage('Approval') {
                when {
                    anyOf {
                        branch branchName
                        expression { return params.FORCE_RUN || currentBuild.changeSets.any { it.affectedFiles.any { it.path.startsWith(terraformDir) } } }
                    }
                }
                steps {
                    input message: 'Review the plan and approve to apply'
                }
            }
            
            stage('Terraform Apply') {
                when {
                    anyOf {
                        branch branchName
                        expression { return params.FORCE_RUN || currentBuild.changeSets.any { it.affectedFiles.any { it.path.startsWith(terraformDir) } } }
                    }
                }
                steps {
                    bat """
                        cd "%WORKSPACE_DIR%\\oracle_cloud_integration\\${terraformDir}"
                        terraform apply -auto-approve tfplan
                    """
                }
            }
        }
        
        post {
            always {
                cleanWs()
            }
        }
    }
}