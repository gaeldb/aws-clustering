########################################
# Define 3 ubuntu instances
########################################

resource "aws_instance" "instance-front-a" {
  ami                      = "ami-0ad37dbbe571ce2a1"
  instance_type            = "t2.micro"
  key_name                 = "${var.ssh_key_name}"
  availability_zone        = "${var.region}a"
  subnet_id                = "${aws_subnet.front-a.id}"
  vpc_security_group_ids   = [ "${aws_security_group.sg_front_service.id}", "${aws_security_group.sg_admin.id}" ]
  associate_public_ip_address = true
  tags                     = {
    Name                   = "web1-${var.platform}-${var.customer}"
    Customer               = "${var.customer}"
    Platform               = "${var.platform}"
  }
}

resource "aws_instance" "instance-front-b" {
  ami                      = "ami-0ad37dbbe571ce2a1"
  instance_type            = "t2.micro"
  key_name                 = "${var.ssh_key_name}"
  availability_zone        = "${var.region}b"
  subnet_id                = "${aws_subnet.front-b.id}"
  vpc_security_group_ids   = [ "${aws_security_group.sg_front_service.id}", "${aws_security_group.sg_admin.id}" ]
  associate_public_ip_address = true
  tags                     = {
    Name                   = "web2-${var.platform}-${var.customer}"
    Customer               = "${var.customer}"
    Platform               = "${var.platform}"
  }
}

resource "aws_instance" "instance-front-c" {
  ami                      = "ami-0ad37dbbe571ce2a1"
  instance_type            = "t2.micro"
  key_name                 = "${var.ssh_key_name}"
  availability_zone        = "${var.region}c"
  subnet_id                = "${aws_subnet.front-c.id}"
  vpc_security_group_ids   = [ "${aws_security_group.sg_front_service.id}", "${aws_security_group.sg_admin.id}" ]
  associate_public_ip_address = true
  tags                     = {
    Name                   = "web3-${var.platform}-${var.customer}"
    Customer               = "${var.customer}"
    Platform               = "${var.platform}"
  }
}

########################################
# Define loadbalancer
########################################

resource "aws_elb" "loadbalancer-to-publicweb" {
  name = "elb-${var.customer}-aws-demo-${var.platform}-web"
  listener {
    lb_port = 80
    lb_protocol = "http"
    instance_port = 80
    instance_protocol = "http"
  }
  subnets = ["${aws_subnet.front-a.id}","${aws_subnet.front-b.id}","${aws_subnet.front-c.id}"]
  security_groups = ["${aws_security_group.sg_public.id}"]
  health_check {
    healthy_threshold = 2
    unhealthy_threshold = 2
    timeout = 3
    target = "TCP:80"
    interval = 30
  }
  instances = [ "${aws_instance.instance-front-c.id}", "${aws_instance.instance-front-b.id}", "${aws_instance.instance-front-a.id}" ]
}