$ErrorActionPreference = 'Stop';

# uninstall removes the folder created
Remove-Item $env:ProgramData\TestPackage -Recurse