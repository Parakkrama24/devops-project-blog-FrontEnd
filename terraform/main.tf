provider "aws" {
  region = "us-east-1"  # Replace with your desired region
}

# Create a security group
resource "aws_security_group" "my_security_group" {
  name        = "my-security-group"
  description = "Allow SSH and HTTP traffic"
  
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Allow SSH from anywhere
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Allow HTTP from anywhere
  }

  # Optionally allow HTTPS if needed
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Allow HTTPS from anywhere
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"  # Allow all outbound traffic
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Create the EC2 instance
resource "aws_instance" "my_ec2_instance" {
  ami           = "ami-072e42fd77921edac"  # Replace with an appropriate AMI for your region
  instance_type = "t2.micro"               # Change based on your needs
  key_name      = "my-key-pair"          # Replace with your SSH key name

  security_groups = [aws_security_group.my_security_group.name]  # Reference the security group

  tags = {
    Name = "DevOps-EC2"
  }
}

output "ec2_public_ip" {
  value = aws_instance.my_ec2_instance.public_ip
}
