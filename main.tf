provider "aws" {
  region = "us-west-2" # Change to your desired region
}


resource "aws_security_group" "allow_http_ssh" {
  name        = "allow_http_ssh"
  description = "Allow HTTP and SSH inbound traffic"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_http_ssh"
  }
}


resource "aws_instance" "web" {
  ami           = "ami-0c55b159cbfafe1f0" # Change to your desired AMI
  instance_type = "t2.micro"
  key_name      = "your-key-pair" # Change to your key pair name

  vpc_security_group_ids = [aws_security_group.allow_http_ssh.id]

  tags = {
    Name = "WebServer"
  }
}


output "instance_public_ip" {
  value = aws_instance.web.public_ip
}
