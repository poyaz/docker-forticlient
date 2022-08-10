FROM alpine:3.15.5

ENV SSH_USER_PASSWORD=""
ENV SSH_PUBLIC_KEY_VALUE=""

RUN set -eux; \
    apk add --no-cache bash openssh; \
    \
    addgroup -g 1000 -S forti; \
    adduser -u 1000 -S -D -G forti -h /home/forti -s /bin/sh forti; \
    mkdir -p /home/forti/.ssh; \
    chown -R forti:forti /home/forti/.ssh; \
    chmod -R 700 /home/forti/.ssh

COPY docker-entrypoint.sh /usr/local/bin/

RUN chmod +x /usr/local/bin/docker-entrypoint.sh

ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]

CMD ["sshd"]
