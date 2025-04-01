resource "github_repository" "repository" {
  for_each = var.repositories

  name        = each.value.name
  description = "Repository for ${each.value.name}"
  visibility  = "private"
}

resource "github_team_repository" "team_repository" {
  for_each = { for team, config in var.teams : team => config.repositories }

  team_id    = github_team.team[each.key].id
  repository = each.value.name
  permission = each.value.access
}
