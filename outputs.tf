output "team_ids" {
  value = { for team in github_team.teams : team.name => team.id }
}

output "team_info" {
  description = "Information about the created GitHub teams"
  value       = module.github_team.team_info
}

output "repository_info" {
  description = "Information about the created GitHub repositories and their team access"
  value       = module.github_repository.repository_info
}
