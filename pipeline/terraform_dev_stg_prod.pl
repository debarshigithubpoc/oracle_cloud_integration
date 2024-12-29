@Library('terraformUnifiedTemplate') _

pipeline {
    agent any

    stages {
        stage('Development') {
            when {
                branch 'development'
            }
            steps {
                script {
                    terraformUnifiedTemplate('development', 'Terraform/main/dev', 'windows')
                }
            }
        }
        stage('Main') {
            when {
                branch 'main'
            }
            steps {
                script {
                    terraformUnifiedTemplate('main', 'Terraform/main/prod', 'windows')
                }
            }
        }
        stage('Staging') {
            when {
                branch 'staging'
            }
            steps {
                script {
                    terraformUnifiedTemplate('staging', 'Terraform/main/staging', 'windows')
                }
            }
        }
    }
}