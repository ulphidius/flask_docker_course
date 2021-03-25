# Build app images
docker build --tag flask_docker_class --tag flask_docker_class:1.0 --file Dockerfile .
docker build --tag flask_docker_class_prod --tag flask_docker_class_prod:1.0 --file Dockerfile.prod .

# Create network
docker network create --driver=bridge docker_course

# Run app images
docker run --rm --interactive --tty --detach --name docker_course_app --network docker_course --env FLASK_IP=0.0.0.0 --env FLASK_PORT=5000 --publish 5000:5000 flask_docker_class:latest
docker run --rm --interactive --tty --detach --name docker_course_app_prod --network docker_course --env FLASK_IP=0.0.0.0 --env FLASK_PORT=5000 --publish 5000:5000 flask_docker_class_prod:latest

# Test network
docker network inspect docker_course

# Start testing linux
docker run --interactive --tty --detach --network docker_course --name docker_course_linux debian:buster

# Open connection with linux
docker exec --interactive --tty docker_course_linux /bin/bash
apt update && apt install curl
curl http://docker_course_app/
curl http://docker_course_app_prod/

# Start postgresql without volume
docker run --rm --detach --network docker_course --publish 5432:5432 --name postgresql --env POSTGRES_PASSWORD=flask --env POSTGRES_USER=flask --env POSTGRES_DB=course postgres
psql --user flask --dbname course --host 172.17.0.2 < postgresql/data.sql
psql --user flask --dbname course --host 172.17.0.2 --command "SELECT * FROM public.user;"
docker stop postgresql

# Create volume for postgresql data
docker volume create docker_course
docker run --rm --detach --network docker_course --publish 5432:5432 --volume docker_course:/var/lib/postgresql/data --name postgresql --env POSTGRES_PASSWORD=flask --env POSTGRES_USER=flask --env POSTGRES_DB=course postgres
psql --user flask --dbname course --host 172.17.0.2 < postgresql/data.sql
psql --user flask --dbname course --host 172.17.0.2 --command "SELECT * FROM public.user;"
docker stop postgresql
docker run --rm --detach --network docker_course --publish 5432:5432 --volume docker_course:/var/lib/postgresql/data --name postgresql --env POSTGRES_PASSWORD=flask --env POSTGRES_USER=flask --env POSTGRES_DB=course postgres
psql --user flask --dbname course --host 172.17.0.2 --command "SELECT * FROM public.user;"
docker stop postgresql

# Clean up
docker stop docker_course_app
docker stop docker_course_app_prod
docker system prune
