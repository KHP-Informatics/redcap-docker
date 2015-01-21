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

6. NOTE: there is no default authentication, and access remains open. The default user is side_admin
    To fix there are a variety of Authentication options see:
    https://iwg.devguard.com/trac/redcap/wiki/ChangingAuthenticationMethod
    But the simplest is "Table Based" instructions for setting up are below:

    * How to change from "None (Public)" to "Table-based" authentication

    * Before simply changing the authentication method, you will first need to create for yourself a new Table-based user that you yourself will use to log in to REDCap. Navigate to the Create New User page in the Control Center and create a new user (you will have to decide what your username will be). Once created, it will send an email to you with your username and a temporary password enclosed.
    * Before looking in your inbox, go to the Designate Super User page in the Control Center and add your user as a super user. This ensures that you will be able to access the Control Center again when you log in with your new Table-based user in a minute.
    * Now go to the Security & Authentication page in the Control Center and change the authentication method to Tabled-based (at top of page) and save your changes on that page. Now click on any link/tab on the page, which will now force you to log in with your new Table-based username.
    * Log in to REDCap with your new username and the password sent to you in the email. It will then ask you to set your password.
    Now that you have logged in with your new username, go back to the Designate Super User page and remove "site_admin" as a super user.
    * You're done and can now go and begin giving other users access to REDCap by creating them a username on the Create New User page.
    * You will also be required to change the Project Settings from "Public" to "Table Based" (in Control Centre>>Edit a PRoject's Settings)

7. You may want to also add some custom validations e.g. uk_postcode. (login to the mysql container (either with a mysql client either external or via docker-exec))
    * INSERT INTO `redcap_validation_types` (validation_name, validation_label, regex_js, regex_php, data_type, legacy_value, visible) VALUES ('uk_postcode', 'uk_postcode', '/^[A-Z]{1,2}\d{1,3}[ \t]+\d{1,2}[A-Z]{2}$/i', '/^[A-Z]{1,2}\d{1,3}[ \t]+\d{1,2}[A-Z]{2}$/i', 'text', \N , '1');
    * Should give you:
    validation_name: uk_postcode
    validation_label: UK Postcode
    regex_js: /^[A-Z]{1,2}\d{1,3}[ \t]+\d{1,2}[A-Z]{2}$/i
    regex_php: /^[A-Z]{1,2}\d{1,3}[ \t]+\d{1,2}[A-Z]{2}$/i
    data_type: text
    legacy_value: NULL
    visible: 1




![Kings Health Partners](figures/brc-u-logos/KHP_M_oneline_descriptor_strapline_hr_CMYK-e1409244956134.jpg)
