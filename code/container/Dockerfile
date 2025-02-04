FROM ghcr.io/actions/actions-runner:2.322.0
LABEL maintainer="info@perfectthymetech.com"

USER root

ENV AGENT_TOOLSDIRECTORY=/opt/hostedtoolcache
RUN mkdir -p /opt/hostedtoolcache
RUN mkdir -p /_work

ARG AZURE_CLI_VERSION="2.68.0"
ARG PWSH_VERSION="7.5.0"
ARG TARGETPLATFORM

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

WORKDIR /actions-runner
COPY install_dependencies.sh /actions-runner/

RUN chmod +x /actions-runner/install_dependencies.sh \
  && /actions-runner/install_dependencies.sh ${AZURE_CLI_VERSION} ${PWSH_VERSION} \
  && rm /actions-runner/install_dependencies.sh \
  && chown runner /_work /actions-runner /opt/hostedtoolcache

COPY token.sh entrypoint.sh app_token.sh /
RUN chmod +x /token.sh /entrypoint.sh /app_token.sh

ENTRYPOINT ["/entrypoint.sh"]
CMD ["./bin/Runner.Listener", "run", "--startuptype", "service"]
