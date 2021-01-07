BeforeAll {
    # create a package to push to the chocolatey server
    Invoke-Expression -Command 'choco pack .\Tests\TestPackage\TestPackage.nuspec'
    # get more useful info from chocolatey exit codes
    choco feature enable -n useEnhancedExitCodes
}

Describe "Chocolatey Server tests" {
    Context "Web server" {       
        It "returns status code 200" {
            try {
                $r = Invoke-WebRequest -UseBasicParsing http://localhost:8000  -TimeoutSec 15
                # give IIS chance to wake up
                if ($null -eq $r.StatusCode) {
                    Start-Sleep -Seconds 3
                    $r = Invoke-WebRequest -UseBasicParsing http://localhost:8000  -TimeoutSec 15
                }
            }
            catch {}
            $r.StatusCode | Should -Be '200'
        }
        
        It "choco source add returns exit code 0" {
            try {
                Invoke-Expression -Command 'choco source add -n=test -s "http://localhost:8000"'
            }
            catch {}
            $LastExitCode | Should -Be 0
        }        

        It "choco apikey returns exit code 0" {
            try {
                Invoke-Expression -Command 'choco apikey -s="http://localhost:8000" -k="ChocolateyRocks"'
            }
            catch {}
            $LastExitCode | Should -Be 0
        }
    }

    Context "Package deployment" {
        It "choco push returns exit code 0" {
            try {
                Invoke-Expression -Command 'choco push --source "http://localhost:8000"'
            }
            catch {}
            $LastExitCode | Should -Be 0
        }

        It "choco search returns exit code 0 and one package is found" {
            try {
                $r = Invoke-Expression -Command 'choco search testpackage --source="http://localhost:8000/chocolatey"'
            }
            catch {}
            $LastExitCode | Should -Be 0
            $r[-1] | Should -Be "1 packages found."
        }
    }

    Context "Package install & uninstall" {
        It "choco install returns exit code 0" {
            try {
                Invoke-Expression -Command 'choco install testpackage -s "http://localhost:8000/chocolatey" -y' 
            }
            catch {}
            $LastExitCode | Should -Be 0
        }
        It "Package is installed" {
            Get-Content $env:ProgramData\TestPackage\test.txt | Should -Be 'Hello chocolatey!'
        }
        It "choco uninstall return exit code 0" {
            try {
                Invoke-Expression -Command 'choco uninstall testpackage -y' 
            }
            catch {}
            $LastExitCode | Should -Be 0
        }
    }

    Context "Tidy up" {
        It "choco apikey --remove returns exit code 0" {
            try {
                Invoke-Expression -Command 'choco apikey --remove --source="http://localhost:8000"'
            }
            catch {}
            $LastExitCode | Should -Be 0
        }

        It "choco source remove returns exit code 0" {
            try {
                Invoke-Expression -Command 'choco source remove -n=test'
            }
            catch {}
            $LastExitCode | Should -Be 0
        }        

    }
}

AfterAll {
    # nothing to do
}