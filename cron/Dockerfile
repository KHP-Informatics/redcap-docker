#------------------------------------------------------------------------------
# Dockerized Redcap for deploying in a variety of environments
#------------------------------------------------------------------------------

#The Containers in the System:
# 1) [afolarin/redcap:mysql] 
# 2) [afolarin/redcap:webapp]
# 3) [afolarin/redcap:cron]

# USAGE:
# docker run -d --name="redcap-cron" --volumes-from="redcap-web" afolarin/redcap:cron

#------------------------------------------------------------------------------
# Redcap Container
# build from inside the ./build dir see README.md
#------------------------------------------------------------------------------

FROM ubuntu

MAINTAINER Amos Folarin <amosfolarin@gmail.com>

# update
RUN apt-get update \
    && apt-get install -y cron

# command run cron for redcap
CMD ['/sbin/cron && /usr/bin/crontab -u root -l; echo "* * * * * /usr/bin/php /app/redcap/cron.php  > /dev/null" | /usr/bin/crontab -u root -']


