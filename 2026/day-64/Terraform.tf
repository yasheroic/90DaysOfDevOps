terraform {
  backend  "s3" {
    
  bucket = "yasheroic-tf-remote-s3-bucket"
  dynamodb_table = "yasheroic-tf-remote-dynamodb-table"
  key = "terraform-aws-infra/terraform.tfstate"
  region = "us-east-1"
  encrypt        = true
  }
  
  }

  
