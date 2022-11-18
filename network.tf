 resource "aws_vpc" "production" {
  cidr_block = "10.0.0.0/16"
  enable_dns_hostnames  = true
  tags = {
    Name = "Production VPC"
  }
}

resource "aws_default_security_group" "production" {
  vpc_id = aws_vpc.production.id

  ingress {
    protocol  = "-1"
    from_port = 0
    to_port   = 0
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_internet_gateway" "production" {
  vpc_id = aws_vpc.production.id
  tags = {
    Name = "Production Gateway"
  }
}

resource "aws_default_route_table" "production" {
  default_route_table_id = aws_vpc.production.default_route_table_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.production.id
  }

  tags = {
    Name = "Production route table"
  }
}

resource "aws_subnet" "machines" {
  vpc_id                  = aws_vpc.production.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true

  depends_on = [aws_internet_gateway.production]

  tags = {
    Name = "Machines subnet"
  }
}
