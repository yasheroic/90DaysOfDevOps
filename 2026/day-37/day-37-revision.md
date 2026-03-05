## Self-Assessment Checklist
Mark yourself honestly — **can do**, **shaky**, or **haven't done**:

- [can do] Run a container from Docker Hub (interactive + detached)
- [can do] List, stop, remove containers and images
- [can do] Explain image layers and how caching works
- [can do] Write a Dockerfile from scratch with FROM, RUN, COPY, WORKDIR, CMD
- [can do] Explain CMD vs ENTRYPOINT
- [can do] Build and tag a custom image
- [can do] Create and use named volumes
- [can do] Use bind mounts
- [can do] Create custom networks and connect containers
- [can do] Write a docker-compose.yml for a multi-container app
- [can do] Use environment variables and .env files in Compose
- [can do] Write a multi-stage Dockerfile
- [can do] Push an image to Docker Hub
- [can do] Use healthchecks and depends_on
---

## Quick-Fire Questions
Answer from memory, then verify:
1. What is the difference between an image and a container?

- Image is the blueprint and container in the running instance of the image 

- `A Docker image is a read-only template used to create containers. A container is a running instance of that image with its own writable layer.`

2. What happens to data inside a container when you remove it?

- if we use a volume then it gets stored otherwise it is lost. containers are `ephimeral`

- `Containers are ephemeral. Data stored in the container filesystem is lost when the container is removed unless it is stored in a volume or bind mount.`

3. How do two containers on the same custom network communicate?

- Through Bridge Mode

- `Containers on the same custom network communicate using **Docker's internal DNS**, referencing each other by container name or service name.`

4. What does `docker compose down -v` do differently from `docker compose down`?

- when `-v` is used the volume is also taken down so when we again up the container the data wont be there anymore 

5. Why are multi-stage builds useful?

- it has 2 steps `builder` stage and `run` stage so all the compiling and dpendency installing is done is first step and only the compiled apps and dependecy are copied and run so the image size is very much reduced

- `This reduces image size, attack surface, and unnecessary build tools in production images.`

6. What is the difference between `COPY` and `ADD`?

- *COPY* `Copies files from host to container`
*ADD* `Same as COPY but can extract tar files and download URLs`

7. What does `-p 8080:80` mean?

- it means the containers port 80 is binded to the hosts 8080 port so anything on port 80 of container is forwarded to hosts port 8080

8. How do you check how much disk space Docker is using?

- `docker system df`

---