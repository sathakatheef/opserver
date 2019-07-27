########1STOP wildcard certificate Import########
resource "aws_acm_certificate" "this" {
  private_key       = "${file(var.private_key)}"
  certificate_body  = "${file(var.certificate_body)}"
  certificate_chain = "${file(var.certificate_chain)}"

  tags = {
    Name              = "opserver-ssl"
    environment       = "${var.environment == "prod" ? "prod" : var.environment}"
    product           = "${var.product}"
    product_component = "wildcard_certificate"
  }
}
