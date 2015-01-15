#REDCAP DOCKER BUILD
[Funded by Biomedical Research Centre](http://core.brc.iop.kcl.ac.uk): http://core.brc.iop.kcl.ac.uk

*Institution: NIHR Maudsley Biomedical Research Centre For Mental Health and Dementia Unit (Denmark Hill), at The Institute of Psychiatry, Psychology & Neuroscience (IoPPN), Kings College London* 

Author(s): Amos Folarin

Release Version:

## Redcap Dockerfiles
With these instructions you should be able to build the redcap-docker images
 can and should be deployable relatively simply in any environment running Docker.

## Distributing Docker Image
I'm not making a public image of this available on DockerHub, the licence for RedCap precludes this.
Instead, if you want to use this building it from the docker files is straightforward, see below. 
You will need:
1. clone the git repository https://github.com/KHP-Informatics/redcap-docker 
2. Get the web application from the redcap project at http://www.project-redcap.org/ 
and unzip it in to web/download/ dir
3. [optional]  Get the pdf fonts especially for international projects
https://iwg.devguard.com/trac/redcap/browser/misc/webtools2-pdf.zip?format=raw unzip webtools2-pdf.zip and 
place the pdf directory replacing the existing web/download/redcap/webtools2/pdf dir.


## Build instructions
There are three components the database and the redcap web application and the cron container.
### Build containers locally from the Dockerfiles

1. cd into the web/ or db/ dir so we have the right build context:
```
    $ cd db
    $ docker build --tag="afolarin/redcap:mysql" .
    $ cd ../web
    $ docker build --tag="afolarin/redcap:webapp" .
    #NOTE you can substitute the afolarin for your repo
```

### Run the containers
1. Start the database. This is based on Tutum's mysql image.
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

2. Start the webapplication, this will link to the MySQL database container. It is based on Tutum's 
    Apache-PHP image.
    https://github.com/tutumcloud/tutum-docker-php
    https://registry.hub.docker.com/u/tutum/apache-php/
```
    $ cd ../web
    docker run -d --name="redcap-web" -v $(pwd)/cron-conf/:/cron-conf/ --link="redcap-db:REDCAP_DB"  --env-file="env.list" --publish="80:80" afolarin/redcap:webapp
```

### Complete the installation via the browser
```
    #get the db host ip address listed in the redcap-docker/db/mysql.pwd file
    #point the browser to IP<port>/redcap/install.php , <port> req. if not port 80
    # e.g. http://172.17.0.12:<port>/redcap/install.php
```

1. Complete the registration.

2. Exec SQL statements to create the database
	* Copy the statements from the browser
	* save in a file e.g. redcap-tables.sql
	* $ mysql -h<see-docker-inspect> -uadmin -p'pwd-in-mysqsl.pwd' redcap < redcap-tables.sql
	**NOTE**: don't try to paste these sql statements into the terminal, it's pretty fragile. \
	Pipe it instead as above. Or even better this little trick \
	(docker exec -i redcap-db mysql -uadmin -padminDbUserPwd) < redcap-db-build.sql

3. Check everything works? 
	* see config testpage: http://<IP:PORT>/redcap/redcap_v6.0.12/ControlCenter/check.php?upgradeinstall=1
	* goto http://<IP:PORT>/redcap 
	* go to "Control Centre>>File Upload Settings>>SET LOCAL FILE STORAGE LOCATION:" set to /edocs \
	(you can change folder, but it should not be web accessible)
	* Create a test project

4. Commit the image, for your future use, DO NOT PUBLISH IMAGE redcap is not opensource!

5. Use these images to deploy your redcap instances (remember to push in a new password for each client)





![Kings Health Partners](figures/brc-u-logos/KHP_M_oneline_descriptor_strapline_hr_CMYK-e1409244956134.jpg)
