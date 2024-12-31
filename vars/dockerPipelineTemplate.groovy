// vars/dockerPipelineTemplate.groovy
def call(String branchName, String dockerDirectory, String dockerImageName, String agentLabel, String dockerRegistrySecret , String dockerUsernameSecret, String dockerPassSecret, String helmRelease, String helmPath) {
pipeline {
    agent { label agentLabel }
    
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
        git 'Linux'
    }

    stages {

        stage('Checkout') {
            when {
                anyOf {
                    branch branchName
                    expression { 
                        return params.FORCE_RUN || currentBuild.changeSets.any { changeSet ->
                            changeSet.items.any { item ->
                                item.affectedFiles.any { it.path.startsWith(dockerDirectory) }
                            }
                        }
                    }
                }
            }
            steps {
                sh '''
                    DIR="/home/jenkins/workspace/docker_build_image"
                    rm -r "$DIR" --force
                    mkdir -p "$DIR"
                    cd "$DIR"
                    git clone $GITHUB_REPO
                '''
            }
        }

        stage('Docker Build') {
            when {
                anyOf {
                    branch branchName
                    expression { 
                        return params.FORCE_RUN || currentBuild.changeSets.any { changeSet ->
                            changeSet.items.any { item ->
                                item.affectedFiles.any { it.path.startsWith(dockerDirectory) }
                            }
                        }
                    }
                }
            }
            steps {
                withCredentials([string(credentialsId: dockerRegistrySecret, variable: 'DOCKER_REGISTRY'),
                                 string(credentialsId: dockerUsernameSecret, variable: 'DOCKER_USERNAME'),
                                 string(credentialsId: dockerPassSecret, variable: 'DOCKER_SECRET')]) {
                    sh """
                    cd "/home/jenkins/workspace/docker_build_image/oracle_cloud_integration/${dockerDirectory}"
                    docker login "${DOCKER_REGISTRY}" --username "${DOCKER_USERNAME}" --password "${DOCKER_SECRET}"
                    docker build . -t "${dockerImageName}:${BUILD_NUMBER}"
                """
                }
            }
        }
        
        stage('Approval for pushing the artifact to OCI registry') {
            when {
                anyOf {
                    branch branchName
                    expression { 
                        return params.FORCE_RUN || currentBuild.changeSets.any { changeSet ->
                            changeSet.items.any { item ->
                                item.affectedFiles.any { it.path.startsWith(dockerDirectory) }
                            }
                        }
                    }
                }
            }
            steps {
                input message: 'Review the docker image build before pushing to container registry'
            }
        }
        
        stage('Docker Push to Container Registry') {
            when {
                anyOf {
                    branch branchName
                    expression { 
                        return params.FORCE_RUN || currentBuild.changeSets.any { changeSet ->
                            changeSet.items.any { item ->
                                item.affectedFiles.any { it.path.startsWith(dockerDirectory) }
                            }
                        }
                    }
                }
            }
            steps {
                withCredentials([string(credentialsId: dockerRegistrySecret, variable: 'DOCKER_REGISTRY')]) {
                    sh """
                    docker tag "${dockerImageName}:${BUILD_NUMBER}" "${DOCKER_REGISTRY}/${dockerImageName}:${BUILD_NUMBER}"
                    docker push "${DOCKER_REGISTRY}/${dockerImageName}:${BUILD_NUMBER}"
                    """
                }
            }
        }

        stage('Docker cleanup tags and images') {
            when {
                anyOf {
                    branch branchName
                    expression { return params.FORCE_RUN || currentBuild.changeSets.any { it.affectedFiles.any { it.path.startsWith(dockerDirectory) } } }
                }
            }
            steps {
                sh '''
                    docker container prune -f
                    docker image prune -a -f
                    docker volume prune -f
                    docker network prune -f
                    echo "Docker cleanup completed!"
                '''
            }
        }

        stage('Approval for Deploying in OCI Kubernetes Cluster') {
            when {
                anyOf {
                    branch branchName
                    expression { 
                        return params.FORCE_RUN || currentBuild.changeSets.any { changeSet ->
                            changeSet.items.any { item ->
                                item.affectedFiles.any { it.path.startsWith(dockerDirectory) }
                            }
                        }
                    }
                }
            }
            steps {
                input message: 'Review the steps before deploying it in kubernetes cluster'
            }
        }

        stage('Kubernetes Deployment Creation') {
            when {
                anyOf {
                    branch branchName
                    expression { 
                        return params.FORCE_RUN || currentBuild.changeSets.any { changeSet ->
                            changeSet.items.any { item ->
                                item.affectedFiles.any { it.path.startsWith(dockerDirectory) }
                            }
                        }
                    }
                }
            }
            steps {
                withCredentials([string(credentialsId: dockerUsernameSecret, variable: 'DOCKER_USERNAME'),
                                 string(credentialsId: dockerPassSecret, variable: 'DOCKER_SECRET')]) {
                    sh """
                    export PATH=$PATH:/home/jenkins/bin
                    source ~/.bashrc
                    oci -v
                    kubectl create secret docker-registry ocirsecret --docker-server=hyd.ocir.io --docker-username="${DOCKER_USERNAME}" --docker-password="${DOCKER_SECRET}" --docker-email='debarshi.eee@gmail.com'
                    cd "/home/jenkins/workspace/docker_build_image/oracle_cloud_integration/kubernetes/helmcharts"
                    helm upgrade --install "${helmRelease}" "${helmPath}" --set image.tag="${BUILD_NUMBER}"
                    helm list
                    kubectl get all
                """
                }
            }
        }            
    }
    
    post {
        always {
            cleanWs()
        }
    }
    
}

}