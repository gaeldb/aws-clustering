########################################
# Global VPC
########################################

resource "aws_vpc" "vpcglobal" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "vpc_${var.customer}_${var.project}_${var.platform}"
    Customer = "${var.customer}"
    Platform = "${var.platform}"
  }
}

########################################
# Front subnets - PUBLIC ZONE
########################################

resource "aws_subnet" "front-a" {
  vpc_id = "${aws_vpc.vpcglobal.id}"
  cidr_block = "10.0.0.0/24"
  availability_zone = "${var.region}a"
  map_public_ip_on_launch = true
  tags = {
    Name = "subnet_${var.customer}_${var.project}_${var.platform}_front_a"
    Customer = "${var.customer}"
    Platform = "${var.platform}"
   }
}

resource "aws_subnet" "front-b" {
  vpc_id = "${aws_vpc.vpcglobal.id}"
  cidr_block = "10.0.1.0/24"
  availability_zone = "${var.region}b"
  map_public_ip_on_launch = true
  tags = {
    Name = "subnet_${var.customer}_${var.project}_${var.platform}_front_b"
    Customer = "${var.customer}"
    Platform = "${var.platform}"
  }
}

resource "aws_subnet" "front-c" {
  vpc_id = "${aws_vpc.vpcglobal.id}"
  cidr_block = "10.0.2.0/24"
  availability_zone = "${var.region}c"
  map_public_ip_on_launch = true
  tags = {
    Name = "subnet_${var.customer}_${var.project}_${var.platform}_front_c"
    Customer = "${var.customer}"
    Platform = "${var.platform}"
  }
}

########################################
# Back subnets - PRIVATE ZONE
########################################

resource "aws_subnet" "back-a" {
  vpc_id = "${aws_vpc.vpcglobal.id}"
  cidr_block = "10.0.10.0/24"
  availability_zone = "${var.region}a"
  tags = {
    Name = "subnet_${var.customer}_${var.project}_${var.platform}_back_a"
    Customer = "${var.customer}"
    Platform = "${var.platform}"
 }
}

resource "aws_subnet" "back-b" {
  vpc_id = "${aws_vpc.vpcglobal.id}"
  cidr_block = "10.0.11.0/24"
  availability_zone = "${var.region}b"
  tags = {
    Name = "subnet_${var.customer}_${var.project}_${var.platform}_back_b"
    Customer = "${var.customer}"
    Platform = "${var.platform}"
 }
}

resource "aws_subnet" "back-c" {
  vpc_id = "${aws_vpc.vpcglobal.id}"
  cidr_block = "10.0.12.0/24"
  availability_zone = "${var.region}c"
  tags = {
    Name = "subnet_${var.customer}_${var.project}_${var.platform}_back_c"
    Customer = "${var.customer}"
    Platform = "${var.platform}"
 }
}


########################################
# Routing
########################################

# GW to internet
resource "aws_internet_gateway" "gw-external" {
  vpc_id = "${aws_vpc.vpcglobal.id}"
  tags = {
    Name = "gw-external"
    Customer = "${var.customer}"
    Platform = "${var.platform}"
  }
}

# Route to internet GW
resource "aws_route_table" "route-gw-external" {
  vpc_id = "${aws_vpc.vpcglobal.id}"
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.gw-external.id}"
  }
}

# Associate front subnets and gw-external via route-gw-external
resource "aws_route_table_association" "front-a" {
  subnet_id = "${aws_subnet.front-a.id}"
  route_table_id = "${aws_route_table.route-gw-external.id}"
}

resource "aws_route_table_association" "front-b" {
 subnet_id = "${aws_subnet.front-b.id}"
 route_table_id = "${aws_route_table.route-gw-external.id}"
}

resource "aws_route_table_association" "front-c" {
 subnet_id = "${aws_subnet.front-c.id}"
 route_table_id = "${aws_route_table.route-gw-external.id}"
}