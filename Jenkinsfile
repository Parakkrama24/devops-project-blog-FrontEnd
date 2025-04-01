pipeline {
    agent any

    environment {
        DOCKER_HUB_USER = 'parakkrama'
        IMAGE_NAME = 'parakkrama/frontend'
        CONTAINER_NAME = 'react_frontend'
        SERVER_USER = 'ubuntu'  // Change to your actual Ubuntu user
        SERVER_HOST = 'your.server.ip' // Replace with AWS EC2 IP

         AWS_ACCESS_KEY = credentials('aws_access_key')   // Jenkins credential ID for access key
        AWS_SECRET_KEY = credentials('aws_seacret_key')  // Jenkins credential ID for secret key
    
    }

    triggers {
        githubPush()
    }

    stages {

       
        stage('Terraform Init') {
            steps {
                script {
                    sh '''
                    export AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY
                    export AWS_SECRET_ACCESS_KEY=$AWS_SECRET_KEY
                    terraform init
                    '''
                }
            }
        }

        // Terraform Apply
      stage('Terraform Apply') {
            steps {
                script {
                    sh '''
                    export AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY
                    export AWS_SECRET_ACCESS_KEY=$AWS_SECRET_KEY
                    terraform apply -auto-approve
                    '''
                }
            }
        }


 stage('Install Docker on EC2') {
    steps {
        script {
            withCredentials([sshUserPrivateKey(credentialsId: 'main_pem', keyFileVariable: 'SSH_KEY')]) {
                sh '''
                cd ~/ansible
                ansible-playbook -i inventory.ini \
                    --private-key=$SSH_KEY \
                    playbook.yml
                '''
            }
        }
    }
}


        stage('Checkout Code') {
            steps {
                git branch: 'deops_1', url: 'https://github.com/Parakkrama24/devops-project-blog-FrontEnd.git'
            }
        }

        stage('Install Dependencies') {
            steps {
                sh '''
                    npm install
                '''
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
                    withCredentials([string(credentialsId: 'docker-hub-password', variable: 'DOCKER_HUB_PASS')]) {
                        sh "echo ${DOCKER_HUB_PASS} | docker login -u ${DOCKER_HUB_USER} --password-stdin"
                    }
                }
            }
        }

        stage('Push Docker Image') {
            steps {
                script {
                    def imageTag = "${env.IMAGE_NAME}:${env.BUILD_NUMBER}"
                    def latestTag = "${env.IMAGE_NAME}:latest"

                    sh "docker push ${imageTag}"
                    sh "docker push ${latestTag}"
                }
            }
        }

 
    }
}
