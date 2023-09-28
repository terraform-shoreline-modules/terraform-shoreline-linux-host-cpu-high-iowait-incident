
### About Shoreline
The Shoreline platform provides real-time monitoring, alerting, and incident automation for cloud operations. Use Shoreline to detect, debug, and automate repairs across your entire fleet in seconds with just a few lines of code.

Shoreline Agents are efficient and non-intrusive processes running in the background of all your monitored hosts. Agents act as the secure link between Shoreline and your environment's Resources, providing real-time monitoring and metric collection across your fleet. Agents can execute actions on your behalf -- everything from simple Linux commands to full remediation playbooks -- running simultaneously across all the targeted Resources.

Since Agents are distributed throughout your fleet and monitor your Resources in real time, when an issue occurs Shoreline automatically alerts your team before your operators notice something is wrong. Plus, when you're ready for it, Shoreline can automatically resolve these issues using Alarms, Actions, Bots, and other Shoreline tools that you configure. These objects work in tandem to monitor your fleet and dispatch the appropriate response if something goes wrong -- you can even receive notifications via the fully-customizable Slack integration.

Shoreline Notebooks let you convert your static runbooks into interactive, annotated, sharable web-based documents. Through a combination of Markdown-based notes and Shoreline's expressive Op language, you have one-click access to real-time, per-second debug data and powerful, fleetwide repair commands.

### What are Shoreline Op Packs?
Shoreline Op Packs are open-source collections of Terraform configurations and supporting scripts that use the Shoreline Terraform Provider and the Shoreline Platform to create turnkey incident automations for common operational issues. Each Op Pack comes with smart defaults and works out of the box with minimal setup, while also providing you and your team with the flexibility to customize, automate, codify, and commit your own Op Pack configurations.

# Host CPU high iowait incident.
---

A Host CPU high iowait incident occurs when the CPU iowait is greater than 10%, indicating that the system is disk or network bound. This can cause performance issues and may require investigation to identify the root cause and resolve the issue.

### Parameters
```shell
export INTERVAL="PLACEHOLDER"

export COUNT="PLACEHOLDER"

export DURATION="PLACEHOLDER"

export PORT="PLACEHOLDER"

export INTERFACE="PLACEHOLDER"

export DISK_NAME="PLACEHOLDER"

export DIRECTORY_PATH="PLACEHOLDER"

export DAYS_MODIFIED="PLACEHOLDER"
```

## Debug

### Check CPU usage by process
```shell
top
```

### Check I/O usage by process
```shell
iotop
```

### Check disk I/O statistics
```shell
iostat -x ${INTERVAL} ${COUNT}
```

### Check network I/O statistics
```shell
ifstat ${INTERVAL} ${COUNT}
```

### Check for high disk utilization by process
```shell
sudo pidstat -d ${INTERVAL} ${COUNT}
```

### Check for high network utilization by process
```shell
sudo tcpdump -i ${INTERFACE} -nn -s0 -v port ${PORT} -w tcpdump.pcap &

sudo timeout ${DURATION} sudo tcpdump -i ${INTERFACE} -nn -s0 -v port ${PORT}

sudo killall tcpdump
```

### Insufficient disk I/O throughput causing the CPU to wait for data to be read or written to the disk.
```shell


#!/bin/bash



# Define variables

IOWAIT_THRESHOLD=10

DISK_NAME=${DISK_NAME}



# Get current iowait percentage

IOWAIT=$(iostat -c | awk '/^ /{print $4}')



# Check if iowait is above threshold

if (( $(echo "$IOWAIT > $IOWAIT_THRESHOLD" | bc -l) )); then

    # Get current disk I/O throughput

    DISK_IO=$(iostat -x 1 2 | awk '/'$DISK_NAME'/{getline; print $6}')



    # Check if disk I/O is below threshold

    if (( $(echo "$DISK_IO < 100" | bc -l) )); then

        echo "Disk I/O throughput is insufficient. Current value: $DISK_IO"

    else

        echo "Iowait is high, but disk I/O throughput is not the issue."

    fi

else

    echo "Iowait is normal."

fi


```

## Repair

### Increase the available disk space by deleting unnecessary files or adding more storage capacity.
```shell
bash

#!/bin/bash



# Set variables

TARGET_DIR=${DIRECTORY_PATH}
DAYS_MODIFIED=${DAYS_MODIFIED}


# Delete unnecessary files

sudo find $TARGET_DIR -type f -name "*.log" -ctime $DAYS_MODIFIED -delete



# Check available disk space

df -h $TARGET_DIR


```