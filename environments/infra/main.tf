# Backend ECR 
resource "aws_ecr_repository" "backend" {
  name = "terraform-infra-laboratory-backend" 
  
  image_tag_mutability = "MUTABLE"
  image_scanning_configuration {
    scan_on_push = true
  }
}

# Frontend ECR
resource "aws_ecr_repository" "frontend" {
  name = "terraform-infra-laboratory-frontend"
  
  image_tag_mutability = "MUTABLE"
  image_scanning_configuration {
    scan_on_push = true
  }
}

# S3 bucket
resource "aws_s3_bucket" "storage" {
  bucket = "terraform-infra-laboratory-shlyapik-storage"
}

output "backend_repo_url" {
  value = aws_ecr_repository.backend.repository_url
}

output "frontend_repo_url" {
  value = aws_ecr_repository.frontend.repository_url
}