# Container Permissions

Simply: You can set user-id and group-id matching to a user and group from your host machine!

Due to security considerations this image is not running in root mode! The Jenkins process user inside the container is `jenkins` and the user's group is `jenkins`. This project offers a simplified mechanism for user- and group-mapping. You can set the uid of the user and gid of the user's group during build time.

The process permissions are relevant when using volumes and mounted folders from the host machine. Jenkins need read and write permissions on the host machine. You can set UID and GID of the Jenkin's process during build time! UID and GID should resemble credentials from your host machine.

The following build arguments can be used:

* CONTAINER_UID: Set the user-id of the Jenkins process. (default: 1000)
* CONTAINER_GID: Set the group-id of the Jenkins process. (default: 1000)

Example:

~~~~
$ docker build --build-arg CONTAINER_UID=2000 --build-arg CONTAINER_GID=2000 -t jenkins .
~~~~

> The container will write and read files with UID 2000 and GID 2000.
