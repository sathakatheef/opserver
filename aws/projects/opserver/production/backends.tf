terraform {
  backend "s3" {
    bucket  = "opserver-bucket"
    key     = "opserver-prod.tfstate"
    region  = "ap-southeast-2"
    profile = "teg-test"
  }
}
