# --- eks/output.tf ---

output "endpoint" {
  value = aws_eks_cluster.eks.endpoint
}
