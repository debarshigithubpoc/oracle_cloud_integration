@Library('terraformUnifiedTemplate') _

pipeline {
    agent any

    stages {
        stage('Development') {
            steps {
                script {
                    terraformUnifiedTemplate('Terraform/main/dev', 'windows')
                }
            }
        }

        stage('Approval') {
            steps {
                input message: 'Review the dev environment and promote it to staging environment'
            }
        }

        stage('Staging') {
            steps {
                script {
                    terraformUnifiedTemplate('Terraform/main/staging', 'windows')
                }
            }
        }

        stage('Approval') {
            steps {
                input message: 'Review the staging environment and promote it to production environment'
            }
        }

        stage('Production') {
            steps {
                script {
                    terraformUnifiedTemplate('Terraform/main/prod', 'windows')
                }
            }
        }

    }
}