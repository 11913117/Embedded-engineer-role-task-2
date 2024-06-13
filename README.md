# Embedded-engineer-role-task-2

# System Health Monitoring Script

## Description
This script monitors and reports the system's health status by collecting CPU usage, memory usage, disk space, and network connectivity metrics. It performs checks every 60 seconds and generates warnings if metrics exceed predefined thresholds. The results are logged to a file.

## Usage
### Starting the Monitoring
To start monitoring, run:
```sh
sudo ./health_monitor.sh start

## Stopping the Monitoring
To stop monitoring, run:

sudo ./health_monitor.sh stop

## Checking Monitoring Status
To check if the monitoring is running, run:

sudo ./health_monitor.sh status

## Configuration
You can configure the threshold values for CPU, memory, and disk usage by editing the script and changing the values of CPU_THRESHOLD, MEM_THRESHOLD, and DISK_THRESHOLD variables.

CPU_THRESHOLD=80
MEM_THRESHOLD=80
DISK_THRESHOLD=80

## Log File
The script logs the system health status to /var/log/system_health.log.

## Requirements
The script must be run with root privileges to access system metrics and write to the log file and PID file.


### Evaluation Criteria
1. **Accuracy of Metrics:** The script correctly collects CPU, memory, disk usage, and network connectivity status.
2. **Script Efficiency:** The script runs every 60 seconds without unnecessary overhead.
3. **Alert Mechanism:** Warnings are generated and included in the log if thresholds are exceeded.
4. **Logging Quality:** Each interval's system status is logged with a timestamp.
5. **Command Functionality:** The script includes commands for starting, stopping, and checking the status of the monitoring process.
