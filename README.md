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
There are three components the database and the redcap web application and the cron container.
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
    
    #wait till the container is created then get some information required for the redcap-docker/web/env.list file
    $ docker logs redcap-db &> mysql.pwd;
    $ docker inspect --format='{{.NetworkSettings.IPAddress}}' redcap-db &>> mysql.pwd;
    $ docker inspect --format='{{.NetworkSettings.Ports}}' redcap-db &>> mysql.pwd;
    
    #add the random generated password to the env file
    $ cat mysql.pwd
    $ vi ../web/env.list
    # change the MYSQL_PASS='' to the file password listed in mysql.pwd
```

2) Start the webapplication, this will link to the MySQL database container. It is based on Tutum's 
    Apache-PHP image.
    https://github.com/tutumcloud/tutum-docker-php
    https://registry.hub.docker.com/u/tutum/apache-php/
```
    $ cd ../web
    $ docker run --name="redcap-web" --link="redcap-db:REDCAP_DB" -d -p 80:80 afolarin/redcap:webapp
```

### Installation
```
    #get the db host ip address listed in the redcap-docker/db/mysql.pwd file
    #point the browser to IP<port> if not port 80
    # e.g. http://172.17.0.12:<port>/redcap/install.php
```

follow instructions, change desired parts:

1) Complete the registration.

2) Exec SQL statements to create the database
2.1) Copy the statements from the browser
2.2) save in a file e.g. redcap-tables.sql
2.3) $ mysql -h<see-docker-inspect> -uadmin -p'pwd-in-mysqsl.pwd' redcap < redcap-tables.sql
NOTE: don't try to paste these sql statements into the terminal, it's pretty fragile. Pipe it instead as above.

4) Check everything works? 
4.1) see config testpage: http://localhost/redcap/redcap_v6.0.12/ControlCenter/check.php?upgradeinstall=1
4.2) Create a test project

5) Commit the image, DO NOT PUBLISH IMAGE not opensource!

6) Use these images to deploy your redcap instances (remember to push in a new password for each client)





![Kings Health Partners](figures/brc-u-logos/KHP_M_oneline_descriptor_strapline_hr_CMYK-e1409244956134.jpg)
