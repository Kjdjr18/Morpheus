terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.16.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
  # profile = "297497969752_workshop"
}
