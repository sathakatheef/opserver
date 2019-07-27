## TF AWS provider minimum required version
provider "aws" {
  version    = "~> 1.37"
  region = "${var.region["Sydney"]}"
  shared_credentials_file = "$AWS_HOME/credentials"
  profile = "${var.accounts["${var.account_name}"]}"
}

## List of AWS regions
variable "region" {
  type        = "map"
  description = "Setting up regions"

  default =
        {
    Singapore     = "ap-southeast-1"
    Sydney        = "ap-southeast-2"
    Tokyo         = "ap-northeast-1"
    Seoul         = "ap-northeast-2"
    Mumbai        = "ap-south-1"
    Paulo         = "sa-east-1"
    London        = "eu-west-2"
    Frankfurt     = "eu-central-1"
    Ireland       = "eu-west-1"
    Canada        = "ca-central-1"
    Oregon        = "us-west-2"
    N.Californaia = "us-west-1"
    Ohio          = "us-east-2"
    N.Virginia    = "us-east-1"
  }
}
