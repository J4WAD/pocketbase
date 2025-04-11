FROM alpine:3.19 AS downloader
ARG VERSION=0.26.6
RUN apk add --no-cache unzip ca-certificates wget
RUN wget https://github.com/pocketbase/pocketbase/releases/download/v${VERSION}/pocketbase_${VERSION}_linux_amd64.zip \
    && unzip pocketbase_${VERSION}_linux_amd64.zip \
    && chmod +x /pocketbase

# Use Alpine instead of scratch
FROM alpine:3.19
# Install necessary packages
RUN apk add --no-cache ca-certificates mailx postfix
# Configure postfix for simple operation
RUN echo "inet_interfaces = loopback-only" >> /etc/postfix/main.cf \
    && echo "mydestination = localhost.localdomain, localhost" >> /etc/postfix/main.cf \
    && newaliases \
    && mkdir -p /var/spool/postfix/pid \
    && chown -R postfix:postfix /var/spool/postfix

EXPOSE 8090
COPY --from=downloader /pocketbase /usr/local/bin/pocketbase
# Start postfix before pocketbase
CMD ["/bin/sh", "-c", "postfix start && /usr/local/bin/pocketbase serve --http=0.0.0.0:8090 --dir=/pb_data"]