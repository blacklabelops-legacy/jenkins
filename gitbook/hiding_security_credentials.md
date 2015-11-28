# Hiding Security Credentials

Hiding Environment Variables! This container can initialize with environment variables from a file.

* If you prefer specifying your default password inside a file rather then inside your docker-compose file.
* This way the password is also hidden from docker and the command **docker inspect**.
* You can reconfigure the container without removing the container.

The environment variable JENKINS_ENV_FILE tells the entryscript where to find the environment variables.

Example:

~~~~~

~~~~

How do you get the file inside the container?

* Use the command **docker cp** in order to copy the file inside an already initialized container.
* Extend the container with a new Dockerfile. Example can be found here: [Example-Dockerfile](https://github.com/blacklabelops/jenkins/blob/master/extension/Dockerfile)
* Put the file inside a data-container and mount it with the **--volumes-from** directive.