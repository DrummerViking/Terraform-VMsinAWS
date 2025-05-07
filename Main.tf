# Configure the AWS Provider
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
  required_version = ">= 0.14.9"
}

provider "aws" {
  region = "us-east-1" # US AWS region
}

# Create a VPC
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
  enable_dns_support = true
  enable_dns_hostnames = true
  tags = {
    Name = "main-vpc"
  }
}

# Create a Subnet
resource "aws_subnet" "main" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "us-east-1a" # Replace with your desired availability zone
  tags = {
    Name = "main-subnet"
  }
}

# Create an Internet Gateway
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "main-igw"
  }
}

# Create a Route Table
resource "aws_route_table" "main" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }
  # route {
  #   cidr_block = "10.0.0.0/16"
  #   gateway_id = "local"
  # }

  tags = {
    Name = "main-route-table"
  }
}

# Associate the Route Table with the Subnet
resource "aws_route_table_association" "main" {
  subnet_id      = aws_subnet.main.id
  route_table_id = aws_route_table.main.id
}

# Create a Security Group
resource "aws_security_group" "allow_rdp" {
  name        = "allow_rdp"
  description = "Allow inbound rdp traffic"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 3389
    to_port     = 3389
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["10.0.0.0/16"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_rdp"
  }
}

# Create a Key Pair
resource "aws_key_pair" "deployer" {
  key_name   = "deployer-key"
  public_key = file("${path.module}/.ssh/${var.pubkey_filename}") # Replace with your public key path
}

# Create an EC2 Instance for the Domain Controller
resource "aws_instance" "domain_controller" {
  ami           = "ami-0c765d44cf1f25d26" # Replace with a Windows Server 2022 AMI
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.main.id
  vpc_security_group_ids = [aws_security_group.allow_rdp.id]
  key_name = aws_key_pair.deployer.key_name # Associate the key pair

  associate_public_ip_address = true
  # user_data = <<-EOF
  # <powershell>
  #   # Install AD DS role
  #   Install-WindowsFeature -Name AD-Domain-Services -IncludeManagementTools

  #   # Promote the server to a domain controller
  #   Install-ADDSForest -DomainName "${var.domain_name}" -DomainNetbiosName "${var.netbios_domainname}" -SafeModeAdministratorPassword (ConvertTo-SecureString "${var.safemode_administrator_password}" -AsPlainText -Force) -InstallDNS
  # </powershell>
  
  # can add user_data in Powershell template format to perform post-deployment settings.
  user_data = templatefile("${path.module}/Scripts/PromoteDC.ps1.tmpl", {
    dc_name = var.dc_name
    domain_name = var.domain_name
    netbios_domainname = var.netbios_domainname
    admin_name = var.admin_name
    admin_pass = var.admin_pass
    member_servers = join(",", var.machines_name_list)
  })

  tags = {
    Name = "domain-controller"
    Role = "Domain Controller"
  }
}

# Create EC2 instances dynamically for member_server and exchange_server
resource "aws_instance" "dynamic_instances" {
  for_each = toset(var.machines_name_list)

  ami           = "ami-0c765d44cf1f25d26" # Replace with a Windows Server 2022 AMI
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.main.id
  vpc_security_group_ids = [aws_security_group.allow_rdp.id]
  key_name = aws_key_pair.deployer.key_name # Associate the key pair
  associate_public_ip_address = true
  depends_on = [aws_instance.domain_controller]

  user_data = templatefile("${path.module}/Scripts/DomainJoin.ps1.tmpl", {
    server_name = each.key
    domain_name = var.domain_name
    admin_name  = var.admin_name
    admin_pass  = var.admin_pass
    dns_server  = aws_instance.domain_controller.private_ip
  })

  tags = {
    Name = each.key
    Role = "Dynamic Server"
  }
}