[![Docker Image Build](https://github.com/kewalaka/chocolatey-server/workflows/Build%20%26%20Tests/badge.svg)](https://github.com/kewalaka/chocolatey-server/actions)

# Chocolatey server

This repo contains a Dockerfile for the 'simple' [Chocolatey Server](https://docs.chocolatey.org/en-us/guides/organizations/set-up-chocolatey-server).

It provides a basic NuGet server that can be used to serve chocolatey packages.

The Chocolatey Simple Server has a dependency on .Net Framework 4.x, which is Windows only and is not supported on Nano.  This makes the container quite large.

Whilst not recommended for production use, this serves as an interesting means to create a Chocolatey feed in a CI/CD pipeline, and this repo includes [tests](https://github.com/kewalaka/chocolatey-server/blob/main/Tests/ChocolateyServer.Tests.ps1) to exercise the Chocolatey server.

___
## Install & run from Docker Hub

This container is available on Docker Hub [here](https://hub.docker.com/r/kewalaka/chocolatey-server/).

To install, assuming docker is installed and set to use Windows containers, run:

```powershell
docker run --rm -d -p 8000:80 kewalaka/chocolatey-server:0.2.5
```

This will start a chocolatey server at http://localhost:8000.

The chocolatey server uses the default API key - 'ChocolateyRocks'.

The tests provide examples showing how to create, upload and consume packages.
___
## Local development 

### Build

From the repo folder, assuming docker is installed:

```powershell
docker build . -t chocolatey-server
```

### Run

```powershell
# run detached on localhost:80:
docker run --name chocolatey.server --rm -d -p 80:80 chocolateyserver:latest

# run on localhost:8000 interactively using a dynamic name:
docker run --rm -it -p 8000:80 chocolatey-server:latest
```

### Tests

A [test package](https://github.com/kewalaka/chocolatey-server/tree/main/Tests/TestPackage) is included that creates a file in %ProgramData%\TestPackage\test.txt.

[Tests](https://github.com/kewalaka/chocolatey-server/blob/main/Tests/ChocolateyServer.Tests.ps1) are written in Pester and check the following:
* The IIS site returns status code 200, 'OK'.
* The test package can be uploaded to the server using 'choco push'
* The test package can be found using 'choco search'
* The test package can be installed and removed from the server using 'choco install' & 'choco uninstall'

### Looking inside

(Optionally) If you want to poke around inside the container:

```powershell
# get the container id
docker container ls
# attach to a powershell process in the container 
docker exec -it <containerID> powershell 
```

### Tidy

```powershell
# tidy up all images & stopped containers
docker system prune
```
