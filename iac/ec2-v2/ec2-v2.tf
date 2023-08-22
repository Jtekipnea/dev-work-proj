resource "aws_instance" "demo-server1" {
    ami = var.my-preferred-ami
    instance_type = var.instance_type
    key_name = "dev-work"
    security_groups = [ "demo-sg" ]

    tags = {
      "Name" = "demo-server"
    }
  
}

resource "aws_security_group" "demo-sg" {
  name        = "demo-sg"
  description = "Allow SSH traffic"

  ingress {
    description      = "SSH access"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = [ "0.0.0.0/0" ]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "ssh-port"
  }
}