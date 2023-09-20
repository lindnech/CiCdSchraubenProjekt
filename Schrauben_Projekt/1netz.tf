provider "aws" {
  region = "eu-central-1"
  profile = "build_benutzer"  # hier kommt der iam build benutzer von aws 
}

# VPC erstellen
resource "aws_vpc" "vpc-cicd" {
  cidr_block = "10.0.0.0/16"
  tags = {
    name = "vpc-cicd"
  }
}

# Internet Gateway erstellen
resource "aws_internet_gateway" "igw-cicd" {
  vpc_id = aws_vpc.vpc-cicd.id
  tags = {
    name = "igw-cicd"
  }
}

# Öffentliche Subnetze erstellen
resource "aws_subnet" "subnetz1-oeffentlich-cicd" {
  vpc_id                  = aws_vpc.vpc-cicd.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "eu-central-1a"
  map_public_ip_on_launch = true
  tags = {
    name = "subnetz1-oeffentlich-cicd"
  }
}

resource "aws_subnet" "subnetz2-oeffentlich-cicd" {
  vpc_id                  = aws_vpc.vpc-cicd.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = "eu-central-1b"
  map_public_ip_on_launch = true
  tags = {
    name = "subnetz2-oeffentlich-cicd"
  }
}

# Private Subnetze erstellen
resource "aws_subnet" "subnetz1-private-cicd" {
  vpc_id                  = aws_vpc.vpc-cicd.id
  cidr_block              = "10.0.3.0/24"
  availability_zone       = "eu-central-1a"
  map_public_ip_on_launch = true
  tags = {
    name = "subnetz1-private-cicd"
  }
}

resource "aws_subnet" "subnetz2-private-cicd" {
  vpc_id                  = aws_vpc.vpc-cicd.id
  cidr_block              = "10.0.4.0/24"
  availability_zone       = "eu-central-1b"
  map_public_ip_on_launch = true
  tags = {
    name = "subnetz2-private-cicd"
  }
}

# Öffentliche Routing-Tabelle erstellen
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.vpc-cicd.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw-cicd.id
  }
  tags = {
    name = "public"
  }
}

# Private Routing-Tabelle erstellen
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.vpc-cicd.id
  tags = {
    name = "private"
  }
}

# Verknüpfung der öffentlichen Routing-Tabelle mit den öffentlichen Subnetzen
resource "aws_route_table_association" "public1" {
  subnet_id      = aws_subnet.subnetz1-oeffentlich-cicd.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public2" {
  subnet_id      = aws_subnet.subnetz2-oeffentlich-cicd.id
  route_table_id = aws_route_table.public.id
}

# Verknüpfung der privaten Routing-Tabelle mit den privaten Subnetzen
resource "aws_route_table_association" "private1" {
  subnet_id      = aws_subnet.subnetz1-private-cicd.id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "private2" {
  subnet_id      = aws_subnet.subnetz2-private-cicd.id
  route_table_id = aws_route_table.private.id
}
