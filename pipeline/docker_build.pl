pipeline {
    agent { label 'linux' }
    
    environment {
        WORKSPACE_DIR = "/home/jenkins"
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
                    branch 'development'
                    expression { return params.FORCE_RUN || currentBuild.changeSets.any { it.affectedFiles.any { it.path.startsWith('Applications/DotnetDocker/dotnethelloworld') } } }
                }
            }
            steps {
                sh '''
                    cd "/home/jenkins/workspace/docker_build_image"
                    git clone $GITHUB_REPO
                '''
            }
        }

        stage('Docker Build') {
            when {
                anyOf {
                    branch 'development'
                    expression { return params.FORCE_RUN || currentBuild.changeSets.any { it.affectedFiles.any { it.path.startsWith('Applications/DotnetDocker/dotnethelloworld') } } }
                }
            }
            steps {
                sh '''
                    cd "/home/jenkins/workspace/docker_build_image/oracle_cloud_integration/Applications/DotnetDocker/dotnethelloworld"
                    docker login HYD.ocir.io/ax4qhhyy6wvq/privateregistry --username 'ax4qhhyy6wvq/debarshi.eee@gmail.com' --password 'YS1i2<[VrEMLXTQjmstb'
                    docker build . -t dotnet:v1
                '''
            }
        }
        
        stage('Approval') {
            when {
                anyOf {
                    branch 'development'
                    expression { return params.FORCE_RUN || currentBuild.changeSets.any { it.affectedFiles.any { it.path.startsWith('Applications/DotnetDocker/dotnethelloworld') } } }
                }
            }
            steps {
                input message: 'Review the docker image build before pushing to container registry'
            }
        }
        
        stage('Docker Push to Container Registry') {
            when {
                anyOf {
                    branch 'development'
                    expression { return params.FORCE_RUN || currentBuild.changeSets.any { it.affectedFiles.any { it.path.startsWith('Applications/DotnetDocker/dotnethelloworld') } } }
                }
            }
            steps {
                sh '''
                    docker tag dotnet:v1 HYD.ocir.io/ax4qhhyy6wvq/privateregistry/dotnet:v1
                    docker push HYD.ocir.io/ax4qhhyy6wvq/privateregistry/dotnet:v1
                '''
            }
        }

        stage('Docker cleanup tags and images') {
            when {
                anyOf {
                    branch 'development'
                    expression { return params.FORCE_RUN || currentBuild.changeSets.any { it.affectedFiles.any { it.path.startsWith('Applications/DotnetDocker/dotnethelloworld') } } }
                }
            }
            steps {
                sh '''
                    docker rmi HYD.ocir.io/ax4qhhyy6wvq/privateregistry/dotnet:v1
                    docker rmi dotnet:v1
                '''
            }
        }        
    }
    
    post {
        always {
            cleanWs()
        }
    }
    
}
