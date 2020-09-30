#This Terraform Code Deploys Basic VPC Infra.
provider "aws" {
  access_key = "${var.aws_access-key}"
  secret_key = "${var.aws_secret_key}"
  region     = "${var.aws_region}"
}

resource "aws_vpc" "default" {
  cidr_block           = "${var.vpc_cidr}"
  enable_dns_hostnames = true
  tags = {
    Name  = "${var.vpc_name}"
    Owner = "venky"
  }
}
terraform {
  backend "s3" {
    bucket = "venky-terra"
    encrypt = true
    key    = "terraform/terraform.tfstate"
    dynamodb_table = "terraform-state-lock-dynamo"
    region = "us-east-1"
  }
}

resource "aws_internet_gateway" "default" {
  vpc_id = "${aws_vpc.default.id}"
  tags = {
    Name = "${aws_vpc.default.tags.Name}-IGW"
  }
}

resource "aws_subnet" "subnet1-public" {
  vpc_id            = "${aws_vpc.default.id}"
  cidr_block        = "${var.public_subnet1_cidr}"
  availability_zone = "us-east-1a"

  tags = {
    Name = "${var.public_subnet1_name}"
  }
}

resource "aws_subnet" "subnet2-public" {
  vpc_id            = "${aws_vpc.default.id}"
  cidr_block        = "${var.public_subnet2_cidr}"
  availability_zone = "us-east-1b"

  tags = {
    Name = "${var.public_subnet2_name}"
  }
}

resource "aws_subnet" "subnet3-public" {
  vpc_id            = "${aws_vpc.default.id}"
  cidr_block        = "${var.public_subnet3_cidr}"
  availability_zone = "us-east-1c"

  tags = {
    Name = "${var.public_subnet3_name}"
  }

}


resource "aws_route_table" "terraform-public" {
  vpc_id = "${aws_vpc.default.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.default.id}"
  }

  tags = {
    Name = "${var.Main_Routing_Table}"
  }
}

resource "aws_route_table_association" "terraform-public" {
  subnet_id      = "${aws_subnet.subnet1-public.id}"
  route_table_id = "${aws_route_table.terraform-public.id}"
}

resource "aws_security_group" "allow_all" {
  name        = "allow_all"
  description = "Allow all inbound traffic"
  vpc_id      = "${aws_vpc.default.id}"

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}



 data "aws_ami" "my_ami" {
      most_recent      = true
     
      owners           = ["196229560714"]
      }

data "aws_vpc" "testvpc" {

id = "vpc-00fcf06ed333ec9c8"
  
}
resource "aws_subnet" "subnet-2" {
vpc_id = "${data.aws_vpc.testvpc.id}"
  cidr_block = "10.0.2.0/24"
  availability_zone = "us-east-1a"

}


# output "Ec2instance" {
#      value = "${aws_instance.mytest-server-1.id}"
#  }
#  output "aws_vpc" {
#      value = "${aws_vpc.default.id}"
#  }
#  output "Ec2instance-1" {
#      value = "${aws_instance.mytest-server-1.tags.Name}"
#  }


# #!/bin/bash
# # echo "Listing the files in the repo."
# # ls -al
# echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++"
# echo "Running Packer Now...!!"
# packer build -var=aws_access_key=AAAAAAAAAAAAAAAAAA -var=aws_secret_key=BBBBBBBBBBBBB packer.json
#packer validate --var-file creds.json packer.json
#packer build --var-file creds.json packer.json
#packer.exe build --var-file creds.json -var=aws_access_key=AAAAAAAAAAAAAAAAAA -var=aws_secret_key=BBBBBBBBBBBBB packer.json
# echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++"
# echo "Running Terraform Now...!!"
# terraform init
# terraform apply --var-file terraform.tfvars -var="aws_access_key=AAAAAAAAAAAAAAAAAA" -var="aws_secret_key=BBBBBBBBBBBBB" --auto-approve
#https://discuss.devopscube.com/t/how-to-get-the-ami-id-after-a-packer-build/36
