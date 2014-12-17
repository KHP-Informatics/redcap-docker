#!/bin/bash

#------------------------------------------------------------------------------
# DESC: 
# Setup config (mostly hooking up the database container and processing
# some additional server reqirements of redcap) then execute the CMD transparently:

# AUTHOR: Amos Folarin <amosfolarin@gmail.com>

# USAGE: 
# [ENTRYPOINT] [CMD]
# parse_redcap_config.sh "/run.sh"
#------------------------------------------------------------------------------

#ENTRYPOINT param parsing for RedCap Container

#CMD to be run after config has been done
CMD=${1}


#LASTLY: execute the docker run CMD now, standup apache.
./$CMD

env
/bin/bash
