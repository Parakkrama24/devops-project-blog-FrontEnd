pipeline {
    agent any

    environment {
        DOCKER_HUB_USER = 'your_dockerhub_username'
        DOCKER_HUB_PASS = 'your_dockerhub_password'
        IMAGE_NAME = 'your_dockerhub_username/frontend'
        CONTAINER_NAME = 'react_frontend'
        SERVER_USER = 'your_server_user'
        SERVER_HOST = 'your_server_ip'
    }

    stages {
        stage('Checkout Code') {
            steps {
                git branch: 'deops_1', url: 'https://github.com/your-username/your-frontend-repo.git'
            }
        }

        stage('Install Dependencies') {
            steps {
                sh "npm install"
            }
        }

        stage('Build React App') {
            steps {
                sh "npm run build"
            }
        }

        stage('Build Docker Image') {
            steps {
                sh "docker build -t $IMAGE_NAME:latest ."
            }
        }

        
    }
}
