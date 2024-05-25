#!/bin/bash

# Set the domain you want to monitor
DOMAIN="welingkar.org"

# Set the duration for capturing traffic in seconds
DURATION=60

# Set the path for the tcpdump output file
OUTPUT_FILE="/tmp/tcpdump_output.txt"

# Run tcpdump to capture traffic for the specified domain
sudo tcpdump -i any -s 0 -w "$OUTPUT_FILE" "host $DOMAIN" &
TCPDUMP_PID=$!

# Sleep for the specified duration
sleep "$DURATION"

# Stop tcpdump
sudo kill -s SIGINT "$TCPDUMP_PID"

# Analyze the captured data and calculate total traffic
TOTAL_BYTES=$(tcpdump -tttt -n -r "$OUTPUT_FILE" 2>/dev/null | awk '{ total += $NF } END { print total }')

# Convert bytes to megabytes for readability
TOTAL_MB=$(echo "scale=2; $TOTAL_BYTES / (1024 * 1024)" | bc)

echo "Total network traffic for $DOMAIN in the last $DURATION seconds: ${TOTAL_MB}MB"

# Clean up - remove the tcpdump output file
rm -f "$OUTPUT_FILE"

