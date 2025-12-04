# plugin-webdav/Dockerfile (or wherever your Dockerfile is)
FROM alpine:latest

# Install Rclone (and bash/curl if you need them for scripting)
RUN apk add --no-cache rclone bash ca-certificates

WORKDIR /data
COPY plugin.sh /usr/local/bin/plugin.sh
RUN chmod +x /usr/local/bin/plugin.sh

CMD ["/usr/local/bin/plugin.sh"]
