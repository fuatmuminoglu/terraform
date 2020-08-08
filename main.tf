resource "aws_instance" "Fuats_First_TF_Instance" {
    ami = "ami-02354e95b39ca8dec"
    instance_type = "t2.micro"
    tags = {
      "Name" = "EC2 Instance Terraform"
    }
  
}