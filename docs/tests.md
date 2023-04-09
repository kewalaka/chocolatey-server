# Tests

A [test package](https://github.com/kewalaka/chocolatey-server/tree/main/Tests/TestPackage) is included that creates a file in %ProgramData%\TestPackage\test.txt.

[Tests](https://github.com/kewalaka/chocolatey-server/blob/main/Tests/ChocolateyServer.Tests.ps1) are written in Pester and check the following:

- The IIS site returns status code 200, 'OK'.
- The test package can be uploaded to the server using 'choco push'
- The test package can be found using 'choco search'
- The test package can be installed and removed from the server using 'choco install' & 'choco uninstall'

Example test run:

![Tests completed by Pester](https://gist.github.com/kewalaka/656f3a97aea3eed22ffece16d3431a4f/raw/63df66deb923ab76def2478074e52a4689d17fd2/chocolatey-server-tests.png)
