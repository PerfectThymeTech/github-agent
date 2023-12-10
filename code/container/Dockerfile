FROM ghcr.io/myoung34/docker-github-actions-runner:2.311.0-ubuntu-focal

# General
RUN sudo apt-get update

# Install Azure CLI
ARG AZURE_CLI_VERSION=2.51.0
RUN sudo apt-get install ca-certificates curl apt-transport-https lsb-release gnupg \
    && sudo mkdir -p /etc/apt/keyrings \
    && curl -sLS https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor | sudo tee /etc/apt/keyrings/microsoft.gpg > /dev/null \
    && sudo chmod go+r /etc/apt/keyrings/microsoft.gpg \
    && AZ_DIST=$(lsb_release -cs) \
    && echo "deb [arch=`dpkg --print-architecture` signed-by=/etc/apt/keyrings/microsoft.gpg] https://packages.microsoft.com/repos/azure-cli/ $AZ_DIST main" | sudo tee /etc/apt/sources.list.d/azure-cli.list \
    && sudo apt-get install azure-cli=$AZURE_CLI_VERSION-1~$AZ_DIST
