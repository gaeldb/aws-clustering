########################################
# Public SG
########################################

resource "aws_security_group" "sg_public" {
  name          = "sg_${var.customer}_${var.project}_${var.platform}_public"
  description   = "Allow HTTP inbound traffic"
  vpc_id        = "${aws_vpc.vpcglobal.id}"
  tags = {
    Name        = "sg_${var.customer}_${var.project}_${var.platform}_public"
    Customer    = "${var.customer}"
    Platform    = "${var.platform}"
  }
  # From user-agent
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group_rule" "extra_rule" {
  security_group_id        = "${aws_security_group.sg_public.id}"
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
  type                     = "egress"
  source_security_group_id = "${aws_security_group.sg_front_service.id}"
}

########################################
# Front SG
########################################

resource "aws_security_group" "sg_front_service" {
  name          = "sg_${var.customer}_${var.project}-${var.platform}_front_service"
  description   = "Allow TCP inside SG"
  vpc_id        = "${aws_vpc.vpcglobal.id}"
  tags          = {
    Name        = "sg_${var.customer}_${var.project}-${var.platform}_front_service"
    Customer    = "${var.customer}"
    Platform    = "${var.platform}"
 }
 # From ELB
 ingress {
   from_port = 80
   to_port = 80
   protocol = "tcp"
   security_groups = [ "${aws_security_group.sg_public.id}" ]
  }
  ingress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    self        = "true"
  }
  ingress {
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    self        = "true"
  }

  egress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

 # besoin de rajouter le egress vers pgsql ??
}

########################################
# Admin SG
########################################

resource "aws_security_group" "sg_admin" {
 name           = "sg_${var.customer}_${var.project}-${var.platform}_admin"
 description    = "Allow SSH and ICMP"
 vpc_id         = "${aws_vpc.vpcglobal.id}"

 tags           = {
   Name         = "sg_${var.customer}_${var.project}-${var.platform}_admin"
   Customer     = "${var.customer}"
   Platform     = "${var.platform}"
 }
 ingress {
   from_port    = 22
   to_port      = 22
   protocol     = "tcp"
   cidr_blocks  = "${var.root_ip}"
 }
 ingress {
   from_port    = -1
   to_port      = -1
   protocol     = "icmp"
   cidr_blocks  = "${var.root_ip}"
 }
}

########################################
# Private area SG
########################################

resource "aws_security_group" "allow_private" {
  name          = "sg_${var.customer}_${var.project}-${var.platform}_private"
  description   = "Allow"
  vpc_id        = "${aws_vpc.vpcglobal.id}"

  tags          = {
    Name        = "sg_${var.customer}_${var.project}-${var.platform}_private"
    Customer    = "${var.customer}"
    Platform    = "${var.platform}"
  }

  ingress {
   from_port = 5432
   to_port = 5432
   protocol = "tcp"
   security_groups = [
     "${aws_security_group.sg_front_service.id}"
   ]
  }
}