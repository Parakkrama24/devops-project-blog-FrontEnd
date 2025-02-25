pipeline {
    agent any

    environment {
        DOCKER_HUB_USER = 'parakkrama'
        DOCKER_HUB_PASS = 'Para123##'
        IMAGE_NAME = 'parakkrama/frontend'
        CONTAINER_NAME = 'react_frontend'
        SERVER_USER = 'your_server_user'
        SERVER_HOST = 'Para123##'
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
                powershell 'npm install'
            }
        }

        stage('Build React App') {
            steps {
                powershell 'npm run build'
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    def imageTag = "${env.IMAGE_NAME}:${env.BUILD_NUMBER}"
                    def latestTag = "${env.IMAGE_NAME}:latest"
                    
                    bat "docker build -t ${imageTag} -t ${latestTag} ."
                }
            }
        }

        stage('Login to Docker Hub') {
            steps {
                script {
                    bat "docker login -u %DOCKER_HUB_USER% -p %DOCKER_HUB_PASS%"
                }
            }
        }

        stage('Push Image') {
            steps {
                script {
                    def imageTag = "${env.IMAGE_NAME}:${env.BUILD_NUMBER}"
                    def latestTag = "${env.IMAGE_NAME}:latest"

                    bat "docker push ${imageTag}"
                    bat "docker push ${latestTag}"
                }
            }
        }
    }
}
