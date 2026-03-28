resource "aws_s3_bucket" "bucket_1" {
  bucket = "yasheroic-test-bucket-1"
}

resource "aws_instance" "ec2" {

    ami = "ami-0ec10929233384c7f"
    instance_type = "t3.micro"
    
    tags = {
        Name = "TerraWeek-modified"
    }
        
}