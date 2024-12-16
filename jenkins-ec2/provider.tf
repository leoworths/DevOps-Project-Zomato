terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
<<<<<<< HEAD
      version = "5.80.0"
=======
      version = "5.76.0"
>>>>>>> 94acad9399cc0c677fc1ebf25f98e1b1973d2123
    }
  }
}
data "aws_availability_zones" "azs" {}

provider "aws" {
  region = "us-east-1"
  # Configuration options
}
