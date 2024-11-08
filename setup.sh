#!/bin/bash

# Start the Docker container in detached mode
echo "Starting the Docker container..."
docker-compose up -d

# Confirm the container is running
echo "Checking container status..."
docker-compose ps

# Run the setup script to create and seed the database
echo "Running database setup script..."
docker cp ./OwlCreate.sql mssqlserver:/OwlCreate.sql
docker exec -it mssqlserver /opt/mssql-tools/bin/sqlcmd \
   -S localhost -U SA -P 'Password123456789' \
   -d master -i /OwlCreate.sql

echo "final préparation"
cd TestProject2
dotnet test

echo "All tasks completed successfully."

echo "you can now run dotnet test to test the application"
