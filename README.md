# Docker for Laravel on Local

## Steps to setup

### Initial Setup

1. Clone this repository.
2. Create a `backend` and `frontend` folder inside the `workspace` directory.
3. Copy the example.env as .env on the root & update as required.
4. Clone the backend (laravel) app in your `backend` folder and frontend app in your `frontend` folder.
    - Example `backend` using ssh
    ```sh
    git clone git@github.com:organization/backend-repo.git ./workspace/backend
    ```
    - Example `frontend` using ssh
    ```sh
    git clone git@github.com:organization/frontend-repo.git ./workspace/frontend
    ```
5. Run the docker up command with build & detached flag:
  ```sh
  docker compose up -d --build --remove-orphans
  ```
6. Enter the core container to:
    - `composer install`
    - setup laravel using:
        - `php artisan key:generate`
        - `php artisan migrate --seed`
    - `yarn`
```sh
docker exec -it marketplace2-core sh
```
7. Re-create the Supervisor Worker:
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

## Use `jpt` Command (linux)

Instead of going inside the container interactively every time, then running the desired command, You can use command `jpt` to run commands directly:

```sh
jpt core php artisan about
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