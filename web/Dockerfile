#------------------------------------------------------------------------------
# Dockerized Redcap for deploying in a variety of environments
#------------------------------------------------------------------------------

#The Containers in the System:
# 1) [base: tutum/apache-php] <-- Redcap
# 2) [base: /mysql] 


#------------------------------------------------------------------------------
# Redcap Container
# build from inside the ./build dir see README.md
#------------------------------------------------------------------------------

FROM tutum/apache-php

MAINTAINER Amos Folarin <amosfolarin@gmail.com>

# redcap web-application
COPY ./download/redcap /app/redcap


# Runtime sensitive information provided as [--env, --env-file] environment variables,
# which are processed by parse_redcap_config.sh into the database.php file
# control is then passed to the run.sh script
COPY ./parse_redcap_config.sh /app
ENTRYPOINT [/app/parse_redcap_config.sh]


