data "aws_ami" "app_ami" {
  most_recent = true
  
  filter {
  name   = "name"
  values = ["bitnami-tomcat-*-x86_64-hvm-ebs-nami"]
    }
   
   filter {
     name   = "virtualization-type"
      values = ["hvm"]
   }
 
   owners = ["979382823631"] # Bitnami
 }
  
 resource "aws_instance" "web" {
  # ami           = data.aws_ami.app_ami.id
  # instance_type = var.instance_type
# Creates four identical aws ec2 instances
  count = 4     
  
  # All four instances will have the same ami and instance_type
  ami = lookup(var.ec2_ami,var.region) 
  instance_type = var.instance_type # 
  tags = {
    # The count.index allows you to launch a resource 
    # starting with the distinct index number 0 and corresponding to this instance.
    Name = "web-${count.index}"
  }
}
 
  # tags = {
  #   Name = "ACME Company Terraform Presentation"
  # }
 #}
