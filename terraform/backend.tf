terraform {
  backend "s3" {
    bucket         = "contact-book-tf-state-yuvan"
    key            = "prod/terraform.tfstate"
    region         = "ap-south-1"
    dynamodb_table = "terraform-locks"
    encrypt        = true
  }
}

