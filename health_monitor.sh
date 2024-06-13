#!/bin/bash

LOG_FILE="/var/log/system_health.log"
PID_FILE="/var/run/health_monitor.pid"
INTERVAL=60

# Thresholds
CPU_THRESHOLD=80
MEM_THRESHOLD=80
DISK_THRESHOLD=80

# Start monitoring
start_monitoring() {
    if [ -f "$PID_FILE" ]; then
        echo "Monitoring is already running."
        exit 1
    fi

    echo $$ > "$PID_FILE"
    echo "Monitoring started with PID $$"

    while true; do
        monitor
        sleep $INTERVAL
    done
}

# Stop monitoring
stop_monitoring() {
    if [ -f "$PID_FILE" ]; then
        PID=$(cat "$PID_FILE")
        kill "$PID"
        rm -f "$PID_FILE"
        echo "Monitoring stopped."
    else
        echo "Monitoring is not running."
    fi
}

# Check monitoring status
status_monitoring() {
    if [ -f "$PID_FILE" ]; then
        PID=$(cat "$PID_FILE")
        if ps -p "$PID" > /dev/null; then
            echo "Monitoring is running with PID $PID."
        else
            echo "Monitoring is not running, but PID file exists."
        fi
    else
        echo "Monitoring is not running."
    fi
}

# Monitor system health
monitor() {
    TIMESTAMP=$(date "+%Y-%m-%d %H:%M:%S")

    # CPU Usage
    CPU_USAGE=$(top -bn1 | grep "Cpu(s)" | awk '{print $2 + $4}')
    CPU_USAGE_INT=${CPU_USAGE%.*}
    if [ "$CPU_USAGE_INT" -ge "$CPU_THRESHOLD" ]; then
        CPU_WARNING="Warning: High CPU usage - ${CPU_USAGE}%"
    else
        CPU_WARNING=""
    fi

    # Memory Usage
    MEM_USAGE=$(free | grep Mem | awk '{print $3/$2 * 100.0}')
    MEM_USAGE_INT=${MEM_USAGE%.*}
    if [ "$MEM_USAGE_INT" -ge "$MEM_THRESHOLD" ]; then
        MEM_WARNING="Warning: High Memory usage - ${MEM_USAGE}%"
    else
        MEM_WARNING=""
    fi

    # Disk Usage
    DISK_USAGE=$(df / | grep / | awk '{ print $5}' | sed 's/%//g')
    if [ "$DISK_USAGE" -ge "$DISK_THRESHOLD" ]; then
        DISK_WARNING="Warning: High Disk usage - ${DISK_USAGE}%"
    else
        DISK_WARNING=""
    fi

    # Network Connectivity
    ping -c 1 google.com > /dev/null 2>&1
    if [ $? -eq 0 ]; then
        NETWORK_STATUS="Network: Connected"
    else
        NETWORK_STATUS="Network: Disconnected"
    fi

    # Log system health
    echo "$TIMESTAMP - CPU: ${CPU_USAGE}% ${CPU_WARNING}, Memory: ${MEM_USAGE}% ${MEM_WARNING}, Disk: ${DISK_USAGE}% ${DISK_WARNING}, ${NETWORK_STATUS}" >> "$LOG_FILE"
}

# Main script functionality
case "$1" in
    start)
        start_monitoring
        ;;
    stop)
        stop_monitoring
        ;;
    status)
        status_monitoring
        ;;
    *)
        echo "Usage: $0 {start|stop|status}"
        exit 1
        ;;
esac
