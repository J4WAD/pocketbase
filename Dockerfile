FROM alpine:3.19 AS downloader
ARG VERSION=0.23.6
RUN apk add --no-cache unzip ca-certificates wget
RUN wget https://github.com/pocketbase/pocketbase/releases/download/v${VERSION}/pocketbase_${VERSION}_linux_amd64.zip \
    && unzip pocketbase_${VERSION}_linux_amd64.zip \
    && chmod +x /pocketbase

FROM scratch
EXPOSE 8090
COPY --from=downloader /pocketbase /usr/local/bin/pocketbase
COPY pb_data /pb_data  # Ensure pb_data is included
CMD ["/usr/local/bin/pocketbase", "serve", "--http=0.0.0.0:8090", "--dir=/pb_data"]
