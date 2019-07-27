## List of AWS accounts
variable "accounts" {
  type        = "map"
  description = "Setting up AWS account's profile"

  default =
  {
    teg-account = "teg-account"
  }
}
