# Create a VPC
resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc_cidr # You can adjust the CIDR block as needed
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    "Name" = "${var.default_tags.name}-vpc"
  }
}

# Create an internet gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    "Name" = "${var.default_tags.name}-igw"
  }
}

# Create two public subnets
resource "aws_subnet" "public_subnets" {
  count                   = length(var.public_subnet_cidrs)
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = element(var.public_subnet_cidrs, count.index)
  availability_zone       = element(var.availability_zones, count.index)
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.default_tags.name}-Public Subnet ${count.index + 1}"
  }
}

# Create a route table
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    "Name" = "${var.default_tags.name}-rt"
  }
}

# Associate both public subnets with the same route table
resource "aws_route_table_association" "public_subnets_rtassociation" {
  count          = length(var.public_subnet_cidrs)
  subnet_id      = aws_subnet.public_subnets[count.index].id
  route_table_id = aws_route_table.public_rt.id
}

# Create a route to the internet gateway
resource "aws_route" "igw_route" {
  route_table_id         = aws_route_table.public_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

# Create a security group
resource "aws_security_group" "sg" {
  name_prefix = var.sg_name.name
  vpc_id      = aws_vpc.vpc.id

  # Define your security group rules here, e.g., for SSH and HTTP
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.your_ip # Adjust this to your needs
  }
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = var.your_ip # Adjust this to your needs
  }
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Adjust this to your needs
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    "Name" = "${var.default_tags.name}-sg"
  }
}

# You can add more rules as necessary

# Create an EC2 instance
resource "aws_instance" "instance" {
  ami           = var.ami                         # Specify your desired AMI ID
  instance_type = var.type                        # Specify your desired instance type
  subnet_id     = aws_subnet.public_subnets[0].id # Choose one of the public subnets
  key_name      = "metsilabs_us-east-1_nvirginia" # Specify your key pair name
  root_block_device {
    volume_size = var.volume_size
  }

  vpc_security_group_ids = [aws_security_group.sg.id]

  user_data = <<-EOF
  #!/bin/bash 
  sudo -i
  yum update -y
  wget https://downloads.morpheusdata.com/files/morpheus-appliance-6.0.6-1.amzn2.x86_64.rpm
  rpm -ivh morpheus-appliance-6.0.6-1.amzn2.x86_64.rpm
  echo "Script Starting" > /home/ec2-user/output.txt
  morpheus-ctl reconfigure
  echo "Script Worked!" >> /home/ec2-user/output.txt
EOF
  tags = {
    Name = "${var.instance_name.name}"
  }
}

