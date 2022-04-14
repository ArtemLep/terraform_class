terraform {
  backend "s3"{
    bucket = "terraform-backend-artem"
    key = "terraform/tfstate.tf"
    region = "us-east-1"
  }
}