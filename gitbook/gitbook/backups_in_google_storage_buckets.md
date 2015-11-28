# Backups in Google Storage Buckets

You can periodically create backups and upload them to your [Google Storage Bucket](https://cloud.google.com/storage/).

Full documentation of the backup container can be found hee: [blacklabelops/gcloud](https://github.com/blacklabelops/gcloud)

First fire up the Jenkins master:

~~~~
$ docker run -d -p 8090:8080 --name jenkins blacklabelops/jenkins
~~~~

Then start and attach the [blacklabelops/gcloud](https://github.com/blacklabelops/gcloud) container!

The required example crontab can be found here: [example-crontab-backup.txt](https://github.com/blacklabelops/gcloud/blob/master/example-crontab-backup.txt)

~~~~
$ docker run \
  --volumes-from jenkins \
  -v $(pwd)/backups/:/backups \
  -v $(pwd)/logs/:/logs \
  -e "GCLOUD_ACCOUNT=$(base64 auth.json)" \
  -e "GCLOUD_CRON=$(base64 example-crontab-backup.txt)" \
  blacklabelops/gcloud
~~~~

> Uses the authentication file auth.json and executed the crontab th°°at uploads archives to the specified cloud bucket. Logs and
backups are available locally.
