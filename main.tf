module "github_team" {
  source = "./modules/github-team"

  teams = { for team in var.teams : team.name => {
    name  = team.name
    users = team.users
  } }
}

module "github_repository" {
  source = "./modules/github-repository"

  teams        = { for team in var.teams : team.name => team }
  repositories = { for team in var.teams : team.name => team.repositories }
}
