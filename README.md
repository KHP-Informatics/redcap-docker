#REDCAP DOCKER BUILD
[Funded by Biomedical Research Centre](http://core.brc.iop.kcl.ac.uk): http://core.brc.iop.kcl.ac.uk

*Institution: NIHR Maudsley Biomedical Research Centre For Mental Health and Dementia Unit (Denmark Hill), at The Institute of Psychiatry, Psychology & Neuroscience (IoPPN), Kings College London* 

Author(s): Amos Folarin

Release Version:

## Redcap Dockerfile
These can and should be deployable relatively simply in any environment running Docker.

## Distributing Docker Image
I'm not making a public image of this available on DockerHub, the licence for RedCap precludes this.
Instead, if you want to use this building it from the docker files is straightforward, see below. 
You will need to get the web application from the redcap project at http://www.project-redcap.org/ 
and unzip it in to web/download/ dir.

## Build Instructions
There are two components the database and the redcap web application.
### Build containers locally from the Dockerfiles

1) cd into the web/ or db/ dir so we have the right build context:
```
    $ cd db
    $ docker build --tag="afolarin/redcap:mysql" .
    $ cd ../web
    $ docker build --tag="afolarin/redcap:webapp" .
    #NOTE you can substitute the afolarin for your repo
```

### Run the containers
1) Start the database. This is based on Tutum's mysql image.
    https://github.com/tutumcloud/tutum-docker-mysql
    https://registry.hub.docker.com/u/tutum/mysql/
```
    #start the db container (default mounts vol /etc/mysql and /var/lib/mysql in volumes)
    $ docker run --name="redcap-db" -d -p 3306:3306 afolarin/redcap:mysql
    
    #ALT: or if you need to bind the mysql data dir (/path/in/host) to a host dir use (see tutum docs):
    $ docker run -d -v /path/in/host:/var/lib/mysql afolarin/redcap:mysql /bin/bash -c "/usr/bin/mysql_install_db"
    $ docker run --name="redcap-db" -d -p 3306:3306 -v /path/in/host:/var/lib/mysql afolarin/redcap:mysql

    #get the random mysql admin pwd
    $ docker logs redcap-db &> mysql.pwd
```

2) Start the webapplication, this will link to the MySQL database container. It is based on Tutum's 
    Apache-PHP image.
    https://github.com/tutumcloud/tutum-docker-php
    https://registry.hub.docker.com/u/tutum/apache-php/
```
    $ docker run --name="redcap-web" --link="redcap-db:REDCAP_DB" -d -p 80:80 afolarin/redcap:webapp
```

### Installation
point the browser to 
localhost:80/redcap/install.php
follow instructions

Create the MYSQL USER
1) connect to the mysql server, create database, create user and grant specific privilages
```
mysql -h172.17.0.10 -uadmin -p'pwd-in-mysqsl.pwd'
CREATE DATABASE redcap;
CREATE USER 'redcap_admin'@'%' IDENTIFIED BY 'your-password';
GRANT CREATE,SELECT,INSERT,UPDATE,DELETE ON redcap.* TO 'redcap_admin'@'%';
```

Edit the database.php
1) Inject a process into the running redcap-web container
```
$ docker exec -it redcap-web /bin/bash
root@redcap-web:/app/redcap$ vi database.php
edit:
hostname       = 'see-docker-inspect-redcap-db';
$db             = 'redcap';
$username       = 'redcap_admin';
$password       = 'your-password';

SALT VARIABLE:
$salt = 'xxxxxxx';
```
Hit refresh on the browser

2) Complete the registration.

3) Check everything works? Create a test project

4) Commit the image








![Kings Health Partners](figures/brc-u-logos/KHP_M_oneline_descriptor_strapline_hr_CMYK-e1409244956134.jpg)
