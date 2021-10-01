resource "aws_vpc" "myapp-vpc" {
    cidr_block = var.vpc_cidr_block
    tags = {
        Name = "${var.env_prefix}-voc"
    }
}

module "myapp-subnet" {
    source = "./modules/subnet"
    default_route_table_id =  aws_vpc.myapp-vpc.default_route_table_id
    subnet_cidr_block = var.subnet_cidr_block
    avail_zone = var.avail_zone
    env_prefix = var.env_prefix
    vpc_id = aws_vpc.myapp-vpc.id
}

module "myapp-server" {
    source = "./modules/webserver"
    vpc_id  = aws_vpc.myapp-vpc.id
    env_prefix = var.env_prefix
    ssh_public_key_file_location = var.ssh_public_key_file_location
    ssh_private_key_file_location =  var.ssh_private_key_file_location
    instance_type = var.instance_type
    avail_zone =  var.avail_zone
    image_name = var.image_name
    subnet_id = module.myapp-subnet.subnet.id
    my_ip = var.my_ip

}