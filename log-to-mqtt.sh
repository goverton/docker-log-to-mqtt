#!/bin/sh

LOG=/logs/log-to-mqtt.log
touch $LOG

# Unifi Video Vars
UNIFI_MOTION_LOG=/unifilogs/motion.log

# MQTT Vars
MQTT_SERVER="192.168.1.100"
MQTT_PORT="1883"
MQTT_TOPIC_BASE="camera/motion"

echo "`date -I'seconds'` [INFO] - MQTT $MQTT_SERVER:$MQTT_PORT topic $MQTT_TOPIC_BASE"

while inotifywait -e modify $UNIFI_MOTION_LOG; do
  LAST_LOG_MESSAGE=`tail -n1 $UNIFI_MOTION_LOG`
  CAMERA=`echo $LAST_LOG_MESSAGE | awk -F '[()]' '{print $2}'`
  ACTION=`echo $LAST_LOG_MESSAGE | sed -n 's/.*type:\([a-z][a-z]*\) .*/\1/p'`

  mosquitto_pub -h "$MQTT_SERVER" -p "$MQTT_PORT" -r -t "$MQTT_TOPIC_BASE/$CAMERA" -m "$ACTION" &
done
