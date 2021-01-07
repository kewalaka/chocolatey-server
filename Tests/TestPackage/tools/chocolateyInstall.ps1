$ErrorActionPreference = 'Stop'

# rather than install anything, we'll just create a file.
New-Item -Type Directory $env:ProgramData\TestPackage
Set-Content -Value 'Hello chocolatey!' -Path $env:ProgramData\TestPackage\test.txt