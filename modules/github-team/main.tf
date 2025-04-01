resource "github_team" "team" {
  for_each = var.teams

  name        = each.value.name
  description = "Team for ${each.value.name}"
  privacy     = "closed"
}

resource "github_team_membership" "team_membership" {
  for_each = { for team, config in var.teams : team => config.users }

  team_id  = github_team.team[each.key].id
  username = each.value
  role     = "member"
}