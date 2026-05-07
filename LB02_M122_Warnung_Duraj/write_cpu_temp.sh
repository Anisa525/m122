#!/bin/bash

. /home/anisa/crontab/env_cpu_temp

cpu=$(cat /sys/class/thermal/thermal_zone0/temp)
cpu=$(( cpu / 1000 ))

ts=$(date '+%d.%m.%y %H:%M:%S')

if [ "$cpu" -lt 55 ]; then 
    echo "${ts} cpu temperatur ist: ${cpu}°C" >> "$log_file"
else 
    echo "${ts} WARNUNG CPU TEMPERATUR ZU HOCH: ${cpu}°C" >> "$log_file"
fi

COUNT_FILE="/tmp/cpu_count"

if [ "$cpu" -ge 60 ]; then
    COUNT=$(cat "$COUNT_FILE" 2>/dev/null || echo 0)
    COUNT=$((COUNT + 1))
    echo "$COUNT" > "$COUNT_FILE"

    if [ "$COUNT" -ge 5 ]; then
        echo "$ts | KRITISCH: CPU seit 2,5 Stunden hoch!" >> "$log_file"
    fi
else
    echo 0 > "$COUNT_FILE"
fi

# RAM Check 
usage=$(awk '/MemTotal/ {t=$2} /MemAvailable/ {a=$2} END {printf "%.0f", (1 - a/t)*100}' /proc/meminfo)
ts2=$(date '+%d.%m.%y %H:%M:%S')

if [ "$usage" -ge 80 ]; then
    echo "$ts2 | WARNING : RAM usage at ${usage}%" >> "$log_file"
else
    echo "$ts2 | RAM usage : ${usage}%" >> "$log_file"
fi 


DISK=$(df / | awk 'NR==2 {print $5}' | sed 's/%//')

if [ "$DISK" -ge 90 ]; then
    echo "$ts | WARNUNG: Speicher fast voll (${DISK}%)" >> "$log_file"
else
    echo "$ts | Disk usage: ${DISK}%" >> "$log_file"
fi
