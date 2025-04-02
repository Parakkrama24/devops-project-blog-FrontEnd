pipeline {
    agent any

    environment {
        DOCKER_HUB_USER = 'parakkrama'
        IMAGE_NAME = 'parakkrama/frontend'
        CONTAINER_NAME = 'react_frontend'
        SERVER_USER = 'ubuntu'
        SERVER_HOST = ''

        AWS_ACCESS_KEY = credentials('aws_access_key')
        AWS_SECRET_KEY = credentials('aws_seacret_key')
        SSH_KEY_PATH = '/root/jenkinsKey.pem'
    }

    triggers {
        githubPush()
    }

    stages {
        stage('Copy Secret File') {
            steps {
                script {
                    withCredentials([file(credentialsId: 'main_pem', variable: 'PEM_FILE')]) {
                        sh 'cp $PEM_FILE $WORKSPACE/jenkinsKey.pem'
                        sh 'chmod 600 $WORKSPACE/jenkinsKey.pem'
                    }
                }
            }
        }

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

        stage('Terraform Apply') {
            steps {
                script {
                    sh '''
                    terraform apply -auto-approve \
                        -var="AWS_ACCESS_KEY=$AWS_ACCESS_KEY" \
                        -var="AWS_SECRET_KEY=$AWS_SECRET_KEY"
                    '''
                }
            }
        }

        stage('Fetch EC2 IP') {
    steps {
        script {
            def ec2Ip = sh(script: 'terraform output -raw jenkins_public_ip', returnStdout: true).trim()
            echo "Fetched EC2 IP: ${ec2Ip}"
            
            // ✅ Pass the IP directly in the SSH command instead of modifying env.SERVER_HOST
            writeFile file: 'inventory.ini', text: """
            [jenkins]
            ${ec2Ip} ansible_user=ubuntu ansible_ssh_private_key_file=$WORKSPACE/jenkinsKey.pem ansible_python_interpreter=/usr/bin/python3
            """

            // ✅ Save to a temporary file
            writeFile file: 'server_host.txt', text: ec2Ip
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
                    def imageTag = "${IMAGE_NAME}:${BUILD_NUMBER}"
                    def latestTag = "${IMAGE_NAME}:latest"

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
                    def imageTag = "${IMAGE_NAME}:${BUILD_NUMBER}"
                    def latestTag = "${IMAGE_NAME}:latest"

                    sh "docker push ${imageTag}"
                    sh "docker push ${latestTag}"
                }
            }
        }

        stage('Deploy to EC2 using SSH') {
    steps {
        script {
            def ec2Ip = readFile('server_host.txt').trim() // ✅ Read IP from file
            sh """
            ssh -o StrictHostKeyChecking=no -i $SSH_KEY_PATH $SERVER_USER@${ec2Ip} <<EOF
            sudo apt update -y
            sudo apt install -y docker.io docker-compose
            sudo systemctl start docker
            sudo systemctl enable docker

            docker stop $CONTAINER_NAME || true
            docker rm $CONTAINER_NAME || true
            docker pull ${IMAGE_NAME}:latest
            docker run -d --name $CONTAINER_NAME -p 3000:3000 ${IMAGE_NAME}:latest
            EOF
            """
        }
    }
}

    }
}
