terraform {
  backend "s3" {
    bucket = "terraform-state-euan11"
    key    = "terraform/prod-autoscaling"
    region = "eu-central-1"
  }
}
