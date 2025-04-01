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
# Retrieve Existing Security Groups
# -----------------------------
data "aws_security_group" "jenkins_sg" {
  filter {
    name   = "group-name"
    values = ["jenkins-security-group"]
  }
}

data "aws_security_group" "mysql_sg" {
  filter {
    name   = "group-name"
    values = ["mysql-security-group"]
  }
}

# -----------------------------
# Jenkins EC2 Instance
# -----------------------------
resource "aws_instance" "jenkins_server" {
  ami             = "ami-0b0ea68c435eb488d"
  instance_type   = "t2.micro"
  key_name        = "jenkinsKey"
  security_groups = [data.aws_security_group.jenkins_sg.name, data.aws_security_group.mysql_sg.name]

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
# Retrieve Existing RDS Instance
# -----------------------------
data "aws_db_instance" "mysql_db" {
  db_instance_identifier = "jenkins-mysql-db"
}

# -----------------------------
# If RDS does not exist, create it
# -----------------------------
resource "aws_db_instance" "mysql_db" {
  count               = length(data.aws_db_instance.mysql_db.id) > 0 ? 0 : 1
  allocated_storage   = 20
  storage_type        = "gp2"
  engine             = "mysql"
  engine_version      = "8.0.32"
  instance_class      = "db.t3.micro"
  identifier         = "jenkins-mysql-db"
  db_name           = "jenkinsdb"
  username         = "admin"
  password         = "StrongPassword123!"
  publicly_accessible = false
  skip_final_snapshot = true
  vpc_security_group_ids = [data.aws_security_group.mysql_sg.id]

  tags = {
    Name = "Jenkins-MySQL-DB"
  }
}
