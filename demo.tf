
variable "AWS_ACCESS_KEY" {
  type = string
}

variable "AWS_SECRET_KEY" {
  type = string
}
provider "aws" {
  access_key = var.AWS_ACCESS_KEY
  secret_key = var.AWS_SECRET_KEY
  region     = "us-east-1"
}


# -----------------------------
# Jenkins EC2 Instance
# -----------------------------
resource "aws_instance" "jenkins_server" {
  ami             = "ami-0b0ea68c435eb488d"
  instance_type   = "t2.micro"
  key_name        = "jenkinsKey"
  security_groups = [aws_security_group.jenkins_sg.name, aws_security_group.mysql_sg.name]

  user_data = <<-EOF
  #!/bin/bash
  sudo apt update -y
  sudo apt install -y openjdk-17-jdk
  wget -O - https://pkg.jenkins.io/debian/jenkins.io.key | sudo tee /usr/share/keyrings/jenkins-keyring.asc
  echo "deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] https://pkg.jenkins.io/debian binary/" | sudo tee /etc/apt/sources.list.d/jenkins.list
  sudo apt update -y
  sudo apt install -y jenkins
  sudo systemctl start jenkins
  sudo systemctl enable jenkins
  EOF

  tags = {
    Name = "Jenkins-Server"
  }
}

# -----------------------------
# Jenkins Security Group
# -----------------------------
resource "aws_security_group" "jenkins_sg" {
  name        = "jenkins-security-group"
  description = "Allow SSH and Jenkins traffic"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Change to your IP for security
  }

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Change to your IP if needed
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# -----------------------------
# MySQL Security Group
# -----------------------------
resource "aws_security_group" "mysql_sg" {
  name        = "mysql-security-group"
  description = "Allow MySQL access"

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Change to your IP for security
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# -----------------------------
# MySQL RDS Database
# -----------------------------
resource "aws_db_instance" "mysql_db" {
  allocated_storage    = 20
  storage_type         = "gp2"
  engine               = "mysql"
  engine_version       = "8.0.32"  # Updated to a supported version
  instance_class       = "db.t3.micro"  # Updated to t3.micro
  identifier           = "jenkins-mysql-db"
  db_name              = "jenkinsdb"  # Added db_name
  username             = "admin"
  password             = "StrongPassword123!" # Change this to a secure password
  publicly_accessible  = false
  skip_final_snapshot  = true
  vpc_security_group_ids = [aws_security_group.mysql_sg.id]

  tags = {
    Name = "Jenkins-MySQL-DB"
  }
}

# -----------------------------
# Output Public IP of Jenkins Instance
# -----------------------------
output "jenkins_public_ip" {
  value = aws_instance.jenkins_server.public_ip
  description = "The public IP address of the Jenkins EC2 instance"
}

