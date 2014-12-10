#------------------------------------------------------------------------------
# Dockerized Redcap for deploying in a variety of environments
#------------------------------------------------------------------------------

#The Containers in the System:
# 1) [base: tutum/apache-php] <-- Redcap
# 2) [base: /mysql] 


#------------------------------------------------------------------------------
# Database Container: MySQL
#------------------------------------------------------------------------------

FROM tutum/mysql

MAINTAINER Amos Folarin <amosfolarin@gmail.com>


# Use the /run.sh script to create the redcap_admin db user -- should be easy
# it may be necessary to remove the admin db user after all installation is done
# they are required for initial table creation otherwise drop add then drop
# CREAT grants for redcap_admin db user.


