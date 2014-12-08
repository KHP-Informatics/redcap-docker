#------------------------------------------------------------------------------
# Dockerized Redcap for deploying in a variety of environments
#------------------------------------------------------------------------------

#The Containers in the System:
# 1) [base: tutum/apache-php] <-- Redcap
# 2) [base: /mysql] 


#------------------------------------------------------------------------------
# Redcap Container
#------------------------------------------------------------------------------

MAINTAINER Amos Folarin <amosfolarin@gmail.com>

FROM tutum/apache-php


