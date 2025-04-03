locals {
  global_vars       = read_terragrunt_config("${get_terragrunt_dir()}/global.hcl")
  environment_vars  = read_terragrunt_config("${get_terragrunt_dir()}/env.hcl")

  team_files = fileset("${get_terragrunt_dir()}/config/", "*.json")
  teams      = [for file in local.team_files : jsondecode(file("${get_terragrunt_dir()}/config/${file}"))]
}

inputs = {
  teams = local.teams
  github_token       = local.environment_vars.locals.github_token
  github_organization = local.global_vars.locals.github_organization
}

terraform {
  source = "./modules/github-team"
}
