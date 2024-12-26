pipeline {
    agent any
    
    environment {
        GITHUB_REPO = "https://github.com/debarshigithubpoc/oracle_cloud_integration.git"
    }
    
    stages {
        stage('Input Directory') {
            steps {
                script {
                    def choices = ['C:\\jenkins_workspace\\Terraform\\main\\dev', 'C:\\jenkins_workspace\\Terraform\\main\\uat', 'C:\\jenkins_workspace\\Terraform\\main\\prod']
                    env.WORKSPACE_DIR = input(
                        message: 'Select the workspace directory',
                        parameters: [choice(name: 'WORKSPACE_DIR', choices: choices, description: 'Select a directory')]
                    )
                }
            }
        }

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
                    cd "%WORKSPACE_DIR%"
                    terraform init
                """
            }
        }

        stage('Terraform Format & Validate') {
            steps {
                bat """
                    cd "%WORKSPACE_DIR%"
                    terraform fmt -check
                    terraform validate
                """
            }
        }
        
        stage('Terraform Plan') {
            steps {
                bat """
                    cd "%WORKSPACE_DIR%"
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
                    cd "%WORKSPACE_DIR%"
                    terraform destroy -auto-approve tfplan
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
