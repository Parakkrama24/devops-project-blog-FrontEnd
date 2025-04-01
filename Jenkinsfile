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
        SSH_KEY_PATH = '/root/jenkinsKey.pem' // Ensure correct path to the .pem file
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
                    // Apply Terraform and get output
                    sh '''
            terraform apply -auto-approve \
              -var="AWS_ACCESS_KEY=$AWS_ACCESS_KEY" \
              -var="AWS_SECRET_KEY=$AWS_SECRET_KEY"
            '''
                    // Get the public IP address from Terraform output
                    def jenkins_ip = sh(script: 'terraform output -raw jenkins_public_ip', returnStdout: true).trim()
 
                    // Save the IP address to the Ansible inventory file
                    writeFile file: 'ansible/inventory.ini', text: """
[jenkins]
$jenkins_ip ansible_ssh_user=ubuntu ansible_ssh_private_key_file=$SSH_KEY_PATH
"""
                }
            }
        }

        // ✅ **New Stage: Generate Ansible Inventory**
        stage('Generate Ansible Inventory') {
            steps {
                script {
                  def ec2Ip = sh(script: 'terraform output -raw jenkins_public_ip', returnStdout: true).trim()

                    writeFile file: 'inventory.ini', text: """
                    [jenkins]
                    ${ec2Ip} ansible_user=ubuntu ansible_ssh_private_key_file=$SSH_KEY_PATH
                    """
                }
            }
        }

     stage('Install Docker on EC2') {
    steps {
        script {
            sh '''
            sudo cp /root/ansible/playbook.yml $WORKSPACE/  # Copy playbook from /root/ansible

            export ANSIBLE_HOST_KEY_CHECKING=False

            ansible-playbook -i inventory.ini \
                --private-key=$SSH_KEY_PATH \
                playbook.yml
            '''
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
