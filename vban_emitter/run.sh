#!/bin/bash

echo "Starting VBAN Emitter Add-on..."

# Ensure the VBAN_STREAM_NAME is valid
if [ -z "$VBAN_STREAM_NAME" ]; then
    echo "Error: VBAN_STREAM_NAME is not set in add-on configuration."
    exit 1
fi

# Ensure VOICEMEETER_IP is set
if [ -z "$VOICEMEETER_IP" ]; then
    echo "Error: VOICEMEETER_IP is not set in add-on configuration."
    exit 1
fi

echo "VBAN Stream Name: ${VBAN_STREAM_NAME}"
echo "VoiceMeeter IP: ${VOICEMEETER_IP}"
echo "VBAN Port: ${VBAN_PORT}"

# Execute vban_emitter with configurable parameters
# The 'cat - |' pipes audio from stdin to vban_emitter
exec /usr/bin/vban_emitter -i "$VOICEMEETER_IP" -p "$VBAN_PORT" -s "$VBAN_STREAM_NAME"
