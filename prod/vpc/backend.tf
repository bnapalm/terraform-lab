terraform {
  backend "s3" {
    bucket = "terraform-state-euan11"
    key    = "terraform/prod-vpc"
    region = "eu-central-1"
  }
}
