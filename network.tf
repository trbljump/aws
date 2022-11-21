resource "aws_default_vpc" "default" {
  tags = {
    Name = "Default VPC"
  }
}

data "aws_internet_gateway" "default" {
  filter {
    name = "attachment.vpc-id"
    values = [aws_default_vpc.default.id]
  }
}

resource "aws_security_group" "all_open" {
  vpc_id = aws_default_vpc.default.id
  name = "all-open"

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

resource "aws_default_route_table" "production" {
  default_route_table_id = aws_default_vpc.default.default_route_table_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = data.aws_internet_gateway.default.id
  }

  tags = {
    Name = "Production route table"
  }
}

resource "aws_subnet" "machines" {
  vpc_id                  = aws_default_vpc.default.id
  cidr_block              = "172.31.32.0/20"
  map_public_ip_on_launch = true
  tags = {
    Name = "Machines subnet"
  }
}
