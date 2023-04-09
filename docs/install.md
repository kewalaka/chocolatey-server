# Install & run from Docker Hub

This container is available on Docker Hub [here](https://hub.docker.com/r/kewalaka/chocolatey-server/).

To install, assuming docker is installed and set to use Windows containers, run:

```powershell
docker run --rm -d -p 8000:80 kewalaka/chocolatey-server:0.2.5
```

This will start a chocolatey server at http://localhost:8000.

The chocolatey server uses the default API key - 'ChocolateyRocks'.

The tests provide examples showing how to create, upload and consume packages.
