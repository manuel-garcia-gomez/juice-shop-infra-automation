terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.3"
    }
  }

  backend "s3" {
    bucket = "infra-tfstate-bucket-2"
    key = "infra/state.tfstate"
    region = "eu-north-1"
  }
}
