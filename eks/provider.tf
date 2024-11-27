terraform {
    required_version = ">= 1.0.0"
    required_providers {
    aws = {
    source  = "hashicorp/aws"
    version = "5.76.0"
    }
    }
    # backend "s3" {
    #     bucket = "bucket-name"
    #     key = "terraform.tfstate"
    #     region = "us-east-1"
    # }
}
data "aws_availability_zones" "azs" {}

provider "aws" {
    region = "us-east-1"
    # Configuration options
}
