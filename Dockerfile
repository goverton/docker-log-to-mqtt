FROM alpine:edge
COPY ./log-to-mqtt.sh /usr/bin/log-to-mqtt.sh
CMD /usr/bin/log-to-mqtt.sh
