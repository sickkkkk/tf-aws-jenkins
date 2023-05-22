terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }

  backend "s3" {
    bucket         = "tf-state-dev-eu-central-1"
    key            = "jenkins/terraform.tfstate"
    region         = "eu-central-1"
    dynamodb_table = "tf-state-lock-table-compute-dev-eu-central-1"
  }

}

# Configure the AWS Provider
provider "aws" {
}