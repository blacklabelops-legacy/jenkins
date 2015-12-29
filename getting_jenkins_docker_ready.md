# Getting Jenkins Cloud Ready

Jenkins is a continuous integration tool for software development. You can define jobs, integration and deployment and schedule their execution. It's one of the most important tools in software development. The developer does not have to wait for a feedback but will be informed with detailed infos on how his new feature has fared inside the environments.

Jenkins tend to get bulky in time. Projects have to set up their unique demands, e.g. software versions and installations (Java 6-8, Tomcat, JBoss, Websphere).  As a result, a master-slave setup can ease the complexity of setting up Jenkins but setting up the master-slave environment itself remains.

The perfect solution is the cloud where you can setup any complex environment with containers and setup templates. Especially the Google Compute Engine looks interesting as you pay for use and you do not have any setup costs.

Therefore, I aim to define a setup template for cloud deployment and then explode my setup into the cloud. Which means setting up a secure Jenkins master with a scalable amount of build slaves. This will enable teams to setup a build environment per project rather than per team or company. The setup can be deployed and removed on demand and enable indefinite staging environments for software development.

The first step is building the appropriate cloud container using Docker. Docker is a container framework where you setup applications inside a linux container and being able to fire it up in any cloud environment. Jenkins is by its history an on-premise solution and setup is usually done by hand. A Jenkins instance is not by default able for deploy-and-use inside the cloud. Appropriate means:

* The container must include a ready-to-use Jenkins.
* The container must have a default security setup.
* The container must accept slave connections.
* The container must support backup & restore.

In my Github repository and project [blacklabelops/jenkins](https://github.com/blacklabelops/jenkins) I implemented a cloud-ready Jenkins master inside a Docker container. The project has elaborate documentation, feel free to roam and try it out. Managing Jenkins inside Docker required the following steps:

1. Setting up a Dockerfile that installs Jenkins, Java and required software packages.
1. Extending the Dockerfile by configuring Jenkins to use my pre-defined Docker Volume for persisting its settings and using it as the default workfolder.
1. As a result I could write bash scripts in order to backup & restore the Docker Volume. Now I was able to resume my immutable container in any state.
1. Define environment variables to be able to configure my container for specific use cases. Being able to control security setup, ports for slave connection and plugin installations.
1. Environment variables are interpreted at startup and they use the docker-entrypoint script for applying their intend. The script itself is hooked inside the Dockerfile.
1. Implementing several Groovy Scripts to execute the settings inside Jenkins, e.g. settings for security and the java virtual machine. Blacklabelops Groovy Scripts.

The container is build and deployed by the public Docker registry Docker Hub and checked by Continuous Integration by Circle-CI. Docker Hub and Circle-CI are free for public Github Repositories. You can always check my repository for the current state of my project as build badges provide a good overview of my implementation state.

