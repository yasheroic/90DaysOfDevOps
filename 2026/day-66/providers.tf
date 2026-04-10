terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.28"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.0" # Specify your desired version
    }
  }
  backend "s3" {

    bucket         = "yasheroic-tf-remote-s3-bucket"
    dynamodb_table = "yasheroic-tf-remote-dynamodb-table"
    key            = "terraform-eks/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
  }
}

provider "aws" {
  region = var.region
}

# 2. Configure the k8s provider authentication
provider "kubernetes" {
  config_path    = "~/.kube/config"
  config_context = "my-context" # Optional: specify a context
}