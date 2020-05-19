FROM debian:buster

ENV VPN_ADDR \
    VPN_USER \
    VPN_PASS

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
    openfortivpn \
  && apt-get clean -q && apt-get autoremove --purge \
  && rm -rf /var/lib/apt/lists/*

WORKDIR /root

COPY forticlient.exp /usr/bin/forticlient
COPY start.sh /start.sh

RUN chmod +x /start.sh /usr/bin/forticlient

ENTRYPOINT ["/bin/bash"]

CMD [ "/start.sh" ]