## create a VPC

resource "aws_vpc" "prod-acp-vpc" {
  cidr_block = var.vpc
  tags = {
    Name = "prod-acp-vpc"
  }
}

# create a 2 public subnets in a VPC

resource "aws_subnet" "pub-subnets" {
  count = length(var.public-subnets)
  vpc_id     = aws_vpc.prod-acp-vpc.id
  cidr_block = var.public-subnets[count.index]
  availability_zone = var.az[count.index]

  tags = {
    Name = var.public-subnet-names[count.index]
  }
}

# create a 2 subnets for app application

resource "aws_subnet" "pvt-subnets-app" {
  count = length(var.private-subnets-app)
  vpc_id     = aws_vpc.prod-acp-vpc.id
  cidr_block = var.private-subnets-app[count.index]
  availability_zone = var.az[count.index]

  tags = {
    Name = var.pvt-subnets-app[count.index]
  }
}

# create a 2 subnets for db

resource "aws_subnet" "pvt-subnets-db" {
  count = length(var.private-subnets-db)
  vpc_id     = aws_vpc.prod-acp-vpc.id
  cidr_block = var.private-subnets-db[count.index]
  availability_zone = var.az[count.index]

  tags = {
    Name = var.pvt-subnet-db-names[count.index]
  }
}

# craete igw
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.prod-acp-vpc.id

  tags = {
    Name = "main"
  }
}

resource "aws_eip" "nat" {
    domain = "vpc"
}

resource "aws_nat_gateway" "na-pub-1" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.pub-subnets[0].id

  tags = {
    Name = "gw NAT"
  }
  depends_on = [aws_internet_gateway.gw]
}

# create a public route table

resource "aws_route_table" "rt" {
  vpc_id = aws_vpc.prod-acp-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }
  tags = {
    Name = var.pub-rt-name
  }
  depends_on = [ aws_nat_gateway.na-pub-1 ]
}

resource "aws_route_table_association" "pub-rt" {
  count = length(var.public-subnets)
  subnet_id      = aws_subnet.pub-subnets[count.index].id
  route_table_id = aws_route_table.rt.id
}

# create a private route table

resource "aws_route_table" "pvt-rt-app" {
  vpc_id = "${aws_vpc.prod-acp-vpc.id}"
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_nat_gateway.na-pub-1.id}"
  }
  tags = {
    Name = var.pvt-rt-name
  }


}

resource "aws_route_table_association" "pvt-rt-app" {
  count = length(var.private-subnets-app)
  subnet_id      = aws_subnet.pvt-subnets-db[count.index].id
  route_table_id = aws_route_table.pvt-rt-app.id
}
resource "aws_route_table_association" "pvt-rt-db" {
  count = length(var.private-subnets-db)
  subnet_id      = aws_subnet.pvt-subnets-app[count.index].id
  route_table_id = aws_route_table.pvt-rt-app.id
}

