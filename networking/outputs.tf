# --- networking/output.tf ---

output "vpc_id" {
  value = aws_vpc.tr_vpc.id
}

output "public_subnets" {
  value = aws_subnet.public_subnet.*.id
}

output "public_sg" {
  value = aws_security_group.sg["public"].id
}




