#!/bin/bash

echo "Starting VBAN Emitter Add-on v0.1.0..."

# Set defaults from config.json (HA injects overrides)
VBAN_STREAM_NAME="${VBAN_STREAM_NAME:-music_assistant}"
VOICEMEETER_IP="${VOICEMEETER_IP:-127.0.0.1}"
VBAN_PORT="${VBAN_PORT:-6980}"

# Validate required vars
if [ -z "$VBAN_STREAM_NAME" ] || [ -z "$VOICEMEETER_IP" ]; then
    echo "Error: VBAN_STREAM_NAME and VOICEMEETER_IP must be set in add-on configuration."
    exit 1
fi

echo "VBAN Stream Name: ${VBAN_STREAM_NAME}"
echo "VoiceMeeter IP: ${VOICEMEETER_IP}"
echo "VBAN Port: ${VBAN_PORT}"

# Check if vban_emitter is installed
if [ ! -x "/usr/bin/vban_emitter" ]; then
    echo "Error: vban_emitter binary not built/installed. Check Dockerfile build logs."
    exit 1
fi

# Function to stream audio (wait for temp file from HA)
stream_audio() {
    temp_file="/tmp/audio.raw"
    while [ ! -f "$temp_file" ]; do
        echo "Waiting for audio file from HA..."
        sleep 1
    done
    /usr/bin/vban_emitter -i "$VOICEMEETER_IP" -p "$VBAN_PORT" -s "$VBAN_STREAM_NAME" "$temp_file"
    rm -f "$temp_file"
}

# Main loop: Retry on failure to keep add-on alive
while true; do
    echo "Launching VBAN stream..."
    stream_audio
    echo "Stream ended (exit code: $?); retrying in 5s..."
    sleep 5
done