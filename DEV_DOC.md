# Developer documentation

This document describes the architecture of the project.

## Overview

The infrastructure is composed of three containers:

- nginx
- wordpress
- mariadb

Each container runs a single service and communicates through a Docker network.

## Architecture

Browser
↓
HTTPS (port 443)
↓
Nginx
↓
PHP-FPM (WordPress)
↓
MariaDB

### Nginx

Nginx is the entry point of the application.

Responsibilities:
- handle HTTPS connections
- serve static files
- forward PHP requests to WordPress

### WordPress

The WordPress container runs PHP-FPM.

Responsibilities:
- execute PHP code
- generate dynamic pages
- interact with the database

### MariaDB

MariaDB stores all persistent data.

Examples:
- users
- posts
- comments
- configuration

## Networking

All services are connected through a Docker bridge network created by Docker Compose.

Containers communicate using service names:

- WordPress connects to `mariadb`
- Nginx connects to `wordpress`

## Volumes

Two volumes are used for persistence:

- MariaDB data
- WordPress files

This ensures that data remains available even if containers are recreated.

## Environment variables

Environment variables are stored in a `.env` file and used by Docker Compose to configure services.

Examples:

- database name
- database user
- passwords
- domain name

## Security

HTTPS is enabled using a self-signed SSL certificate generated during container setup.
