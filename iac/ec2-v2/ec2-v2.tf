resource "aws_instance" "demo-server1" {
  ami           = var.my-preferred-ami
  instance_type = var.instance_type
  key_name      = "dev-work"
  //security_groups = [ "demo-sg" ]
  vpc_security_group_ids = [aws_security_group.demo-sg.id]
  subnet_id              = aws_subnet.demo-public-subnet.id
  for_each = toset(["jenkins-master", "jenkins-slave", "ansible"])
   tags = {
     Name = "${each.key}"
   }

}

resource "aws_security_group" "demo-sg" {
  name        = "demo-sg"
  description = "Allow SSH traffic"
  vpc_id      = aws_vpc.demo-vpc.id

  ingress {
    description = "SSH access"
    from_port   = 22
    to_port     = 22
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
    Name = "ssh-port"
  }
}

resource "aws_vpc" "demo-vpc" {
  cidr_block = "10.1.0.0/16"
  tags = {
    Name = "demo-vpc"
  }

}

resource "aws_subnet" "demo-public-subnet" {
  vpc_id                  = aws_vpc.demo-vpc.id
  cidr_block              = "10.1.1.0/24"
  map_public_ip_on_launch = "true"
  availability_zone       = "us-west-1a"
  tags = {
    Name = "demo-pub-subnet-1"
  }

}

resource "aws_subnet" "demo-public-subnet-2" {
  vpc_id                  = aws_vpc.demo-vpc.id
  cidr_block              = "10.1.2.0/24"
  map_public_ip_on_launch = "true"
  availability_zone       = "us-west-1b"
  tags = {
    Name = "demo-pub-subnet-2"
  }

}

resource "aws_internet_gateway" "demo-igw" {
  vpc_id = aws_vpc.demo-vpc.id
  tags = {
    Name = "demo-igw"
  }
}

resource "aws_route_table" "demo-public-rt" {
  vpc_id = aws_vpc.demo-vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.demo-igw.id
  }
}

resource "aws_route_table_association" "demo-rt-association-1" {
  subnet_id      = aws_subnet.demo-public-subnet.id
  route_table_id = aws_route_table.demo-public-rt.id
}

resource "aws_route_table_association" "demo-rt-association-2" {
  subnet_id      = aws_subnet.demo-public-subnet-2.id
  route_table_id = aws_route_table.demo-public-rt.id
}