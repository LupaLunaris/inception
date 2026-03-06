# Inception

This project is about building a small infrastructure using Docker.  
The goal is to run a WordPress website with a MariaDB database and an Nginx web server, all inside separate containers.

Each service runs in its own container and they communicate through a Docker network.

## Services

The project contains three main services:

- **Nginx**  
  Handles HTTPS connections and acts as a reverse proxy.

- **WordPress (PHP-FPM)**  
  Runs the WordPress application.

- **MariaDB**  
  Stores all the website data (users, posts, comments, settings).

## Project structure

inception/
│
├── Makefile
├── README.md
├── USER_DOC.md
├── DEV_DOC.md
│
└── srcs/
├── docker-compose.yml
├── .env
└── requirements/
├── nginx
├── mariadb
└── wordpress


## How it works

When the stack is started:

1. Docker builds the images for each service.
2. The containers are created and connected through a Docker network.
3. MariaDB initializes the database.
4. WordPress connects to MariaDB and installs itself automatically.
5. Nginx exposes the website through HTTPS.

The website can then be accessed through the configured domain.

## Notes

- Each service uses its own Dockerfile.
- Data is persisted using Docker volumes.
- Environment variables are stored in a `.env` file.
