pipeline {
    agent any
    
    environment {
        GITHUB_REPO     = "https://github.com/debarshigithubpoc/oracle_cloud_integration.git"
        BASE_WORKSPACE  = "C:\\jenkins_workspace"
    }
    
    stages {
        stage('Input Directory') {
            steps {
                script {
                    def choices = ['C:\\jenkins_workspace\\oracle_cloud_integration\\Terraform\\main\\dev', 'C:\\jenkins_workspace\\oracle_cloud_integration\\Terraform\\main\\staging', 'C:\\jenkins_workspace\\oracle_cloud_integration\\Terraform\\main\\prod']
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
                    if exist "%BASE_WORKSPACE%" rmdir /s /q "%BASE_WORKSPACE%"
                    mkdir "%BASE_WORKSPACE%"
                    cd "%BASE_WORKSPACE%"
                    git clone %GITHUB_REPO% 
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
                    terraform plan -destroy -out=tfplan
                """
            }
        }
        
        stage('Approval') {
            steps {
                input message: 'Review the plan and approve to destroy'
            }
        }
        
        stage('Terraform Destroy') {
            steps {
                bat """
                    cd "%WORKSPACE_DIR%"
                    terraform apply -destroy -auto-approve tfplan
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
