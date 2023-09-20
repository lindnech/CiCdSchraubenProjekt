 #SICHERHEITSGRUPPEN Für LoadBalancer???

#Security Group für SSH-Zugriff erstellen
resource "aws_security_group" "sg-öffentlich-cicd" {
  vpc_id = aws_vpc.vpc-cicd.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1" #gesamter datenverkehr
    cidr_blocks = ["0.0.0.0/0"]
  }
  #Benötigte Protokolle für eine EC2 Instanz mit Web-Server:
  ingress {
    from_port   = 22 #SSH
    to_port     = 22
    protocol    = "tcp" #gesamter datenverkehr
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 80 #HTTP
    to_port     = 80
    protocol    = "tcp" #gesamter datenverkehr
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 443 #HTTPS
    to_port     = 443
    protocol    = "tcp" #gesamter datenverkehr
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "sg-öffentlich-cicd"
  }
}


############################

#Security Group private erstellen
resource "aws_security_group" "sg-private-cicd" {
  vpc_id = aws_vpc.vpc-cicd.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1" #gesamter datenverkehr
    cidr_blocks = ["0.0.0.0/0"]
  }
  #Benötigte Protokolle für eine EC2 Instanz:

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["10.0.3.0/24"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["10.0.4.0/24"]
  }
  ingress {
    from_port   = 22 #SSH
    to_port     = 22
    protocol    = "tcp" #gesamter datenverkehr
    cidr_blocks = ["0.0.0.0/0"]
  }

ingress {
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  tags = {
    Name = "sg-private-cicd"
  }
}
######################################

#Security Group Alb

resource "aws_security_group" "alb-sg-cicd" {
  name   = "alb_sg"
  vpc_id = aws_vpc.vpc-cicd.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

