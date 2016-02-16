# Custom Container Logging

## Jenkins Logging

This container does not write a logfile by default. It's considered bad practise as logs
should be accessed by the command `docker logs`. There are use case where you want to
have additional log files, e.g. my use case is to relay log to Loggly [Loggly Homepage](https://www.loggly.com/).
I have added a routine for logging and it's activated by defining a logfile.

Environment Variable: LOG_FILE

Example for a separate volume with a logfile:

~~~~
$ docker run -d -p 8090:8080 \
  -v $(pwd)/logs:/jenkinslogs \
  -e "LOG_FILE=/jenkinslogs/jenkins.log" \
  --name jenkins \
  blacklabelops/jenkins
~~~~

> You can watch the log by typing `cat ./logs/jenkins.log`.

## Logging with Loggly

Now lets hook up the container with my Loggly side-car container and relay the log to Loggly! The Full
documentation of the loggly container can be found here: [blacklabelops/loggly](https://github.com/blacklabelops/fluentd/tree/master/fluentd-loggly)

~~~~
$ docker run -d \
  --volumes-from jenkins \
  -e "LOGS_DIRECTORIES=/jenkinslogs" \
	-e "LOGGLY_TOKEN=3ere-23kkke-23j3oj-mmkme-343" \
  -e "LOGGLY_TAG=jenkinslog" \
  --name jenkinsloggly \
  blacklabelops/loggly
~~~~

> Note: You need a valid Loggly Customer Key in order to log to Loggly.
