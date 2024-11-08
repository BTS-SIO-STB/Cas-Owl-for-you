# TestProject2 with MSSQL in GitHub Codespaces

## Overview
This project demonstrates how to use a SQL Server instance (MSSQL) running in Docker in GitHub Codespaces, and how to run tests for a .NET project. It includes Docker configuration for running SQL Server, instructions for installing the necessary VS Code extensions, and steps to run your .NET tests.

## Prerequisites

- **GitHub Codespaces** for development.
- **Docker** (ms-azuretools.vscode-docker extension vs).
- **.NET SDK** (pre-installed in Codespaces).
- **SQL Server (MS SQL) extension** for Visual Studio Code.

## Getting Started

### 1. Open the Project in GitHub Codespaces

1. Go to the GitHub repository.
2. Click on the **"Code"** button and select **"Open with Codespaces"**.
3. Wait for the Codespace to initialize. Once it's up and running, you will be inside the VS Code environment inside GitHub Codespaces.

### 2. Set Up the Docker Container for MSSQL

GitHub Codespaces comes with Docker already set up. You can start the MSSQL server using the provided `docker-compose.yml` file.

#### Step-by-Step:

1. Ensure that the `docker-compose.yml` file is in your project folder (it should be).

2. Open the **Terminal** inside GitHub Codespaces.

3. Run the following command to start:

   ```bash
   bash setup.sh
   ```
