@Library('pipelineTemplate') _

pipeline {
    agent any

    stages {
        stage('Development') {
            when {
                branch 'development'
            }
            steps {
                script {
                    pipelineTemplate('development', 'Terraform/main/dev', 'windows')
                }
            }
        }
        stage('Main') {
            when {
                branch 'main'
            }
            steps {
                script {
                    pipelineTemplate('main', 'Terraform/main/prod', 'windows')
                }
            }
        }
        stage('Staging') {
            when {
                branch 'staging'
            }
            steps {
                script {
                    pipelineTemplate('staging', 'Terraform/main/staging', 'windows')
                }
            }
        }
    }
}