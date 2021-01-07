BeforeAll {
    # create a package to push to the chocolatey server
    choco pack .\Test-Package\TestPackage.nuspec
    # start the docker image
    docker run --name chocolateyserver --rm -d -p 8000:80 chocolateyserver:latest
}

Describe "Chocolatey Server tests" {
    Context "Web server is responding" {
        
        It "returns status code 200" {
            try {
                $r = Invoke-WebRequest -UseBasicParsing http://localhost:8000  -TimeoutSec 15
            }
            catch {       
            }
            $r.StatusCode | Should -Be '200'
        }
    }
}

AfterAll {
    docker container rm chocolateyserver -f
}