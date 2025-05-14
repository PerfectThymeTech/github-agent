FROM myoung34/github-runner-base:ubuntu-noble
LABEL maintainer="info@perfectthymetech.com"

ENV AGENT_TOOLSDIRECTORY=/opt/hostedtoolcache
RUN mkdir -p /opt/hostedtoolcache

ARG GH_RUNNER_VERSION="2.324.0"
ARG AZURE_CLI_VERSION="2.71.0"
ARG PWSH_VERSION="7.5.1"
ARG TARGETPLATFORM

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

WORKDIR /actions-runner
COPY install_actions.sh install_dependencies.sh /actions-runner/

RUN chmod +x /actions-runner/install_actions.sh /actions-runner/install_dependencies.sh \
  && /actions-runner/install_actions.sh ${GH_RUNNER_VERSION} ${TARGETPLATFORM} \
  && /actions-runner/install_dependencies.sh ${AZURE_CLI_VERSION} ${PWSH_VERSION} \
  && rm /actions-runner/install_actions.sh \
  && rm /actions-runner/install_dependencies.sh \
  && chown runner /_work /actions-runner /opt/hostedtoolcache

COPY token.sh entrypoint.sh app_token.sh /
RUN chmod +x /token.sh /entrypoint.sh /app_token.sh

ENTRYPOINT ["/entrypoint.sh"]
CMD ["./bin/Runner.Listener", "run", "--startuptype", "service"]
