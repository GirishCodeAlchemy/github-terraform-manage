terraform {
  required_version = ">= 1.6.2"
  required_providers {
    github = {
      source  = "hashicorp/github"
      version = ">= 6.6.0"
    }
  }
}

provider "github" {
  token = var.github_token
  owner = var.github_organization
}
