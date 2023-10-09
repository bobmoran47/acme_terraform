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

data "aws_vpc" "default" {
  default = true
}

resource "aws_instance" "acme" {
  ami                    = data.aws_ami.app_ami.id
  instance_type          = var.instance_type
  
  vpc_security_group_ids = [module.acme_sg.security_group_id]

  tags = {
    Name = "ACME Terraform"
  }
}

module "acme_sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "5.1.0"
}
vpc_id  = data.aws_vpc.default.id

resource "aws_security_group" "acme" {
  name = "acme"
  tags = {
    Terraform = "true"
  }
  vpc_id = data.aws_vpc.default.id
}

  name    = "acme"
  ingress_rules = ["https-443-tcp","http-80-tcp"]
  ingress_cidr_blocks = ["0.0.0.0/0"]

  egress_rules = ["all-all"]
  egress_cidr_blocks = ["0.0.0.0/0"]
}




resource "aws_security_group_rule" "acme_https_in" {
  type        = "ingress"
  from_port   = 443
  to_port     = 443
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = aws_security_group.acme.id
}


resource "aws_security_group_rule" "acme_everything_out" {
  type        = "egress"
  from_port   = 0
  to_port     = 0
  protocol    = "-1"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = aws_security_group.acme.id
}
