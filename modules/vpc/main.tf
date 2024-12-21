resource "aws_vpc" "vpc" {
    cidr_block = var.vpc_cidr
    tags = {
      "Name" = var.vpc_name
    }
}

resource "aws_subnet" "public_subnets" {
    count = length(var.public_subnets_cidr)
    vpc_id = aws_vpc.vpc.id
    cidr_block = element(var.public_subnets_cidr, count.index)
    map_public_ip_on_launch = true
    availability_zone = data.aws_availability_zones.available_zones.names[count.index % length(data.aws_availability_zones.available_zones.names)]
    tags = {
      "Name" = "${var.vpc_name}-Public-subnet-${count.index + 1}" 
    }
}

resource "aws_subnet" "private_subnets" {
    count = length(var.private_subnets_cidr)
    vpc_id = aws_vpc.vpc.id
    cidr_block = element(var.private_subnets_cidr, count.index)
    availability_zone = data.aws_availability_zones.available_zones.names[count.index % length(data.aws_availability_zones.available_zones.names)]
    tags = {
      "Name" = "${var.vpc_name}-Private-subnet-${count.index + 1}" 
    }
}

resource "aws_internet_gateway" "vpc_ig" {
    vpc_id = aws_vpc.vpc.id
    tags = {
      "Name" = "${var.vpc_name}-vpc-ig"
    }
}

resource "aws_eip" "nat_eip" {
    domain = "vpc"
    depends_on = [ aws_internet_gateway.vpc_ig ]
    tags = {
      Name = "${var.vpc_name}-nat-eip"
    }
}

resource "aws_nat_gateway" "vpc_nat" {
    allocation_id = aws_eip.nat_eip.id
    subnet_id = aws_subnet.public_subnets[0].id
    depends_on = [ aws_internet_gateway.vpc_ig ]
    tags = {
      "Name" = "${var.vpc_name}-vpc-nat"
    }
}

resource "aws_route_table" "public_route_table" {
    vpc_id = aws_vpc.vpc.id
    route {
      cidr_block = "0.0.0.0/0"
      gateway_id = aws_internet_gateway.vpc_ig.id
    }
    tags = {
      "Name" = "${var.vpc_name}-public-subnet-rt"
    }
}

resource "aws_route_table_association" "public_rt_association" {
    count = length(var.public_subnets_cidr)
    subnet_id = aws_subnet.public_subnets[count.index].id
    route_table_id = aws_route_table.public_route_table.id
}

resource "aws_route_table" "private_route_table" {
    vpc_id = aws_vpc.vpc.id
    route {
      cidr_block = "0.0.0.0/0"
      nat_gateway_id = aws_nat_gateway.vpc_nat.id
    }
    tags = {
      "Name" = "${var.vpc_name}-private-subnet-rt"
    }
}


resource "aws_route_table_association" "private_rt_association" {
    count = length(var.private_subnets_cidr)
    subnet_id = aws_subnet.private_subnets[count.index].id
    route_table_id = aws_route_table.private_route_table.id
}
