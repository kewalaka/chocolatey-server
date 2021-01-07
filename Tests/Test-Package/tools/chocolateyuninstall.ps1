$ErrorActionPreference = 'Stop';

# uninstall removes the folder created
Remove-Item -Type Directory $env:ProgramData\TestPackage -Recurse