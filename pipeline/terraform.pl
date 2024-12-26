pipeline {
    agent any
    
    environment {
        WORKSPACE_DIR = "C:\\jenkins_workspace"
        GITHUB_REPO   = "https://github.com/debarshigithubpoc/oracle_cloud_integration.git"
    }
    
    stages {
        stage('Checkout') {
            steps {
                bat """
                    if exist "%WORKSPACE_DIR%" rmdir /s /q "%WORKSPACE_DIR%"
                    git clone %GITHUB_REPO% "%WORKSPACE_DIR%"
                """
            }
        }
        
        stage('Terraform Init') {
            steps {
                bat """
                    cd "%WORKSPACE_DIR%\\Terraform\\main"
                    terraform init
                """
            }
        }

        stage('Terraform Format & Validate') {
            steps {
                bat """
                    cd "%WORKSPACE_DIR%\\Terraform\\main"
                    terraform fmt -check
                    terraform validate
                """
            }
        }
        
        stage('Terraform Plan') {
            steps {
                bat """
                    cd "%WORKSPACE_DIR%\\Terraform\\main"
                    terraform plan -out=tfplan
                """
            }
        }
        
        stage('Approval') {
            steps {
                input message: 'Review the plan and approve to apply'
            }
        }
        
        stage('Terraform Apply') {
            steps {
                bat """
                    cd "%WORKSPACE_DIR%\\Terraform\\main"
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