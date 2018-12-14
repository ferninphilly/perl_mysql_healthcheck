# Healthchecker for MYSQL written in PERL and Docker

## What it does

Basically just what it says- it will open a connection to a mysql instance on the localhost...then close it. If the mysql instance becomes unreachable for any reason then it will exit with a code 1. It will log the results of the attempt to the **./logs** directory in a new file. It will clean this up on every start up.

### Change your variables

Most of the code is controlled through environment variables in the Dockerfile. Currently the default setting is for the localhost on a mac...but assuming you aren't deploying to a mac server you might want to change that. For a linux server you can use **172.17.0.1**...although you could also use **localhost** as the host environment variable IF you are using the `--net=host` option in the `docker run` command...which I'll go into below.  

### How to boot it up

So once you have the dockerfile on your server (assuming that docker is already installed) you need to: 

1. `cd` into the root directory here.
2. run `docker build -t mysqlhealth .`
3. Verify that the container has been built: `docker ps -a`
4. Now run it with a `docker run -ti -d --net=host -v $PWD/logs:/usr/src/healthcheck/logs mysqlhealth:latest`
5. If you want to update the code from within the container: `docker run -ti --net=host -v $PWD/logs:/usr/src/healthcheck/logs mysqlhealth:latest \bin\bash`

### Couple of other things

There is a file cleanup here- so if we get more than 100 files in the **logs** directory it will delete them all. This is if we want to run it every 30 seconds or whatever. 