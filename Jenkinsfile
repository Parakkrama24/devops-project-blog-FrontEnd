pipeline {
    agent any

    environment {
        DOCKER_HUB_USER = 'parakkrama'
        DOCKER_HUB_PASS = 'Para123##'
        IMAGE_NAME = 'parakkrama/frontend'
        CONTAINER_NAME = 'react_frontend'
        SERVER_USER = 'ubuntu'  // Change if using another user
        SERVER_HOST = 'your_server_ip_or_domain' // Replace with actual AWS instance IP
    }

    triggers {
        githubPush()  // Automatically trigger on GitHub push events
    }

    stages {
        stage('Checkout Code') {
            steps {
                git branch: 'deops_1', url: 'https://github.com/Parakkrama24/devops-project-blog-FrontEnd.git'
            }
        }

        stage('Install Dependencies') {
            steps {
                sh 'npm install'
            }
        }

        stage('Build React App') {
            steps {
                sh 'npm run build'
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    def imageTag = "${env.IMAGE_NAME}:${env.BUILD_NUMBER}"
                    def latestTag = "${env.IMAGE_NAME}:latest"
                    
                    sh "docker build -t ${imageTag} -t ${latestTag} ."
                }
            }
        }

        stage('Login to Docker Hub') {
            steps {
                script {
                    sh "echo $DOCKER_HUB_PASS | docker login --username $DOCKER_HUB_USER --password-stdin"
                }
            }
        }

        stage('Push Image') {
            steps {
                script {
                    def imageTag = "${env.IMAGE_NAME}:${env.BUILD_NUMBER}"
                    def latestTag = "${env.IMAGE_NAME}:latest"

                    sh "docker push ${imageTag}"
                    sh "docker push ${latestTag}"
                }
            }
        }

        stage('Deploy to AWS') {
            steps {
                script {
                    sh """
                    ssh -o StrictHostKeyChecking=no $SERVER_USER@$SERVER_HOST << EOF
                        docker pull $IMAGE_NAME:latest
                        docker stop $CONTAINER_NAME || true
                        docker rm $CONTAINER_NAME || true
                        docker run -d --name $CONTAINER_NAME -p 3000:3000 $IMAGE_NAME:latest
                    EOF
                    """
                }
            }
        }
    }
}
