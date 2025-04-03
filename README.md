# GitHub Teams and Repositories Management with Terraform and Terragrunt

This project provides a structured approach to manage GitHub teams and repositories using Terraform and Terragrunt. It allows you to define teams, their members, and associated repositories through separate configuration files for each team, enabling automated provisioning of resources on GitHub.

## Project Structure

```
github-terraform-manage
├── config
│   ├── Developers.json      # Configuration for the Developers team
│   ├── QA.json              # Configuration for the QA team
│   └── Ops.json             # Configuration for the Ops team
├── modules
│   ├── github-team          # Module to manage GitHub teams and repository
│   │   ├── main.tf          # Team creation and membership resources
│   │   ├── data.tf          # Data sources for team configuration
│   │   ├── variables.tf     # Input variables for GitHub team module
│   │   └── outputs.tf       # Outputs for GitHub team module
├── env.hcl                  # Environment-specific Terragrunt settings
├── global.hcl               # Global Terragrunt configuration
├── terragrunt.hcl           # Root Terragrunt configuration
├── provider.tf              # GitHub provider configuration with authentication settings
├── variables.tf             # Root module input variables for global configuration
└── README.md                # Project documentation and setup instructions
```

- **config/**: Contains separate JSON files for each team, defining their users and associated repositories
  - **Developers.json**: JSON file defining the `Developers` team, its users, and associated repositories.
  - **QA.json**: JSON file defining the `QA` team, its users, and associated repositories.
  - **Ops.json**: JSON file defining the `Ops` team, its users, and associated repositories.

- **modules/**: Contains reusable Terraform modules for managing GitHub resources
  - **github-team/**: Module for managing GitHub teams and their configurations
    - **main.tf**: Defines resources for team creation, user membership, and repository access
    - **data.tf**: Data sources for fetching existing repository and user information
    - **variables.tf**: Input variables for configuring team settings and permissions
    - **outputs.tf**: Output values for team IDs, member lists, and repository access

- **env.hcl**: Environment variables for configuring the github provider.

- **global.hcl**: Global Terragrunt settings shared across all environments

- **terragrunt.hcl**: Configuration file for Terragrunt, dynamically loading team configurations and managing module dependencies.

- **provider.tf**: Configures the GitHub provider with Authentication tokens and Organization settings

- **variables.tf**: Root level variables for:
  - GitHub organization name
  - Default team settings
  - Global permission configurations

## Setup Instructions

1. **Prerequisites**: Ensure you have Terraform and Terragrunt installed on your machine.
  - Terraform >= 1.0
  - GitHub Account with administrative access
  - GitHub Personal Access Token with appropriate permissions

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
    ```json
    {
      "name": "Developers",
      "users": {
        "members": ["user1","user2"],
        "maintainer": ["user3"]
      },
      "repositories": [
        {
          "name": "repository-name",
          "access": "admin|write|read"
        }
      ]
    }
    ```
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