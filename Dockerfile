FROM mcr.microsoft.com/dotnet/framework/aspnet:4.8

LABEL maintainer="Stu <kewalaka@gmail.com>"

# install chocolatey
RUN powershell -NoProfile -Command \
   Set-ExecutionPolicy Bypass -Scope Process -Force; \ 
   [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; \
   iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))

# install the chocolatey simple server from the chocolatey community repo
RUN powershell -NoProfile -Command \
    choco feature disable --name showDownloadProgress; \
    choco install chocolatey.server -y --version=0.2.5; \
    Remove-Item -Path C:\tools\chocolatey.server\App_Data\Packages\Readme.txt

# set the correct IIS app pool settings, remove the default website
# create the new site and assign the app pool.
RUN powershell -NoProfile -Command \
    Import-Module IISAdministration; \
    Import-Module WebAdministration; \
    New-WebAppPool -Name chocolatey.server; \
    Set-ItemProperty IIS:\AppPools\chocolatey.server enable32BitAppOnWin64 True; \
    Set-ItemProperty IIS:\AppPools\chocolatey.server managedRuntimeVersion v4.0; \
    Set-ItemProperty IIS:\AppPools\chocolatey.server managedPipelineMode Integrated; \
    Set-ItemProperty IIS:\AppPools\chocolatey.server processModel.loadUserProfile True; \
    Remove-WebSite -Name 'Default Web Site'; \
    New-IISSite -Name "Chocolatey" -PhysicalPath C:\tools\chocolatey.server -BindingInformation "*:80:"; \
    Set-ItemProperty "IIS:\Sites\Chocolatey" ApplicationPool chocolatey.server

# this secures the website so that users only have read access except to the App_Data folder,
# where modify permissions are required to be able to upload packages
RUN powershell -NoProfile -Command \
    { $objACL = Get-ACL -Path c:\tools\chocolatey.server; \
    $objACL.SetAccessRuleProtection($True, $False); \
    $AceObject = New-Object -TypeName System.Security.AccessControl.FileSystemAccessRule('Administrators', 'FullControl', @('ContainerInherit','ObjectInherit'), 'None', 'Allow'); \
    $objACL.AddAccessRule($AceObject); \
    $AceObject = New-Object -TypeName System.Security.AccessControl.FileSystemAccessRule('IIS_IUSRS', 'ReadAndExecute', @('ContainerInherit','ObjectInherit'), 'None', 'Allow'); \
    $objACL.AddAccessRule($AceObject); \
    $AceObject = New-Object -TypeName System.Security.AccessControl.FileSystemAccessRule('IUSR', 'ReadAndExecute', @('ContainerInherit','ObjectInherit'), 'None', 'Allow'); \
    $objACL.AddAccessRule($AceObject); \
    Set-ACL -Path c:\tools\chocolatey.server -AclObject $objACL; \
    \
    $objACL = Get-ACL -Path c:\tools\chocolatey.server\App_Data; \
    $AceObject = New-Object -TypeName System.Security.AccessControl.FileSystemAccessRule('IIS_IUSRS', 'Modify', @('ContainerInherit','ObjectInherit'), 'None', 'Allow'); \
    $objACL.AddAccessRule($AceObject); \
    Set-ACL -Path c:\tools\chocolatey.server\App_Data -AclObject $objACL; \
    }
    
EXPOSE 80