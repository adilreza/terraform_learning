#Access & secret keys

provider "aws" {
  access_key = "*******"
  secret_key = "rlRRGsa/askfjhasdkf"
  region     = "ap-southeast-1"
}

#EC2 instance details

resource "aws_instance" "instance1" {

  ami = "ami-06d31bae124726404"

  instance_type = "t2.micro"

  tags = {

    Name = "RHEL-8"

  }

}
