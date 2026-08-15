variable "aws_region" {
  description = "AWS region for all infrastructure resources"
  type        = string
  default     = "us-east-2"
}

variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
  default     = "tech-challenge-eks"
}

variable "ecr_repository_name" {
  description = "Name of the AWS ECR repository"
  type        = string
  default     = "hello-world-app"
}