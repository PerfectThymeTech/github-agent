FROM myoung34/github-runner-base:ubuntu-noble
LABEL maintainer="info@perfectthymetech.com"

# Can be 'linux-x64', 'linux-arm64', 'linux-arm', 'rhel.6-x64'.
ENV TARGETARCH=linux-x64

ARG AZURE_CLI_VERSION="2.72.0"
ARG PWSH_VERSION="7.5.3"

RUN DEBIAN_FRONTEND=noninteractive apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt-get upgrade -y

RUN DEBIAN_FRONTEND=noninteractive apt-get install -y -qq --no-install-recommends \
    apt-transport-https \
    apt-utils \
    ca-certificates \
    curl \
    git \
    iputils-ping \
    jq \
    lsb-release \
    software-properties-common

WORKDIR /azp
COPY install_dependencies.sh start.sh /azp/

RUN chmod +x /azp/start.sh /azp/install_dependencies.sh \
    && /azp/install_dependencies.sh ${AZURE_CLI_VERSION} ${PWSH_VERSION} \
    && rm /azp/install_dependencies.sh

ENTRYPOINT [ "./start.sh" ]
