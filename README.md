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