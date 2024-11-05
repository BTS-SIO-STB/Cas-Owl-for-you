# TestProject2 with MSSQL in GitHub Codespaces

## Overview
This project demonstrates how to use a SQL Server instance (MSSQL) running in Docker in GitHub Codespaces, and how to run tests for a .NET project. It includes Docker configuration for running SQL Server, instructions for installing the necessary VS Code extensions, and steps to run your .NET tests.

## Prerequisites

- **GitHub Codespaces** for development.
- **Docker** (pre-installed in Codespaces).
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

3. Run the following command to start the MSSQL container:

   ```bash
   docker-compose up -d
   ```
    This command will run the SQL Server container in detached mode.
    The container will be available on localhost:9595 (or Codespace's public IP if accessed externally).

    To confirm the SQL Server is running, you can run:

    ```bash
    docker ps
    ```
    You should see the mssql-server container running.

3. Install the Necessary VS Code Extensions

In GitHub Codespaces, the required extensions should be installed automatically if they are specified in .devcontainer/devcontainer.json. However, if they are not, you can manually install them:

- Go to the Extensions view in VS Code (on the left side).

- Search for "ms-mssql.mssql" and install the extension. This will allow you to connect to the MSSQL server.
- Alternatively, Codespaces might suggest installing the extension automatically when you open the SQL Server files.

4. Set Up the SQL Database and Seed Data

- Open the SQL Server extension from the left sidebar in VS Code.

- Click New Connection and enter the following connection string:

```text
Server=localhost,9595;User Id=SA;Password=Password123456789;TrustServerCertificate=True;
```

Open the setup.sql file (or create a new one) that contains your database schema and seed data. Here's an example:

```sql
    -- Create a new database
    CREATE DATABASE TestDB;

    -- Switch to the new database
    USE TestDB;

    -- Create a simple table
    CREATE TABLE Users (
        Id INT PRIMARY KEY IDENTITY(1,1),
        Name NVARCHAR(100),
        Email NVARCHAR(100)
    );

    -- Insert some test data
    INSERT INTO Users (Name, Email)
    VALUES
    ('John Doe', 'johndoe@example.com'),
    ('Jane Smith', 'janesmith@example.com');

    -- Verify the data
    SELECT * FROM Users;
```


Right-click the setup.sql file and select Run Query to create and seed the database.

5. Configure and Run the .NET Tests

Now that your database is running and seeded, you can run the .NET tests.

- Open the Terminal in GitHub Codespaces.

- Navigate to your test project folder:

```bash
cd TestProject2
```

Run the tests using the following command:

```bash
dotnet test
```

    The test results will be displayed in the terminal.

6. Stopping Docker

When you're done working with the MSSQL container, you can stop it with:

```bash
docker-compose down
```

This will stop and remove the container and also deleted all data from db.
