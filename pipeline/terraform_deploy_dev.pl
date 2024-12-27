pipeline {
    agent any
    
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

    stages {

        stage('Checkout') {
            when {
                anyOf {
                    branch 'development'
                    expression { return params.FORCE_RUN || currentBuild.changeSets.any { it.affectedFiles.any { it.path.startsWith('Terraform/main/dev') } } }
                }
            }
            steps {
                bat """
                    git clone %GITHUB_REPO% "%WORKSPACE_DIR%"
                    cd
                    dir
                """
            }
        }

        stage('Terraform Init') {
            when {
                anyOf {
                    branch 'development'
                    expression { return params.FORCE_RUN || currentBuild.changeSets.any { it.affectedFiles.any { it.path.startsWith('Terraform/main/dev') } } }
                }
            }
            steps {
                bat """
                    cd "%WORKSPACE_DIR%\\Terraform\\main\\dev"
                    terraform init
                """
            }
        }

        stage('Terraform Format & Validate') {
            when {
                anyOf {
                    branch 'development'
                    expression { return params.FORCE_RUN || currentBuild.changeSets.any { it.affectedFiles.any { it.path.startsWith('Terraform/main/dev') } } }
                }
            }
            steps {
                bat """
                    cd "%WORKSPACE_DIR%\\Terraform\\main\\dev"
                    terraform fmt -check
                    terraform validate
                """
            }
        }
        
        stage('Terraform Plan') {
            when {
                anyOf {
                    branch 'development'
                    expression { return params.FORCE_RUN || currentBuild.changeSets.any { it.affectedFiles.any { it.path.startsWith('Terraform/main/dev') } } }
                }
            }
            steps {
                bat """
                    cd "%WORKSPACE_DIR%\\Terraform\\main\\dev"
                    terraform plan -out=tfplan
                """
            }
        }
        
        stage('Approval') {
            when {
                anyOf {
                    branch 'development'
                    expression { return params.FORCE_RUN || currentBuild.changeSets.any { it.affectedFiles.any { it.path.startsWith('Terraform/main/dev') } } }
                }
            }
            steps {
                input message: 'Review the plan and approve to apply'
            }
        }
        
        stage('Terraform Apply') {
            when {
                anyOf {
                    branch 'development'
                    expression { return params.FORCE_RUN || currentBuild.changeSets.any { it.affectedFiles.any { it.path.startsWith('Terraform/main/dev') } } }
                }
            }
            steps {
                bat """
                    cd "%WORKSPACE_DIR%\\Terraform\\main\\dev"
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
