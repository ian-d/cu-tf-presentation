resource "aws_key_pair" "example" {
  key_name   = "isd23-example"
  public_key = "${file("~/.ssh/id_rsa.pub")}"
}

resource "aws_instance" "example" {
  ami                         = "ami-55ef662f"
  instance_type               = "t2.small"
  subnet_id                   = "${var.public_subnet}"
  key_name                    = "${aws_key_pair.example.key_name}"
  associate_public_ip_address = true
  vpc_security_group_ids      = ["${aws_security_group.example.id}"]

  root_block_device {
    volume_type           = "gp2"
    volume_size           = "200"
    delete_on_termination = "true"
  }

  tags {
    "Name"        = "tf_example"
    "Terraform"   = "true"
    "Environment" = "${var.env}"
  }
}

resource "aws_ebs_volume" "example_data" {
  type              = "gp2"
  size              = "50"
  availability_zone = "${aws_instance.example.availability_zone}"

  tags {
    "Name"        = "example_data"
    "Terraform"   = "true"
    "Environment" = "${var.env}"
  }
}

resource "aws_volume_attachment" "example_data" {
  device_name = "/dev/sdb"
  volume_id   = "${aws_ebs_volume.example_data.id}"
  instance_id = "${aws_instance.example.id}"
}
