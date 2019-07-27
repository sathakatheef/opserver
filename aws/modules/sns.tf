#######SNS Topics#######
resource "aws_sns_topic" "this" {
  name = "${var.environment == "prod" ? prod-${var.product}-${Var.purpose}-sns : ${var.environment}-${var.product}-${var.purpose}-sns"
}
