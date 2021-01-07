[![Docker Image Build](https://github.com/kewalaka/chocolatey-server/workflows/Docker%20Image%20Build/badge.svg)](https://github.com/kewalaka/chocolatey-server/actions)

# Chocolatey server #

This repo contains a Dockerfile for the 'simple' [chocolatey server](https://docs.chocolatey.org/en-us/guides/organizations/set-up-chocolatey-server).

It provides a basic NuGet server that can be used to serve chocolatey packages.

Need to use Windows containers for this, as it has a dependency on .Net Framework 4.x, which is Windows only.

## Build

From the repo folder, assuming docker is installed:

```powershell
docker build . -t chocolateyserver
```

## Run

```powershell
# run detached on localhost:80:
docker run --name chocolatey.server --rm -d -p 80:80 chocolateyserver:latest

# run on localhost:8000 interactively using a dynamic name:
docker run --rm -it -p 8000:80 chocolateyserver:latest
```

(Optionally) If you want to poke around inside the container:

```powershell
# get the container id
docker container ls
# attach to a powershell process in the container 
docker exec -it <containerID> powershell 
```

## Tidy

```powershell
# tidy up all images & stopped containers
docker system prune
```
