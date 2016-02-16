# Backups with rsnapshot

You can create automatic backups using [blacklabelops/rsnapshotd](https://github.com/blacklabelops/rsnapshot/tree/master/rsnapshot-cron).
This side-car container uses rsnapshot to create snapshots of your jenkins volume periodically.

Full documentation can be found here:  [blacklabelops/rsnapshotd](https://github.com/blacklabelops/rsnapshot/tree/master/rsnapshot-cron)

First fire up the Jenkins master:

~~~~
$ docker run -d -p 8090:8080 --name jenkins blacklabelops/jenkins
~~~~

Then start and attach the side-car backup container:

~~~~
$ docker run -d \
  --volumes-from jenkins \
	-v $(pwd)/snapshots/:/snapshots \
  -e "CRON_HOURLY=* * * * *" \
	-e "BACKUP_DIRECTORIES=/jenkins/ jenkins/" \
	blacklabelops/rsnapshotd
~~~~

> Mounts all volumes from the running container and snapshots the volume /jenkins inside the local
snapshot directory under `jenkins/`. Note: If you use Windows then you will have to replace $(pwd)
with an abolute path.
