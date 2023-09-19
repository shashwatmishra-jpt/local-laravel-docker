# Docker for Laravel on Local

Docker Setup for Laravel applications for ***local development***.

> ***WARNING:*** This setup is not suitable for production.

### Services Included:

- **PHP-FPM**
- **NGINX** (server)
- **TRAEFIK** (reverse proxy)
- **SUPERVISOR** (process monitor)
- **MySQL** (database)
- **Redis** (key value database)
- **Memcached** (caching)
- **Elasticsearch** (search driver for laravel scout)
- **Mailhog** (email testing)
- **Minio** (S3 on Local)

## Steps to setup

### Initial Setup

1. Clone this repository.
2. Create a `backend` and `frontend` folder inside the `workspace` directory.
3. Copy this project's example.env as .env & update as required.
4. Clone the backend (laravel) app in your `backend` folder and frontend app in your `frontend` folder.
    - Example: clone `backend` using ssh
    ```sh
    git clone git@github.com:organization/backend-repo.git ./workspace/backend
    ```
    - Example: clone `frontend` using ssh
    ```sh
    git clone git@github.com:organization/frontend-repo.git ./workspace/frontend
    ```
5. Edit the backend & frontend `.env` files according to your needs.
6. Run the docker up command with build & detached flag:
  ```sh
  docker compose up -d --build --remove-orphans
  ```
7. Enter the core container to:
    - `composer install`
    - setup laravel using:
        - `php artisan key:generate`
        - `php artisan migrate --seed`
    - `yarn`
```sh
docker exec -it marketplace2-core sh
```
8. Re-create the Supervisor Worker:
```sh
docker compose stop supervisor
docker compose rm supervisor
docker compose up -d
```

## Conatiners

```sh
[+] Running 10/10
 ✔ Network laravel-docker_marketplace2   Created
---- ⚓ Conatiners 👇 -----------------------
 ✔ Container marketplace2-memcached      Started
 ✔ Container marketplace2-elasticsearch  Started
 ✔ Container marketplace2-redis          Started
 ✔ Container marketplace2-db             Started
 ✔ Container marketplace2-mailhog        Started
 ✔ Container marketplace2-minio          Started
 ✔ Container marketplace2-reverse-proxy  Started
 ✔ Container marketplace2-core           Started
 ✔ Container marketplace2-engine         Started
 ✔ Container marketplace2-worker         Started
```

## Starting and stopping

After the initial setup:

1. To bring the containers down you just need to run the following command:

```sh
docker compose down
```

2. If you want to bring them up, just run:

```sh
docker compose up -d --remove-orphans
```

3. To enter the core container's shell to run `composer`, `yarn` & `php artisan` based commands:

```sh
docker exec -it marketplace2-core sh
```

## Access URLs

1. **Application:**
    - URL Scheme: `{APP_HOST}:{FORWARD_TRAEFIK_PORT}`
    - Example: `http://localhost`

2. **Minio Console:**
    - URL Scheme: `{MINIO_HOST}:{FORWARD_MINIO_CONSOLE_PORT}`
    - Example: `http://localhost:8900`

3. **MailHog Dashboard:**
    - URL Scheme: `{APP_HOST}:{FORWARD_MAILHOG_DASHBOARD_PORT}`
    - Example: `http://localhost:8025`

4. **Traefik Dashboard:**
    - URL Scheme: `{TRAEFIK_DASH}:{FORWARD_TRAEFIK_DASH_PORT}/dashboard`
    - Example: `http://localhost:8080/dashboard`


## Use `jpt` Command (linux)

> **Note:** This might also work on MacOS (not tested)

Instead of going inside the container interactively every time, then running the desired command, You can use command `jpt` to run commands directly:

```sh
jpt core artisan about
# OR
jpt core composer install
# OR
jpt core yarn
```

Where `core` is the container (i.e. `marketplace2-core`) followed by the command that you want to run on that container.

To achive this you need to setup the jpt command first:

1. make `jpt_command.sh` executable

```sh
chmod +x ./jpt_command.sh
```

2. Add source to the bash (if using zsh or anything other than bash, replace the `.bashrc` with the correct one):
```sh
echo -e "\n# JPT Command\nsource $PWD/jpt_command.sh" >> ~/.bashrc
source ~/.bashrc
```

### Commands:

To run these basic commands (below) inside the `core` container you don't need to specify `core` in the command, they can be executed directly. To run them in a different container, you will have to specify a container.

#### Example (on core conatiner):

```sh
jpt core artisan about
```

So this would also work, and acts as a shorthand:

```sh
jpt artisan about
```

#### Example (on supervisor container)

> Note: Although it's an option, it won't be needed for most use cases.

```sh
jpt worker artisan about
```

1. Docker compose up

Proxied: `docker compose up -d --build --remove-orphans`

```sh
jpt up
```

2. Docker compose down

Proxied: `docker compose down`

```sh
jpt down
```

3. PHP Artisan Commands

Proxied: `docker compose -it exec marketplace2-core php artisan about`

```sh
jpt artisan about
```

4. Composer Commands

Proxied: `docker compose -it exec marketplace2-core composer install`

```sh
jpt composer install
```

5. Yarn Commands

Proxied: `docker compose -it exec marketplace2-core yarn`

```sh
jpt yarn
```

Proxied: `docker compose -it exec marketplace2-core yarn dev`

```sh
jpt yarn dev
```

> **Note:** The supervisor (worker) container already keep an instance on `yarn dev` running. You can control that in `.env` config.

6. PHP Unit

Proxied: `docker compose -it exec marketplace2-core ./vendor/bin/phpunit`

```sh
jpt unit
```

OR

```sh
jpt phpunit
```

7. Pint

Proxied: `docker compose -it exec marketplace2-core ./vendor/bin/pint`

```sh
jpt pint
```