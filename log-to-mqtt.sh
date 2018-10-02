#!/bin/sh

# Unifi Video Vars
UNIFI_MOTION_LOG=/unifilogs/motion.log

# MQTT Vars
MQTT_SERVER="192.168.1.100"
MQTT_TOPIC_BASE="camera/motion"
echo "MQTT $MQTT_SERFVER topic $MQTT_TOPIC_BASE"

# MQTT User/Pass Vars, only use if needed
#MQTT_USER="username"
#MQTT_PASS="password"

# Camera Defs
CAM1_NAME="Driveway - Garage"
CAM1_ID="F09FC2C0ED58"
echo "Scanning $UNIFI_MOTION_LOG for $CAM1_NAME $CAM1_ID"

# --------------------------------------------------------------------------------
# Script starts here

if [[ -n "$MQTT_USER" && -n "$MQTT_PASS" ]]; then
  $MQTT_USER_PASS="-u $MQTT_USER -P $MQTT_PASS"
else
  $MQTT_USER_PASS=""
fi

while inotifywait -e modify $UNIFI_MOTION_LOG; do
  LAST_MESSAGE=`tail -n1 $UNIFI_MOTION_LOG`
  LAST_CAM=`echo $LAST_MESSAGE | awk -F '[][]' '{print $2}'`
  LAST_EVENT=`echo $LAST_MESSAGE | cut -d ':' -f 5 | cut -d ' ' -f 1`

  if echo $LAST_CAM | grep $CAM1_ID; then
    # Camera 1 triggered
	  if [[ $LAST_EVENT == "start" ]]; then
	    echo "Motion started on $CAM1_NAME"
	    mosquitto_pub -h $MQTT_SERVER $MQTT_USER_PASS -r -t $MQTT_TOPIC_BASE/$CAM1_NAME -m "ON" &
	  else
	    echo "Motion stopped on $CAM1_NAME"
	    mosquitto_pub -h $MQTT_SERVER $MQTT_USER_PASS -r -t $MQTT_TOPIC_BASE/$CAM1_NAME -m "OFF" &
	  fi
  fi
done
