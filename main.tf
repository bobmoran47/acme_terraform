data "aws_ami" "app_ami" {
  2   most_recent = true
  3 
  4   filter {
  5     name   = "name"
  6     values = ["bitnami-tomcat-*-x86_64-hvm-ebs-nami"]
  7   }
  8 
  9   filter {
 10     name   = "virtualization-type"
 11     values = ["hvm"]
 12   }
 13 
 14   owners = ["979382823631"] # Bitnami
 15 }
 16 
 17 resource "aws_instance" "web" {
 18   ami           = data.aws_ami.app_ami.id
 19   instance_type = var.instance_type
 20 
 21   tags = {
 22     Name = "ACME Company"
 23   }
 24 }
