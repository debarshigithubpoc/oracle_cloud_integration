pipeline {
    agent any
    
    environment {
        WORKSPACE_DIR = "C:\\jenkins_workspace"
        GITHUB_REPO   = "https://github.com/debarshigithubpoc/oracle_cloud_integration.git"
    }
    
    triggers {
        pollSCM('* * * * *') // This will poll the SCM every 1 minutes
    }

    stages {
        stage('Checkout') {
            steps {
                script {
                    if (env.BRANCH_NAME == 'development') {
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
                branch 'development'
                expression { return currentBuild.changeSets.any { it.affectedFiles.any { it.path.startsWith('Terraform/main/dev') } } }
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
                branch 'development'
                expression { return currentBuild.changeSets.any { it.affectedFiles.any { it.path.startsWith('Terraform/main/dev') } } }
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
                branch 'development'
                expression { return currentBuild.changeSets.any { it.affectedFiles.any { it.path.startsWith('Terraform/main/dev') } } }
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
                branch 'development'
                expression { return currentBuild.changeSets.any { it.affectedFiles.any { it.path.startsWith('Terraform/main/dev') } } }
            }
            steps {
                input message: 'Review the plan and approve to apply'
            }
        }
        
        stage('Terraform Apply') {
            when {
                branch 'development'
                expression { return currentBuild.changeSets.any { it.affectedFiles.any { it.path.startsWith('Terraform/main/dev') } } }
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
