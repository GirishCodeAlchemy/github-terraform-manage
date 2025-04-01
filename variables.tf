variable "teams" {
  description = "A list of teams to create in GitHub, including users and repositories."
  type = list(object({
    name  = string
    users = list(string)
    repositories = list(object({
      name   = string
      access = string
    }))
  }))
}

variable "github_token" {
  description = "GitHub personal access token with permissions to manage repositories and teams."
  type        = string
}

variable "github_organization" {
  description = "The GitHub organization where repositories and teams will be created."
  type        = string
}
