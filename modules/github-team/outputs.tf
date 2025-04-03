output "team_ids" {
  description = "Map of team names to their corresponding IDs"
  value = {
    for idx, team in github_team.team : team.name => team.id
  }
}

output "team_slugs" {
  description = "Map of team names to their corresponding slugs"
  value = {
    for idx, team in github_team.team : team.name => team.slug
  }
}

output "team_memberships" {
  description = "Details of team memberships"
  value = {
    for team_index, team in var.teams : team.name => {
      members = [
        for user in team.users : user
      ]
    }
  }
}

output "team_repository_access" {
  description = "Repository access configuration for each team"
  value = {
    for team_index, team in var.teams : team.name => {
      repositories = [
        for repo in team.repositories : {
          name       = "${var.github_organization}/${repo.name}"
          permission = repo.access
        }
      ]
    }
  }
}

output "team_urls" {
  description = "URLs for accessing teams in GitHub web interface"
  value = {
    for idx, team in github_team.team : team.name => "https://github.com/orgs/${var.github_organization}/teams/${team.slug}"
  }
}


output "repository_info" {
  description = "Information about the GitHub repositories and their team access"
  value = {
    for repo in distinct(flatten([
      for team in var.teams : [
        for repository in team.repositories : repository.name
      ]
    ])) : repo => {
      name = repo
      team_access = [
        for team_index, team in var.teams : {
          team_name  = team.name
          repository = repo
          access     = try(
            [
              for r in team.repositories : r.access
              if r.name == repo
            ][0],
            null
          )
        }
        if anytrue([
          for r in team.repositories : r.name == repo
        ])
      ]
    }
  }
}

# Additional helpful outputs
output "team_info" {
  description = "Information about the created GitHub teams"
  value = {
    for idx, team in var.teams : team.name => {
      id         = github_team.team[idx].id
      slug       = github_team.team[idx].slug
      members    = team.users.members
      maintainers = team.users.maintainer
      repositories = [
        for repo in team.repositories : {
          name   = repo.name
          access = repo.access
        }
      ]
    }
  }
}
