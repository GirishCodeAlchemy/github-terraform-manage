variable "github_organization" {
  description = "The GitHub organization where repositories and teams will be created."
  type        = string
}

# Data source to check repositories existence
data "github_repositories" "existing" {
  query = "org:${var.github_organization}"
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

  # # Validation for repository existence
  # validation {
  #   condition = alltrue(flatten([
  #     for team in var.teams : [
  #       for repo in team.repositories : contains(data.github_repositories.existing.names, repo.name)
  #     ]
  #   ]))
  #   error_message = "One or more repositories do not exist in the organization. Please create the repositories first."
  # }

  validation {
    condition = length([
      for repo in distinct(flatten([
        for team in var.teams : [
          for repository in team.repositories : repository.name
        ]
      ])) : repo
      if !contains(data.github_repositories.existing.names, repo)
    ]) == 0
    error_message = join("", [
      "The following repositories do not exist in the organization:\n\t ",
      join(",\n\t ", [
        for repo in distinct(flatten([
          for team in var.teams : [
            for repository in team.repositories : repository.name
          ]
        ])) : repo
        if !contains(data.github_repositories.existing.names, repo)
      ]),
      ".\n Please create these repositories first."
    ])
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