FROM alpine:3.6

ENV \
  CONSUL_VERSION=0.9.3 \
  CONSUL_SHA256=9c6d652d772478d9ff44b6decdd87d980ae7e6f0167ad0f7bd408de32482f632 \
  CONSUL_CLI_VERSION=0.3.1 \
  GLIBC_VERSION=2.25-r0 \
  DUMB_INIT_VERSION=1.2.0-r0 \
  SU_EXEC_VERSION=0.2-r0 \
  MONITORING_PLUGINS_VERSION=2.2-r1 \
  GOMAXPROCS=2

RUN \
  echo "Installing packages.." && \
  apk --update add bash \
                   ca-certificates \
                   # for running custom http health checks
                   curl \
                   # for use in watch handlers to parse payload
                   jq \
                   # for running basic health checks against host (disk space, swap, etc)
                   monitoring-plugins=${MONITORING_PLUGINS_VERSION} \
                   su-exec==${SU_EXEC_VERSION} \
                   dumb-init==${DUMB_INIT_VERSION} && \
  curl -Ls https://github.com/sgerrand/alpine-pkg-glibc/releases/download/${GLIBC_VERSION}/glibc-${GLIBC_VERSION}.apk > /tmp/${GLIBC_VERSION}.apk && \
  apk add --allow-untrusted /tmp/${GLIBC_VERSION}.apk && \
  rm -rf /tmp/${GLIBC_VERSION}.apk /var/cache/apk/* && \
  \
  echo "Installing Consul.." && \
  curl -Ls https://releases.hashicorp.com/consul/${CONSUL_VERSION}/consul_${CONSUL_VERSION}_linux_amd64.zip > /tmp/consul.zip && \
  echo "${CONSUL_SHA256}  /tmp/consul.zip" > /tmp/consul.sha256 && \
  sha256sum -c /tmp/consul.sha256 && \
  cd /bin && \
  unzip /tmp/consul.zip && \
  chmod +x /bin/consul && \
  rm /tmp/consul.zip && \
  \
  echo "Installing Consul cli.." && \
  curl -Ls https://github.com/CiscoCloud/consul-cli/releases/download/v${CONSUL_CLI_VERSION}/consul-cli_${CONSUL_CLI_VERSION}_linux_amd64.tar.gz -o /tmp/consul-cli.tar.gz && \
  cd /tmp && \
  tar xzf consul-cli.tar.gz && \
  mv consul-cli_${CONSUL_CLI_VERSION}_linux_amd64/consul-cli /bin/consul-cli && \
  chmod +x /bin/consul-cli && \
  rm /tmp/consul-cli.tar.gz && \
  \
  echo "Creating config directory.." && \
  mkdir /config

COPY bin/entrypoint.sh /bin/entrypoint.sh

VOLUME ["/data"]

EXPOSE 8300 8301 8301/udp 8302 8302/udp 8400 8500 8600 8600/udp

ENTRYPOINT ["/bin/entrypoint.sh"]

CMD ["/bin/consul", "agent", "-dev", "-client=0.0.0.0", "-config-dir=/config"]
