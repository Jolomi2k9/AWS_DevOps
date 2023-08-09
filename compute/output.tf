# --- compute/output.tf ---

output "key_pair" {
  value = aws_key_pair.tr_auth.id
}

output "instance"{
  value = aws_instance.tr_node[*]
  sensitive = true
}
