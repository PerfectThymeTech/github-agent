#!/bin/bash -ex
AZURE_CLI_VERSION=$1
PWSH_VERSION=$2

# Install Azure CLI
sudo apt-get install -y ca-certificates curl apt-transport-https lsb-release gnupg \
    && sudo mkdir -p /etc/apt/keyrings \
    && curl -sLS https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor | sudo tee /etc/apt/keyrings/microsoft.gpg > /dev/null \
    && sudo chmod go+r /etc/apt/keyrings/microsoft.gpg \
    && AZ_DIST=$(lsb_release -cs) \
    && echo "deb [arch=`dpkg --print-architecture` signed-by=/etc/apt/keyrings/microsoft.gpg] https://packages.microsoft.com/repos/azure-cli/ $AZ_DIST main" | sudo tee /etc/apt/sources.list.d/azure-cli.list \
    && sudo apt-get update \
    && AZ_DIST=$(lsb_release -cs) \
    && sudo apt-get install -y azure-cli=$AZURE_CLI_VERSION-1~$AZ_DIST

# Install Azure CLI - AKS
sudo az aks install-cli

# Install Powershell
sudo apt-get install -y wget \
    && wget https://github.com/PowerShell/PowerShell/releases/download/v$PWSH_VERSION/powershell_$PWSH_VERSION-1.deb_amd64.deb \
    && sudo dpkg -i powershell_$PWSH_VERSION-1.deb_amd64.deb \
    && sudo apt-get install -fy \
    && rm powershell_$PWSH_VERSION-1.deb_amd64.deb \
    && pwsh -Command "Install-Module -Name Az -Repository PSGallery -Force"
