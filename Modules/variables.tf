#This is a variable to change how all the resources using it are tagged. When you use the variable, if you use a capital N in name it will be the name of the resource and a lower case n will make it a tag
variable "default_tags" {
  type = map(string)
  default = {
    "name" = "kendal"
  }
  description = "Default naming scheme with your_name"
}

#Variable to name an instance
variable "instance_name" {
  type = map(string)
  default = {
    "name" = "kendal-morpheus-instance"
  }
  description = "variable to name an instance"
}

#Variable to name the Security Group
variable "sg_name" {
  type = map(string)
  default = {
    "name" = "kendal-morpheus-sg"
  }
  description = "variable to name the security group"
}

#Variable to change the AMI you are using in ec2
variable "ami" {
  type        = string
  description = "AMI ID for the EC2 instance"
  default     = "ami-0f409bae3775dc8e5"

  validation {
    condition     = length(var.ami) > 4 && substr(var.ami, 0, 4) == "ami-"
    error_message = "Please provide a valid value for variable AMI."
  }
}

#Variable to change the processer you are using
variable "type" {
  type        = string
  description = "Instance type for the EC2 instance"
  default     = "t3.xlarge"
  sensitive   = false
}

#Variables for public subnet cidrs
variable "public_subnet_cidrs" {
  type        = list(string)
  description = "Public Subnet CIDR values"
  default     = ["10.0.1.0/28", "10.0.1.16/28"]
}

#Variable to assign to AZ
variable "availability_zones" {
  type        = list(string)
  description = "Availabity zones to use"
  default     = ["us-east-1a", "us-east-1b"]
}
#Variable to change the VPC CIDR
variable "vpc_cidr" {
  type    = string
  default = "10.0.1.0/24"

}

#Variable to change your IP address in SG to allow access for ssh and https
variable "your_ip" {
  type    = list(string)
  default = ["108.90.97.194/32"]
}

#Variable to change root volume block size in ec2
variable "volume_size" {
  type    = number
  default = 25

}

