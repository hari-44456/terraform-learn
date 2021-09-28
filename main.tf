provider "aws" {
    region = "us-east-2"
    // if not specified here then we have to set it via ennvironment variable or run aws configure
    # access_key = ""
    # secret_key = ""
}

variable vpc_cidr_block {}
variable subnet_cidr_block {}
variable env_prefix {}
variable avail_zone {
    // this variable is declared using EXPORT TF_VAR_avail_var=us-east-2a on BASH
    // this is a custom environment variable
}
variable my_ip {}

resource "aws_vpc" "myapp-vpc" {
    cidr_block = var.vpc_cidr_block
    tags = {
        Name = "${var.env_prefix}-voc"
    }
}

resource "aws_subnet" "myapp-subnet-1" {
    vpc_id = aws_vpc.myapp-vpc.id 
    cidr_block = var.subnet_cidr_block
    availability_zone = var.avail_zone
    tags = {
        Name = "${var.env_prefix}-subnet-1"
    }
}

resource "aws_internet_gateway" "myapp-igw" {
    vpc_id = aws_vpc.myapp-vpc.id

    tags = {
        Name = "${var.env_prefix}-igw"
    }
}

resource "aws_default_route_table" "main-rtb" {
    default_route_table_id = aws_vpc.myapp-vpc.default_route_table_id

     route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.myapp-igw.id
    }

    tags = {
        Name = "${var.env_prefix}-main-rtb"
    }
}

resource aws_security_group "myapp-sg" {
    name = "myapp-sg"
    vpc_id = aws_vpc.myapp-vpc.id

    // ingress for incoming traffic
    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_block = [var.my_ip]
    }

    ingress {
        from_port = 8080
        to_port = 8080
        protocol = "tcp"
        cidr_block = ["0.0.0.0/0"]
    }

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_block = ["0.0.0.0/0"]
        prefix_list_ids = [""]
    }
}