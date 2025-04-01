output "team_ids" {
  value = { for team, config in var.teams : team => github_team.team[team].id }
}

output "team_info" {
  description = "Information about the created GitHub teams"
  value = {
    for team, config in var.teams : team => {
      id    = github_team.team[team].id
      name  = github_team.team[team].name
      users = config.users
    }
  }
}
