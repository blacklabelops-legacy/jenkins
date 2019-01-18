# Dockerized Jenkins

## Supported tags and respective Dockerfile links

| Distribution | Version      | Tag          | Dockerfile |
|--------------|--------------|--------------|------------|
| Alpine | 2.141 | latest, 2.141 | [Dockerfile](https://github.com/blacklabelops/jenkins/blob/master/Dockerfile) |
| Alpine | stable 2.121.3 | 2.121.3 | [Dockerfile](https://github.com/blacklabelops/jenkins/blob/master/Dockerfile) |
| Alpine | release candidate | rc | [Dockerfile](https://github.com/blacklabelops/jenkins/blob/master/Dockerfile) |
| Alpine | stable release candidate | stable-rc | [Dockerfile](https://github.com/blacklabelops/jenkins/blob/master/Dockerfile) |

> Older tags remain but are not supported/rebuild.

# Make It Short

~~~~
$ docker run -d -p 80:8080 --name jenkins blacklabelops/jenkins
~~~~

# Passing Parameters

You can run the Jenkins solely with command line parameters!

Example:

~~~~
$ docker run \
     -d -p 8090:8080 \
     --name jenkins \
	   blacklabelops/jenkins --debug=9
~~~~

> Staring Jenkins with custom debug level.

Example list parameters:

~~~~
$ docker run --rm blacklabelops/jenkins --help
~~~~

> Lists jenkins plugin parameters.

Example printing Jenkins version:

~~~~
$ docker run --rm blacklabelops/jenkins --version
~~~~

> Prints the image's Jenkins version.

# Build Slaves

Build Slaves can be found here: [blacklabelops/swarm](https://github.com/blacklabelops/swarm)

# Manual

The detailed manual moved here:

* [Gitbook blacklabelops/jenkins](https://www.gitbook.com/book/blacklabelops/jenkins)
