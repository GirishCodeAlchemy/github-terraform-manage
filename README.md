# GitHub Teams and Repositories Management with Terraform and Terragrunt

This project provides a structured approach to manage GitHub teams and repositories using Terraform and Terragrunt. It allows you to define teams, their members, and associated repositories through separate configuration files for each team, enabling automated provisioning of resources on GitHub.

## Project Structure

```
terragrunt-terraform-github
├── config
│   ├── Developers.json      # Configuration for the Developers team
│   ├── QA.json              # Configuration for the QA team
│   └── Ops.json             # Configuration for the Ops team
├── modules
│   ├── github-team          # Module to manage GitHub teams
│   │   ├── main.tf          # Terraform configuration for GitHub team
│   │   ├── variables.tf     # Input variables for GitHub team module
│   │   └── outputs.tf       # Outputs for GitHub team module
│   ├── github-repository    # Module to manage GitHub repositories
│   │   ├── main.tf          # Terraform configuration for GitHub repository
│   │   ├── variables.tf     # Input variables for GitHub repository module
│   │   └── outputs.tf       # Outputs for GitHub repository module
├── terragrunt.hcl           # Root Terragrunt configuration
├── main.tf                  # Entry point for Terraform configuration
├── variables.tf             # Input variables for the main configuration
├── outputs.tf               # Outputs summarizing the applied resources
├── README.md                # Project documentation
└── LICENSE                  # License file for the project
```

- **config/**: Contains separate JSON files for each team, defining their users and associated repositories

  - **Developers.json**: JSON file defining the `Developers` team, its users, and associated repositories.
  - **QA.json**: JSON file defining the `QA` team, its users, and associated repositories.
  - **Ops.json**: JSON file defining the `Ops` team, its users, and associated repositories.

- **modules/**: Contains Terraform modules for managing GitHub resources.

  - **github-team/**: Handles the creation of GitHub teams and their memberships.

    - **main.tf**: Defines resources for team creation and user membership.
    - **variables.tf**: Input variables for the team module.
    - **outputs.tf**: Outputs for the team module.

  - **github-repository/**: Manages the creation of GitHub repositories and team access.

    - **main.tf**: Defines resources for repository creation and team access.
    - **variables.tf**: Input variables for the repository module.
    - **outputs.tf**: Outputs for the repository module.

- **terragrunt.hcl**: Configuration file for Terragrunt, dynamically loading team configurations and managing module dependencies.

- **main.tf**: Entry point for Terraform configuration, invoking the modules for teams and repositories.

- **variables.tf**: Defines input variables for the main configuration.

- **outputs.tf**: Outputs summarizing the results of the applied resources, including team and repository details.

## Setup Instructions

1. **Prerequisites**: Ensure you have Terraform and Terragrunt installed on your machine.

2. **Configuration**:

   - Add or update team-specific JSON files in the `config/` folder (e.g., `Developers.json`, `QA.json`, etc.).
   - Each JSON file should define the team name, its users, and associated repositories with access levels.

3. **Initialize Terragrunt**: Navigate to the project directory and run:

   ```bash
   terragrunt init

   ```

4. **Apply Configuration**: To create the teams and repositories, run:
   ```
   terragrunt apply
   ```

## Usage

- Modify the JSON files in the config/ folder to add or update teams, users, and repositories.
- Use the Terragrunt commands to manage the lifecycle of your GitHub resources:
  - terragrunt plan: Preview the changes to be applied.
  - terragrunt apply: Apply the changes to create or update resources.
  - terragrunt destroy: Destroy the created resources.

## Outputs

After applying the configuration, the following outputs will be available:

- Team Information:
  - Team names, IDs, and the list of users in each team.
- Repository Information:
  - Repository names, visibility (e.g., private or public), and the teams with their access levels.

Example output:

```json
{
  "team_info": {
    "Developers": {
      "id": "12345678",
      "name": "Developers",
      "users": ["user1@example.com", "user2@example.com"]
    },
    "QA": {
      "id": "87654321",
      "name": "QA",
      "users": ["user3@example.com", "user4@example.com"]
    }
  },
  "repository_info": {
    "dev-repo": {
      "name": "dev-repo",
      "visibility": "private",
      "team_access": [
        {
          "team_name": "Developers",
          "repository": "dev-repo",
          "access": "admin"
        }
      ]
    },
    "qa-repo": {
      "name": "qa-repo",
      "visibility": "private",
      "team_access": [
        {
          "team_name": "QA",
          "repository": "qa-repo",
          "access": "read"
        }
      ]
    }
  }
}
```

## Contributing

Contributions are welcome! Please submit a pull request or open an issue for any enhancements or bug fixes.

## License

This project is licensed under the MIT License. See the LICENSE file for details.
