FROM alpine:edge
COPY ./log-to-mqtt.sh /usr/bin/log-to-mqtt.sh

RUN apk --update upgrade && \
    apk add --update inotify-tools && \
    apk add --update mosquitto-clients && \
    rm -rf /var/cache/apk/*

ENTRYPOINT ["sh", "/usr/bin/log-to-mqtt.sh"]
