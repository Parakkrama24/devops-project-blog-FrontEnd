pipeline {
    agent any

    environment {
        DOCKER_HUB_USER = 'parakkrama'
        IMAGE_NAME = 'parakkrama/frontend'
        CONTAINER_NAME = 'react_frontend'
        SERVER_USER = 'ubuntu'
        SERVER_HOST = 'your.server.ip'
    }

    triggers {
        githubPush()
    }

    stages {
        stage('Checkout Code') {
            steps {
                git branch: 'deops_1', url: 'https://github.com/Parakkrama24/devops-project-blog-FrontEnd.git'
            }
        }

        stage('Build & Push Docker Image') {
            steps {
                script {
                    def latestTag = "${env.IMAGE_NAME}:latest"

                    withCredentials([string(credentialsId: 'docker-hub-password', variable: 'DOCKER_HUB_PASS')]) {
                        sh "echo ${DOCKER_HUB_PASS} | docker login -u ${DOCKER_HUB_USER} --password-stdin"
                    }

                    sh """
                        docker build -t ${latestTag} .
                        docker push ${latestTag}
                    """
                }
            }
        }

        stage('Deploy to Server') {
            steps {
                script {
                    sshagent(['aws-ssh-key']) {
                        sh """
                            ssh -o StrictHostKeyChecking=no ${SERVER_USER}@${SERVER_HOST} << EOF
                            docker pull ${IMAGE_NAME}:latest
                            docker stop ${CONTAINER_NAME} || true
                            docker rm ${CONTAINER_NAME} || true
                            docker run -d --name ${CONTAINER_NAME} -p 3000:3000 ${IMAGE_NAME}:latest
                            EOF
                        """
                    }
                }
            }
        }
    }
}
