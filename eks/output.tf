# --- eks/output.tf ---

output "endpoints" {
  value = aws_eks_cluster.eks[*].endpoint
}

