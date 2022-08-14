FROM debian:buster-slim

RUN apt-get update && \
  DEBIAN_FRONTEND=noninteractive apt-get install -y \
    -o APT::Install-Recommends=false \
    -o APT::Install-Suggests=false \
    ca-certificates \
    expect \
    net-tools \
    iproute2 \
    ipppd \
    iptables \
    ssh \
    curl \
    wget \
    inotify-tools \
    openfortivpn \
  && apt-get clean -q && apt-get autoremove --purge \
  && rm -rf /var/lib/apt/lists/*

WORKDIR /root

COPY forticlient.exp /usr/local/bin/forticlient
COPY docker-entrypoint.sh docker-healcheck.sh file-notify-2fa.sh /usr/local/bin/

RUN chmod +x \
    /usr/local/bin/docker-entrypoint.sh \
    /usr/local/bin/docker-healcheck.sh \
    /usr/local/bin/file-notify-2fa.sh \
    /usr/local/bin/forticlient; \
    \
    mkdir /tmp/2fa/; \
    chmod -R 777 /tmp/2fa/

ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]

ENV VPN_ADDR=""
ENV VPN_USER=""
ENV VPN_PASS=""
ENV VPN_TIMEOUT=""
ENV VPN_2FA_DIR=""
ENV VPN_2FA_FILE=""

HEALTHCHECK --interval=30s --timeout=5s \
    CMD bash /usr/local/bin/docker-healcheck.sh || pkill -SIGILL -f 1
