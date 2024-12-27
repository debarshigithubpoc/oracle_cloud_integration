pipeline {
    agent any
    
    environment {
        WORKSPACE_DIR = "C:\\jenkins_workspace\\staging"
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
            steps {
                script {
                    if (env.BRANCH_NAME == 'staging') {
                        bat """
                            if exist "%WORKSPACE_DIR%" rmdir /s /q "%WORKSPACE_DIR%"
                            git clone %GITHUB_REPO% "%WORKSPACE_DIR%"
                        """
                    }
                }
            }
        }
        
        stage('Terraform Init') {
            when {
                anyOf {
                    branch 'staging'
                    expression { return params.FORCE_RUN || currentBuild.changeSets.any { it.affectedFiles.any { it.path.startsWith('Terraform/main/staging') } } }
                }
            }
            steps {
                bat """
                    cd "%WORKSPACE_DIR%\\Terraform\\main\\staging"
                    terraform init
                """
            }
        }

        stage('Terraform Format & Validate') {
            when {
                anyOf {
                    branch 'staging'
                    expression { return params.FORCE_RUN || currentBuild.changeSets.any { it.affectedFiles.any { it.path.startsWith('Terraform/main/staging') } } }
                }
            }
            steps {
                bat """
                    cd "%WORKSPACE_DIR%\\Terraform\\main\\staging"
                    terraform fmt -check
                    terraform validate
                """
            }
        }
        
        stage('Terraform Plan') {
            when {
                anyOf {
                    branch 'staging'
                    expression { return params.FORCE_RUN || currentBuild.changeSets.any { it.affectedFiles.any { it.path.startsWith('Terraform/main/staging') } } }
                }
            }
            steps {
                bat """
                    cd "%WORKSPACE_DIR%\\Terraform\\main\\staging"
                    terraform plan -out=tfplan
                """
            }
        }
        
        stage('Approval') {
            when {
                anyOf {
                    branch 'staging'
                    expression { return params.FORCE_RUN || currentBuild.changeSets.any { it.affectedFiles.any { it.path.startsWith('Terraform/main/staging') } } }
                }
            }
            steps {
                input message: 'Review the plan and approve to apply'
            }
        }
        
        stage('Terraform Apply') {
            when {
                anyOf {
                    branch 'staging'
                    expression { return params.FORCE_RUN || currentBuild.changeSets.any { it.affectedFiles.any { it.path.startsWith('Terraform/main/staging') } } }
                }
            }
            steps {
                bat """
                    cd "%WORKSPACE_DIR%\\Terraform\\main\\staging"
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
