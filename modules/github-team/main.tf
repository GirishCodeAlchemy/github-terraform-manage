resource "github_team" "team" {
  count = length(var.teams)

  name        = var.teams[count.index].name
  description = "Team for ${var.teams[count.index].name}"
  privacy     = "closed"
}

# Handle regular members
resource "github_team_membership" "team_members" {
  for_each = {
    for membership in flatten([
      for team_index, team in var.teams : [
        for user in team.users.members : {
          team_index = team_index
          user      = user
          role      = "member"
        }
      ]
    ]) : "${membership.team_index}-${membership.user}" => membership
  }

  team_id  = github_team.team[each.value.team_index].id
  username = each.value.user
  role     = each.value.role
}

# Handle maintainers
resource "github_team_membership" "team_maintainers" {
  for_each = {
    for membership in flatten([
      for team_index, team in var.teams : [
        for user in team.users.maintainer : {
          team_index = team_index
          user      = user
          role      = "maintainer"
        }
      ]
    ]) : "${membership.team_index}-${membership.user}" => membership
  }

  team_id  = github_team.team[each.value.team_index].id
  username = each.value.user
  role     = each.value.role
}

resource "github_team_repository" "team_repository" {
  for_each = {
    for repo in flatten([
      for team_index, team in var.teams : [
        for repository in team.repositories : {
          team_index = team_index
          repo_name = repository.name
          access    = repository.access
        }
      ]
    ]) : "${repo.team_index}-${repo.repo_name}" => repo
  }

  team_id    = github_team.team[each.value.team_index].id
  repository = each.value.repo_name
  permission = lookup({
    "read"  = "pull",
    "write" = "push",
    "admin" = "admin"
  }, each.value.access, "pull")

  depends_on = [data.github_repository.check_repos]
}
