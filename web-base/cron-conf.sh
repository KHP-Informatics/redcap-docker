#!/bin/bash

#run cron with the crontab that is bind-mounted cron-conf/crontab
echo "Setting up crontab with /app/cron-conf/crontab"
crontab /app/cron-conf/crontab
