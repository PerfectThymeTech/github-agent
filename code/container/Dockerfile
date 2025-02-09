FROM ghcr.io/actions/actions-runner:2.322.0
LABEL maintainer="info@perfectthymetech.com"

USER root

# install curl and jq
RUN apt-get update && apt-get install -y curl jq && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

ARG AZURE_CLI_VERSION="2.68.0"
ARG PWSH_VERSION="7.5.0"

# SHELL ["/bin/bash", "-o", "pipefail", "-c"]

COPY install_dependencies.sh /install_dependencies.sh

RUN chmod +x /install_dependencies.sh \
  && /install_dependencies.sh ${AZURE_CLI_VERSION} ${PWSH_VERSION} \
  && rm /install_dependencies.sh

COPY entrypoint.sh ./entrypoint.sh
RUN chmod +x ./entrypoint.sh

USER runner

ENTRYPOINT ["/entrypoint.sh"]
# CMD ["./bin/Runner.Listener", "run", "--startuptype", "service"]
