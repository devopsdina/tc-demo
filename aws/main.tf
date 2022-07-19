terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

# Create a VPC
resource "aws_vpc" "app_vpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "app-vpc"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.app_vpc.id

  tags = {
    Name = "vpc_igw"
  }
}

resource "aws_subnet" "public_subnet" {
  vpc_id            = aws_vpc.app_vpc.id
  cidr_block        = "10.0.2.0/24"
  map_public_ip_on_launch = true
  availability_zone = "us-east-1a"

  tags = {
    Name = "public-subnet"
  }
}

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.app_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "public_rt"
  }
}

resource "aws_route_table_association" "public_rt_asso" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_instance" "web" {
  ami             = "ami-0070c5311b7677678" #ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-20220706 
  instance_type   = "t2.micro"
  #key_name        = var.instance_key
  subnet_id       = aws_subnet.public_subnet.id
  security_groups = [aws_security_group.websg.id]

  user_data = <<-EOF
  #!/bin/bash
  echo "*** Installing apache2"
  sudo apt update -y
  sudo apt install apache2 -y
  echo "*** Completed Installing apache2"
  echo "Hello from AWS! Terraform cloud demo!" > index.html
  nohup busybox httpd -f -p 8080 &
  EOF

  tags = {
    Name = "web_instance"
  }

  volume_tags = {
    Name = "web_instance"
  } 
}


# resource "aws_instance" "tc-demo" {
#   ami = "ami-0070c5311b7677678" #ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-20220706
#   instance_type = "t2.micro"
#   vpc_security_group_ids = [ aws_security_group.websg.id ]
#   user_data = <<-EOF
#                 #!/bin/bash
#                 echo "Hello from AWS! Terraform cloud demo!" > index.html
#                 nohup busybox httpd -f -p 8080 &
#                 EOF
#     tags = {
#       Name = "WEB-demo"
#     }
# }
resource "aws_security_group" "websg" {
  name = "web-sg01"
  vpc_id = aws_vpc.app_vpc.id
  ingress {
    protocol = "tcp"
    from_port = 8080
    to_port = 8080
    cidr_blocks = [ "0.0.0.0/0" ]
  }
}
output "instance_ips" {
  value = aws_instance.web.public_ip
}
