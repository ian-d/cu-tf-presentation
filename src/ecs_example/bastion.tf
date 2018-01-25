data "aws_ami" "aws-linux" {
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn-ami-*-x86_64-gp2"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "owner-alias"
    values = ["amazon"]
  }
}

resource "aws_instance" "bastion" {
  ami                    = "${data.aws_ami.aws-linux.id}"
  source_dest_check      = false
  instance_type          = "t2.micro"
  subnet_id              = "${module.vpc.public_subnets[0]}"
  key_name               = "${var.key_name}"
  vpc_security_group_ids = ["${aws_security_group.bastion.id}"]

  tags {
    Name        = "bastion"
    Environment = "${var.env}"
    Terraform   = true
  }
}

resource "aws_security_group" "bastion" {
  name        = "bastion"
  description = "Allows all SSH traffic"
  vpc_id      = "${module.vpc.vpc_id}"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
