provider "aws" {
  profile = "default"
  #region  = "us-west-2"
  region = var.awsRegion
  shared_credentials_file = "/home/ec2-user/.aws/credentials"
}

terraform {
  backend "remote" {
    hostname = "app.terraform.io"
    organization = "DevOps108"

    workspaces {
      name = "vpc-dev"
    }
  }
}

resource "aws_vpc" "this" {
  cidr_block           = var.cidr
  instance_tenancy     = "default"
  enable_dns_hostnames = true
  enable_dns_support   = true
  #enable_classiclink               = var.enable_classiclink
  #enable_classiclink_dns_support   = var.enable_classiclink_dns_support
  #assign_generated_ipv6_cidr_block = var.enable_ipv6

  tags = merge(
    {
      "Name" = format("%s", var.envPrefix)
    },
    # var.tags,
    # var.vpc_tags,
  )
}

resource "aws_internet_gateway" "iGateway" {
  vpc_id = aws_vpc.this.id

  tags = merge(
    {
      "Name" = format("%s", var.envPrefix)
    },
    #var.tags,
    #var.igw_tags,
  )
}

resource "aws_subnet" "lb_subnet_a" {
  vpc_id            = aws_vpc.this.id
  cidr_block        = var.lb_subnet_a_cidr
  availability_zone = "${element(split(",", var.azs), 0)}"
  #availability_zone_id           = 
  map_public_ip_on_launch = true

  tags = merge(
    {
      "Name" = format("%s-lb_subnet_a", var.envPrefix)
    },
    #var.tags,
    # var.public_subnet_tags,
  )
}

resource "aws_subnet" "lb_subnet_b" {
  vpc_id     = aws_vpc.this.id
  cidr_block = var.lb_subnet_b_cidr
  #var.tags,
  availability_zone = "${element(split(",", var.azs), 1)}"
  #availability_zone = var.azs
  #availability_zone_id           = 
  map_public_ip_on_launch = true

  tags = merge(
    {
      "Name" = format("%s-lb_subnet_b", var.envPrefix)
    },
    #var.tags,
    # var.public_subnet_tags,
  )
}

resource "aws_subnet" "web_subnet_a" {
  vpc_id            = aws_vpc.this.id
  cidr_block        = var.web_subnet_a_cidr
  availability_zone = "${element(split(",", var.azs), 0)}"
  #availability_zone_id           = 
  map_public_ip_on_launch = true

  tags = merge(
    {
      "Name" = format("%s-web_subnet_a", var.envPrefix)
    },
    #var.tags,
    # var.public_subnet_tags,
  )
}

resource "aws_subnet" "web_subnet_b" {
  vpc_id            = aws_vpc.this.id
  cidr_block        = var.web_subnet_b_cidr
  availability_zone = "${element(split(",", var.azs), 1)}"
  #availability_zone_id           = 
  map_public_ip_on_launch = true

  tags = merge(
    {
      "Name" = format("%s-web_subnet_b", var.envPrefix)
    },
    #var.tags,
    # var.public_subnet_tags,
  )
}

resource "aws_subnet" "db_subnet_a" {
  vpc_id            = aws_vpc.this.id
  cidr_block        = var.db_subnet_a_cidr
  availability_zone = "${element(split(",", var.azs), 0)}"
  #availability_zone = var.azs
  #availability_zone_id           = 
  map_public_ip_on_launch = false

  tags = merge(
    {
      "Name" = format("%s-db_subnet_a", var.envPrefix)
    },
    #var.tags,
    # var.public_subnet_tags,
  )
}

resource "aws_subnet" "db_subnet_b" {
  vpc_id            = aws_vpc.this.id
  cidr_block        = var.db_subnet_b_cidr
  availability_zone = "${element(split(",", var.azs), 1)}"
  #availability_zone = var.azs
  #availability_zone_id           = 
  map_public_ip_on_launch = false

  tags = merge(
    {
      "Name" = format("%s-db_subnet_b", var.envPrefix)
    },
    #var.tags,
    # var.public_subnet_tags,
  )
}

resource "aws_db_subnet_group" "database" {

  #name        = lower(var.name)
  description = "Database subnet group for ${var.envPrefix}"
  subnet_ids  = ["${aws_subnet.db_subnet_a.id}", "${aws_subnet.db_subnet_b.id}"]

  tags = merge(
    {
      "Name" = format("%s-db_subnet_group", var.envPrefix)
    },
    #var.tags,
    #var.database_subnet_group_tags,
  )
}

resource "aws_route_table" "public" {
  vpc_id = "${aws_vpc.this.id}"
  tags = merge({
    "Name" = format("%s-RTB-Public", var.envPrefix)
  })
}


resource "aws_route" "public_internet_gateway" {

  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.iGateway.id

}

resource "aws_route_table_association" "lb1_pub" {
  subnet_id      = aws_subnet.lb_subnet_a.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "lb2_pub" {
  subnet_id      = aws_subnet.lb_subnet_b.id
  route_table_id = aws_route_table.public.id
}
