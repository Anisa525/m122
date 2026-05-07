#!/bin/bash

. /home/anisa/crontab/env_cpu_temp

sleep 10
#[ -f ${log_file}_oldest ] && rm ${log_file}_oldest
[ -f ${log_file}_old ] && mv ${log_file}_old ${log_file}_oldest
[ -f ${log_file} ] && mv ${log_file} ${log_file}_old
