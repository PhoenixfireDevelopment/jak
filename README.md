# Jak

This is already Docker'ized

```sh
cd docker

docker-compose build --force-rm jak
```

# Run

```sh
cd docker

docker-compose up
```

# Connect bash console

```sh
cd docker
docker-compose exec jak bash
```

# Setup DB

```sh
bundle exe rails db:setup

cd ../..
RAILS_ENV=test bin/rails db:migrate
```
