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
                powershell "docker build -t ${env.IMAGE_NAME}:latest ."
            }
        }

         stage('Login to Docker Hub') {
            steps {
                script {
                    bat label: 'Docker Login', script: "docker login -u %DOCKER_HUB_USER% -p %DOCKER_HUB_PASS%"
                }
            }
         }
              stage('Push Image') {
            steps {
                bat 'docker push %DOCKER_HUB_USER%/%IMAGE_NAME%:%BUILD_NUMBER%'
            }
        }

        // stage('Deploy on Server') {
        //     steps {
        //         sshagent(['your-ssh-key']) {
        //             sh """
        //             ssh $SERVER_USER@$SERVER_HOST '
        //                 docker pull $IMAGE_NAME:latest &&
        //                 docker stop $CONTAINER_NAME || true &&
        //                 docker rm $CONTAINER_NAME || true &&
        //                 docker run -d --name $CONTAINER_NAME -p 3000:80 $IMAGE_NAME:latest
        //             '
        //             """
        //         }
        //     }
        // }
    }
}
