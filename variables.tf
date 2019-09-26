variable "customer"     { default = "skalab" }
variable "project"      { default = "aws_demo" }
variable "platform"     { default = "prod" }
variable "region"       { default = "eu-west-3" }
variable "ssh_key_name" { default = "id-rsa-ssh-aws1" }
variable "root_ip"      {
  type = list
  default = ["82.232.251.141/32", "82.229.85.15/32", "62.122.227.242/32" ]
}