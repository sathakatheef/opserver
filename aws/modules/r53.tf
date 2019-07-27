resource "aws_route53_zone" "this" {
  name    = "prod.tk"
  comment = "${var.environment} Forward Zone - Public"
}
