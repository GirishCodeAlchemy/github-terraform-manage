variable "teams" {
  description = "A map of team configurations, where each key is the team name and the value contains users."
  type = map(object({
    name  = string
    users = list(string)
  }))
}