# Chocolatey server

This repo contains a Dockerfile for the 'simple' [Chocolatey Server](https://docs.chocolatey.org/en-us/guides/organizations/set-up-chocolatey-server).

It provides a basic NuGet server that can be used to serve chocolatey packages.

The Chocolatey Simple Server has a dependency on .Net Framework 4.x, which is Windows only and is not supported on Nano. This makes the container quite large.

Whilst not recommended for production use, this serves as an interesting means to create a Chocolatey feed in a CI/CD pipeline, and this repo includes [tests](https://github.com/kewalaka/chocolatey-server/blob/main/Tests/ChocolateyServer.Tests.ps1) to exercise the Chocolatey server.
