locals {
  name_prefix = "${var.project_name}-${var.environment}"
  common_tags = {
    Project     = var.project_name
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}

resource "aws_vpc" "my_vpc" {
  cidr_block       = var.vpc_cidr

  tags = merge(local.common_tags, {
  Name = "${local.name_prefix}-vpc"
})
}

resource "aws_subnet" "my_subnet" {
  vpc_id     = aws_vpc.my_vpc.id
  availability_zone = data.aws_availability_zones.available.names[0]
  cidr_block = var.subnet_cidr
  map_public_ip_on_launch = true

  tags = merge(local.common_tags, {
  Name = "${local.name_prefix}-subnet"
})
}

resource "aws_internet_gateway" "my_gw" {
  vpc_id = aws_vpc.my_vpc.id

  tags = merge(local.common_tags, {
  Name = "${local.name_prefix}-gw"
})
}

resource "aws_route_table" "my_rt" {
  vpc_id = aws_vpc.my_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.my_gw.id
  }

tags = merge(local.common_tags, {
  Name = "${local.name_prefix}-rt"
})

}

resource "aws_route_table_association" "my_rta" {
  subnet_id      = aws_subnet.my_subnet.id
  route_table_id = aws_route_table.my_rt.id
}

resource "aws_security_group" "my_sg" {
  name        = "my_sg"
  vpc_id      = aws_vpc.my_vpc.id

 tags = merge(local.common_tags, {
  Name = "${local.name_prefix}-sg"
})
}

resource "aws_vpc_security_group_ingress_rule" "allow_ports" {
  for_each = toset([for port in var.allowed_ports : tostring(port)])
  security_group_id = aws_security_group.my_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = tonumber(each.value)
  ip_protocol       = "tcp"
  to_port           = tonumber(each.value)
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic" {

  security_group_id = aws_security_group.my_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"

}

resource "aws_instance" "my_ec2" {

  lifecycle {
  create_before_destroy = true
}
  ami           =  data.aws_ami.amazon_linux.id
  instance_type =  var.environment == "prod" ? "t3.small" : "t3.micro"
  subnet_id = aws_subnet.my_subnet.id
  vpc_security_group_ids = [ aws_security_group.my_sg.id ]
  associate_public_ip_address = true

  tags = merge(local.common_tags, {
  Name = "${local.name_prefix}-server"
})
  
}

resource "aws_s3_bucket" "my_s3" {
  bucket = "yasheroic-terraweek-test-bucket"

 tags = merge(local.common_tags, {
  Name = "${local.name_prefix}-bucket"
})

  depends_on = [ aws_instance.my_ec2 ]
}

data "aws_ami" "amazon_linux" {
  most_recent      = true
  owners           = ["amazon"]

 filter {
  name = "name"
  values = [ "amzn2-ami-hvm-*-x86_64-gp*" ]
   
 }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }


}

data "aws_availability_zones" "available" {}