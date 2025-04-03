variable "github_organization" {
  description = "The GitHub organization where repositories and teams will be created."
  type        = string
}

variable "github_token" {
  description = "The GitHub token used for authentication."
  type        = string
  sensitive   = true
}

variable "teams" {
  description = "A list of teams to create in GitHub, including users with different roles and repositories"
  type = list(object({
    name = string
    users = object({
      members    = list(string)
      maintainer = list(string)
    })
    repositories = list(object({
      name   = string
      access = string
    }))
  }))

  # Validation for repository access levels
  validation {
    condition = alltrue([
      for team in var.teams : alltrue([
        for repo in team.repositories : contains(["admin", "write", "read"], repo.access)
      ])
    ])
    error_message = "Repository access must be one of: admin, write, or read."
  }

  # Validation for team members
  validation {
    condition = alltrue([
      for team in var.teams : (
        length(team.users.members) + length(team.users.maintainer) > 0
      )
    ])
    error_message = "Each team must have at least one member (either regular member or maintainer)."
  }

  # Validation for repositories
  validation {
    condition = alltrue([
      for team in var.teams : (
        length(team.repositories) > 0
      )
    ])
    error_message = "Each team must have at least one repository assigned."
  }
}