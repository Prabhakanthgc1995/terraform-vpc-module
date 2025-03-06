resource "aws_vpc" "main" {
  cidr_block = var.cidr_block
  enable_dns_support = true
  enable_dns_hostnames = true

  tags = {
    Name = "VPC-${local.workspace_name}"
  }
}

resource "aws_security_group" "allow_ssh_http" {
  name        = "allow_ssh_http-${local.workspace_name}"
  description = "Allow SSH and HTTP traffic"
  vpc_id      = aws_vpc.main.id

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
    Name = "SG-${local.workspace_name}"
  }
}

resource "aws_instance" "example" {
  ami           = var.ami_id
  instance_type = var.instance_type
  security_group_ids = [aws_security_group.allow_ssh_http.id]
  subnet_id     = aws_subnet.main.id

  tags = {
    Name        = "Instance-${local.workspace_name}"
    Environment = local.workspace_name
  }
}
