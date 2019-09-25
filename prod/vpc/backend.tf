terraform {
  backend "s3" {
    bucket = "terraform-state-euan11"
    key    = "terraform/prod-vpc"
    region = var.AWS_REGION
  }
}
