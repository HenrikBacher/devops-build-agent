# escape=`

FROM mcr.microsoft.com/windows/servercore:20H2

# Install .NET 4.8
RUN curl -fSLo dotnet-framework-installer.exe https://download.visualstudio.microsoft.com/download/pr/014120d7-d689-4305-befd-3cb711108212/0307177e14752e359fde5423ab583e43/ndp48-devpack-enu.exe `
    && .\dotnet-framework-installer.exe /q `
    && del .\dotnet-framework-installer.exe `
    && powershell Remove-Item -Force -Recurse ${Env:TEMP}\*

# Set PowerShell as default shell
SHELL [ "powershell", "-NoProfile", "-Command" ]
RUN $ProgressPreference = 'SilentlyContinue'

# Install Visual Studio Test Platform (vstest)
RUN Register-PackageSource -Name MyNuGet -Location https://www.nuget.org/api/v3/index.json -ProviderName NuGet | Out-Null ; `
    Install-Package Microsoft.TestPlatform -Force | Out-Null ; `
    setx vstest 'c:\Program Files\PackageManagement\NuGet\Packages\Microsoft.TestPlatform.16.2.0\tools\net451\Common7\IDE\Extensions\TestPlatform'

# Install Visual Studio with dotNet workload
RUN Invoke-WebRequest "https://aka.ms/vs/16/release/vs_community.exe" -OutFile ".\vs_community.exe" -UseBasicParsing ; `
    Start-Process .\vs_community.exe -ArgumentList '--add Microsoft.VisualStudio.Workload.NetWeb --quiet --norestart' -Wait ; `
    Remove-Item ".\vs_community.exe" ; `
    setx visualstudio 'C:\Program Files (x86)\Microsoft Visual Studio\2019\Community\MSBuild\Current\Bin'
    # Update PATH environment variable
RUN $machinePath = [environment]::GetEnvironmentVariable('path', [System.EnvironmentVariableTarget]::Machine) ; `
    $newMachinePath = 'C:\Program Files (x86)\Microsoft Visual Studio\2019\Community\MSBuild\Current\Bin;' + $machinePath ; `
    [environment]::SetEnvironmentVariable('path', $newMachinePath, [System.EnvironmentVariableTarget]::Machine)

# Install Java runtime
RUN Invoke-WebRequest -Uri "https://repos.azul.com/azure-only/zulu/packages/zulu-7/7u232/zulu-7-azure-jdk_7.31.0.5-7.0.232-win_x64.zip" -OutFile ".\azulJDK7.zip" -UseBasicParsing ; `
    Invoke-WebRequest -Uri "https://repos.azul.com/azure-only/zulu/packages/zulu-8/8u222/zulu-8-azure-jdk_8.40.0.25-8.0.222-win_x64.zip" -OutFile ".\azulJDK8.zip" -UseBasicParsing ; `
    Invoke-WebRequest -Uri "https://repos.azul.com/azure-only/zulu/packages/zulu-11/11.0.4/zulu-11-azure-jdk_11.33.15-11.0.4-win_x64.zip" -OutFile ".\azulJDK11.zip" -UseBasicParsing ; `
    # Expand the zips
    Expand-Archive -Path '.\azulJDK7.zip' -DestinationPath 'C:\Program Files\Java\' -Force ; `
    Expand-Archive -Path '.\azulJDK8.zip' -DestinationPath 'C:\Program Files\Java\' -Force ; `
    Expand-Archive -Path '.\azulJDK11.zip' -DestinationPath 'C:\Program Files\Java\' -Force ; `
    # Deleting zip folders
    Remove-Item ".\azulJDK7.zip" ; `
    Remove-Item ".\azulJDK8.zip" ; `
    Remove-Item ".\azulJDK11.zip" ; `
    # Get Java Paths
    $java7Installs =Get-ChildItem -Path 'C:\Program Files\Java' -Filter '*azure-jdk*7*' | Sort-Object -Property Name -Descending | Select-Object -First 1 ; `
    $latestJava7Install = $java7Installs.FullName ; `
    $java8Installs = Get-ChildItem -Path 'C:\Program Files\Java' -Filter '*azure-jdk*8*' | Sort-Object -Property Name -Descending | Select-Object -First 1 ; `
    $latestJava8Install = $java8Installs.FullName ; `
    $java11Installs = Get-ChildItem -Path 'C:\Program Files\Java' -Filter '*azure-jdk*11*' | Sort-Object -Property Name -Descending | Select-Object -First 1 ; `
    $latestJava11Install = $java11Installs.FullName ; `
    # Set Java environet variables
    setx java $latestJava8Install | Out-Null ; `
    setx JAVA_HOME $latestJava8Install | Out-Null ; `
    setx JAVA_HOME_7_X64 $latestJava7Install | Out-Null ; `
    setx JAVA_HOME_8_X64 $latestJava8Install | Out-Null ; `
    setx JAVA_HOME_11_X64 $latestJava11Install | Out-Null 

# Clean up temp directory
RUN Remove-Item -Force -Recurse ${Env:TEMP}\*

WORKDIR /azp

COPY ./start.ps1 .

CMD powershell .\start.ps1