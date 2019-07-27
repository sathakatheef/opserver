#####SSM Document Creation#########
resource "aws_ssm_document" "this" {
        name  = "ssm_document_to_join_the_domain"
        document_type = "Command"

        content = <<DOC
{
        "schemaVersion": "1.0",
        "description": "Join an instance to a domain",
        "runtimeConfig": {
           "aws:domainJoin": {
               "properties": {
                  "directoryId": "${aws_directory_service_directory.this.id}",
                  "directoryName": "${aws_rout53_zone.this.zone_id}",
                  "dnsIpAddresses": [
                "${element(concat(aws_directory_service_directory.this.dns_ip_addresses,list("")), 0)}",
                "${element(concat(aws_directory_service_directory.this.dns_ip_addresses,list("")), 1)}"
                  ]
               }
           }
        }
}
DOC
}
