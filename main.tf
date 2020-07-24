data "aws_availability_zones" "available" {}

# VPC
resource "aws_vpc" "vpc" {
  cidr_block = "10.1.0.0/16"
}


resource "aws_instance" "myFirstInstance" {
  ami = "ami-0b69ea66ff7391e80"
  instance_type = "t2.micro"
  tags {
    Name = "EC2_Instance_Terraform"
  vpc_security_group_ids = ["${aws_security_group.public_sg.id}"]
  subnet_id              = "${aws_subnet.public1.id}"
  }
}

resource "aws_security_group" "public_sg" {
  name        = "sg_public"
  description = "Used for public and private instances for load balancer access"
  vpc_id      = "${aws_vpc.vpc.id}"

  #SSH

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${var.localip}"]
  }

  #Outbound internet access

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_subnet" "public1" {
  vpc_id                  = "${aws_vpc.vpc.id}"
  cidr_block              = "${var.cidrs["public1"]}"
  map_public_ip_on_launch = true
  availability_zone       = "${data.aws_availability_zones.available.names[0]}"

  tags {
    Name = "public1"
  }
}
