# GitHub Self-Hosted Agents on Azure

This repository contains Terraform code to deploy GitHub self-hosted runners on Microsoft Azure using Azure Container App Jobs (ACA Jobs). The runners are configured to connect to a specified GitHub organization using a GitHub App for authentication. The deployment is designed to be scalable and cost-effective, leveraging Azure's serverless container capabilities.

## Features

- **GitHub App Integration**: Uses a GitHub App for secure authentication and management of self-hosted runners.
- **Azure Container App Jobs**: Deploys runners as ACA Jobs, allowing for on-demand execution and scaling.
- **Terraform Infrastructure as Code**: All resources are defined using Terraform for easy deployment and management.
- **Configurable**: Easily customize the deployment using variable files for different environments or organizations.
- **CI/CD Integration**: Includes GitHub Actions workflows for automated deployment and management of the infrastructure.
- **Cost Efficiency**: Runners are only active when needed, reducing costs associated with idle resources.

## Prerequisites

- An Azure account with sufficient permissions to create resources.
- A GitHub organization where the self-hosted runners will be registered.
- A GitHub App created in the organization with the necessary permissions and a private key.
- Terraform installed on your local machine or CI/CD environment.

## Getting Started

1. **Clone the Repository**:

   ```bash
   git clone https://github.com/PerfectThymeTech/github-agent.git
   cd github-agent
   ```

2. **Configure Variables**:

    - Update the `config/PerfectThymeTech/vars.tfvars` file with your GitHub organization name, GitHub App ID, and other necessary configurations.

3. **Set Up GitHub Secrets**:

    - In your GitHub repository, add the following secrets:
      - `CLIENT_ID`: The Client ID of your GitHub App.
      - `CLIENT_SECRET`: The Client Secret of your GitHub App.
      - `APP_PRIVATE_KEY`: The private key of your GitHub App in PEM format.

4. **Deploy Infrastructure**:

    - Use the provided GitHub Actions workflows to deploy the infrastructure. The workflows will use the configured variables and secrets to create the necessary Azure resources.

5. **Monitor and Manage Runners**:

    - Once deployed, monitor the runners in your GitHub organization settings. You can manage their lifecycle through the Azure portal or via Terraform.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Contributing

Contributions are welcome! Please open an issue or submit a pull request for any improvements or bug fixes.
