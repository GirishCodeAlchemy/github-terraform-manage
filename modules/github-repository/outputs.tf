# resource "github_repository" "repositories" {
#   for_each = var.repositories

#   name        = each.key
#   visibility  = each.value.visibility
#   description = each.value.description
#   auto_init   = true
# }

# output "repository_urls" {
#   value = { for repo in github_repository.repositories : repo.name => repo.html_url }
# }
output "repository_names" {
  value = { for repo, config in var.repositories : repo => github_repository.repository[repo].name }
}

output "repository_info" {
  description = "Information about the created GitHub repositories and their team access"
  value = {
    for repo, config in var.repositories : repo => {
      name       = github_repository.repository[repo].name
      visibility = github_repository.repository[repo].visibility
      team_access = [
        for team, team_config in var.teams : {
          team_name  = team_config.name
          repository = repo
          access = lookup(
            [for r in team_config.repositories : r if r.name == repo],
            0,
            null
            ).access != null ? lookup(
            [for r in team_config.repositories : r if r.name == repo],
            0,
            null
          ).access : null
          } if lookup(
          [for r in team_config.repositories : r if r.name == repo],
          0,
          null
        ) != null
      ]
    }
  }
}
