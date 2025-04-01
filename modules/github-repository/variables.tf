variable "teams" {
  description = "A map of team configurations, where each key is the team name and the value contains repositories."
  type = map(object({
    name = string
    repositories = list(object({
      name   = string
      access = string
    }))
  }))
}

variable "repositories" {
  description = "A map of repositories to be created."
  type = map(object({
    name   = string
    access = string
  }))
}
