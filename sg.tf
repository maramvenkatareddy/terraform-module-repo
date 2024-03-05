resource "aws_security_group" "allow_tls_80" {
  for_each = var.securitygroups
  name        = each.value.name
  description = "Allow TLS inbound traffic and all outbound traffic"
  vpc_id      = aws_vpc.prod-acp-vpc.id

  ingress {
    protocol = each.value.protocol
    from_port = each.value.port
    to_port = each.value.port
    cidr_blocks = each.value.cidr_blocks
  }

  egress {
    protocol = each.value.protocol
    from_port = each.value.port
    to_port = each.value.port
    cidr_blocks = each.value.cidr_blocks
  }

  tags = {
    Name = "allow_tls_80"
  }
}