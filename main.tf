provider "aws" {
    region = "us-east-2"
    // if not specified here then we have to set it via ennvironment variable or run aws configure
    # access_key = "AKIAZOLLOARNLWP2MXOK"
    # secret_key = "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"
}


resource "aws_vpc" "development-env-vpc" {
    cidr_block = var.cidr_blocks[0].cidr_block
    tags = {
        Name = var.cidr_blocks[0].name
    }
}

variable "cidr_blocks" {
    description = "cidr blocks and name tags for vpc and subnet"
    type = list(object({
        cidr_block = string,
        name = string
    }))
}

variable avail_zone{
    // this variable is declared using EXPORT TF_VAR_avail_var=us-east-2a on BASH
    // this is a custom environment variable
}

resource "aws_subnet" "dev-subnet-1" {
    vpc_id = aws_vpc.development-env-vpc.id 
    cidr_block = var.cidr_blocks[1].cidr_block
    availability_zone = var.avail_zone
    tags = {
        Name = var.cidr_blocks[1].name
    }
}

output "dev-vpc-id" {
    value = aws_vpc.development-env-vpc.id
}

output "dev-subnet-id" {
    value = aws_subnet.dev-subnet-1.id
}