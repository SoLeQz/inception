*This project has been created as part of the 42 curriculum by [nicleena](https://github.com/soleqz).*

## Description

Inception is a system administration project that involves setting up a small
infrastructure using Docker and docker-compose. The goal is to deploy a
WordPress site served by NGINX with TLS, backed by a MariaDB database,
all running in isolated containers on a Virtual Machine.

## Project Description

This project uses Docker to containerize three services:
- **NGINX**: the only entry point, handles HTTPS with TLS1.2/1.3
- **WordPress + php-fpm**: serves the WordPress application
- **MariaDB**: stores the WordPress database

Each service runs in its own container built from a custom Dockerfile based on Debian Bullseye. No pre-built images from DockerHub are used. Data is persisted via two named Docker volumes stored in `/home/nicleena/data/` on the host.

### Design choices

**Virtual Machines vs Docker**: VMs emulate full hardware with a dedicated
kernel. Docker shares the host kernel and isolates only the process/filesystem
layer — much lighter, but containers are not VMs.

**Secrets vs Environment Variables**: Env vars are visible via `docker inspect`.
Docker secrets mount sensitive values as in-memory files (`/run/secrets/`),
never exposed to the environment.

**Docker Network vs Host Network**: Host network removes isolation (the
container shares the host's interfaces). Bridge network (used here) creates
a private virtual network between containers only.

**Docker Volumes vs Bind Mounts**: Bind mounts expose host paths directly.
Named volumes are managed by Docker, portable, and safer for persistent data.

## Instructions

### Requirements
- Docker & docker-compose installed
- Add `127.0.0.1 nicleena.42.fr` to your `/etc/hosts`

### Setup
\`\`\`bash
cp srcs/.env.example srcs/.env   # fill in your credentials
make
\`\`\`

Then visit: https://nicleena.42.fr

### Commands

| Command | Effect |
|---|---|
| `make` | Build and start everything |
| `make down` | Stop containers |
| `make clean` | Remove containers and volumes |
| `make fclean` | Full clean including data |
| `make re` | Full rebuild |

## Resources

- [Docker documentation](https://docs.docker.com)
- [NGINX docs](https://nginx.org/en/docs/)
- [WordPress CLI](https://wp-cli.org/)
- [MariaDB docs](https://mariadb.com/kb/en/)
- [PID 1 and Docker best practices](https://www.docker.com/blog/keep-nodejs-rockin-in-docker/)

