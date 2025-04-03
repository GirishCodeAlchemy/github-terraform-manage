data "github_repository" "check_repos" {
  for_each = toset(distinct(flatten([
    for team in var.teams : [
      for repository in team.repositories : repository.name
    ]
  ])))

  name = each.key

  lifecycle {
    postcondition {
      condition     = self.id != null
      error_message = "Repository '${each.key}' does not exist in the organization."
    }
  }
}