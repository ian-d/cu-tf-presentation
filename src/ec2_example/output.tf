output "example_public_ip" {
  value = "${aws_instance.example.public_ip}"
}

output "example_private_ip" {
  value = "${aws_instance.example.private_ip}"
}
