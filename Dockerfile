FROM alpine:edge
COPY ./log-to-mqtt.sh /usr/bin/log-to-mqtt.sh
ENTRYPOINT [ "/usr/bin/log-to-mqtt.sh" ]
