## Docker Cheat Shee

- **Container commands**

1. docker run ps: `Show running containers`
2. docker run ps -a: `Show all containers`
3. docker stop <container_id>/<container_name>: `Stop a running contaniner not delete`
4. docker rm <container_id>/<container_name>: `Delete a running contaniner`
5. docker inspeact <container_id>/<container_name>: `This returns a large JSON output containing details like:`

- Container ID
- Image used
- Environment variables
- Network settings
- Mounted volumes
- IP address
- Ports
- State (running/stopped)

6. Docker logs <container_id>/<container_name>: `Shows logs related to the container`


- **Image commands**

1. docker images: `list all docker images`
2. docker build -t image_tag .: `build a docker image from a Dockerfile`
3. docker rmi <image_id>/<image_tag>: `Delete a docker image`
4. docker tag `current_image` `username/image_tag`: `Tags a docker image`
5. docker push <image_name>: `pushes image to docker hub`
6. docker pull <image_name>: `pulls image from dockerhub`
7. Docker logs <image_id>/<image_name>: `Shows logs related to the image`
7. Docker inspect <image_id>/<image_name>: `This returns a JSON output with details like:`

- Image ID
- Layers
- Environment variables
- Entrypoint
- CMD
- Architecture
- Creation time
- OS
- Labels


- **Volume commands** 

1. docker volume ls: `lists all volume`
2. docker volume create <vol_name>: `creates a docker volume and its storage is managed by docker`
3. docker volume inspeact <vol_name>: `show volume details`
- Mountpoint
- Driver
- Creation time
4. docker volume rm <vol_name>: `removes a docker volume`
5. docker run -d -v sql_data:/var/log/data mysql: `attach vol to a container`

- **Network commands**

1. docker network create <network_name>: `create a docker network of default netwrok driver bridge`
2. docker network ls: `list all docker network`
3. docker network rm <network_name>: `delte a docker network`
4. docker network connect <network_name> <container_name>: `connect container to a particular network`
5. docker network -d <driver> <network_name>: `create a network of a particular network driver type`
    - example: `docker network create -s host my-host-network`


- **Compose commands**

1. docker compose up -d: `run the containers listed in docker-compose file in detached mode`

2. docker compose up: `run the containers in undetached mode`

3. docker compose stop: `Just stops the containers not delete`

4. docker compose down: `stop and deletes the running containers`

5. docker compose down -v : `remvoes the volumes along with the containers`

6. docker compose logs <service_name>: `lists logs realted to the service`

7. docker compose exec <service_name> <command like bash>: `inspect service related to the service`

8. docker compose up --build: `Builds images again and starts the container. Used when we change code or Dockerfile.`

9. docker compose ps: `lists running services`

10. docker compose restart: `restart running services`

- **Cleanup commands**

1. docker system prune: `deletes every stopped container,image,unused volume`

2. docker image prune: `deletes dangling images`

3. docker image prune -a: `Remove all unused images`

4. docker container prune: `Removes all stopped containers`

5. docker volume prune: `Deletes volumes not used by any container`

6. docker network prune: `Deletes network not used by any container`

7. docker system df: `shows disk usage by docker`

- **Dockerfile instructions**

1. FROM: `FROM specifies the base image used to build the Docker image. It is usually pulled from a registry such as Docker Hub.`

*Notes:*

- Not always an OS image.
- Could be language runtime images like node, python, golang.

2. WORKDIR: `WORKDIR sets the working directory for subsequent instructions such as RUN, CMD, COPY, and ENTRYPOINT.`

3. COPY: `COPY copies files or directories from the host machine (build context) into the container filesystem.`

4. RUN: `RUN executes commands during image build time to install packages or configure the image.`

5. EXPOSE: `EXPOSE documents the port that the container listens on. It does not publish the port automatically.`

6. CMD: `CMD specifies the default command that runs when a container starts. It can be overridden at runtime.`

*Example:*

CMD ["node", "server.js"]

Example override:

docker run my-image bash

7. ENTRYPOINT: `ENTRYPOINT defines the main executable of the container. Arguments passed at runtime are appended to it, and it is not easily overridden.`

*Example:*

ENTRYPOINT ["python"]

Running:

docker run myimage script.py

Executes:

python script.py