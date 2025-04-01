locals {
  team_files = fileset("${path_relative_to_include()}/config", "*.json")
  teams      = [for file in local.team_files : jsondecode(file("${path_relative_to_include()}/config/${file}"))]
}

dependency "github_team" {
  config_path = "${path_relative_to_include()}/modules/github-team"
}

dependency "github_repository" {
  config_path = "${path_relative_to_include()}/modules/github-repository"
}

inputs = {
  teams = local.teams
  github_token       = "your_personal_access_token"
  github_organization = "your_organization_name"
}