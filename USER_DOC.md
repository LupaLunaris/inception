# User documentation

This document explains how to start and use the project.

## Requirements

The following tools must be installed on the system:

- Docker
- Docker Compose
- Make

## Launch the project

From the root directory of the repository:
make


This will:

- build the Docker images
- start the containers
- initialize the services

## Access the website

Open a browser and go to:
https://jpaulis.42.fr


You may see a warning about the SSL certificate because it is self-signed.  
This is expected for a local project.

## WordPress login

You can access the WordPress admin panel at:
https://jpaulis.42.fr/wp-admin


Use the credentials defined in the environment variables.

## Stop the project

To stop the containers:
make down

This will stop and remove the containers but keep the volumes.

## Notes

- Data is persisted through Docker volumes.
- Restarting the containers will not remove the database or website data.
