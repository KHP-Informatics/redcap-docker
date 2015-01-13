#!/bin/bash

#run cron with the crontab that is bind-mounted cron-conf/crontab
set -e
if [[ ! -e /app/cron-conf/crontab ]]; then
	echo "Setting up crontab with /app/cron-conf/crontab"
	crontab /app/cron-conf/crontab
fi
