# Create VPC in us-east-1
resource "aws_vpc" "vpc_master" {
  provider             = aws.region-master
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "master-vpc-jenkins"
  }
}

# Create VPC in us-west-2
resource "aws_vpc" "vpc_worker" {
  provider             = aws.region-worker
  cidr_block           = "192.168.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "worker-vpc-jenkins"
  }
}

# Create IGW in us-east-1
resource "aws_internet_gateway" "igw-us-east-1" {
  provider = aws.region-master
  vpc_id   = aws_vpc.vpc_master.id
}

# Create IGW in us-west-2
resource "aws_internet_gateway" "igw-us-west-2" {
  provider = aws.region-worker
  vpc_id   = aws_vpc.vpc_worker.id
}

# Get all available AZ's in VPC for master region
data "aws_availability_zones" "azs" {
  provider = aws.region-master
  state    = "available"
}

# Create subnet # 1 in us-east-1
resource "aws_subnet" "subnet_1" {
  provider          = aws.region-master
  availability_zone = element(data.aws_availability_zones.azs.names, 0)
  vpc_id            = aws_vpc.vpc_master.id
  cidr_block        = "10.0.1.0/24"
  tags = {
    Name = "master-subnet-1"
  }
}

# Create subnet # 2 in us-east-1
resource "aws_subnet" "subnet_2" {
  provider          = aws.region-master
  availability_zone = element(data.aws_availability_zones.azs.names, 1)
  vpc_id            = aws_vpc.vpc_master.id
  cidr_block        = "10.0.2.0/24"
  tags = {
    Name = "master-subnet-2"
  }
}

# Create subnet # 1 in us-west-2
resource "aws_subnet" "subnet_1_us_west_2" {
  provider   = aws.region-worker
  vpc_id     = aws_vpc.vpc_worker.id
  cidr_block = "192.168.1.0/24"
  tags = {
    Name = "worker-subnet-1"
  }
}

