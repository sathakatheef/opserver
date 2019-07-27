resource "tls_private_key" "this" {
  algorithm   = "RSA"
  ecdsa_curve = "4096"
}

resource "aws_key_pair" "this" {
  key_name   = "amazon-prod"
  public_key = "${tls_private_key.this.public_key_pem}"
}
