# How To Extend This Image

# Add Your Tooling

If you want to add your own tools and Dockerfile you will have to extend this image.

This is an minimal Dockerfile to extend to install this image but keep it capabilities:

~~~~
FROM blacklabelops/jenkins
MAINTAINER Your Name <your@email.com>

USER root
RUN echo "Install Your Tools"
USER jenkins
~~~~

> Switches to user root in order to be able to install tools then goes back to regular image user.

# Write Your Own Entrypoint

You can also write your own entrypoint if you want to extend capabilities, scripts and such. I have prepared an example in repository folder: [examples/extendentrypoint](https://github.com/blacklabelops/jenkins/blob/master/examples/extendentrypoint/)

First extend the image in order to hook up your custom entrypoint.

This is an minimal Dockerfile to install and trigger your own Dockerfile:

~~~~
FROM blacklabelops/jenkins
MAINTAINER Your Name <your@email.com>

USER root
RUN echo "Install Your Tools"
USER jenkins

COPY custom-entrypoint.sh /home/jenkins/custom-entrypoint.sh
ENTRYPOINT ["/home/jenkins/custom-entrypoint.sh"]
CMD ["jenkins"]
~~~~

> Note: `custom-entrypoint.sh` is your own entrypoint script.

Your entrypoint must trigger the blacklabelops/jenkins entrypoint in order to keep the images functionality, e.g. environment variables.

Example `custom-entrypoint.sh`:

~~~~
#!/bin/bash

echo 'Your code here!'
exec /home/jenkins/docker-entrypoint.sh "$@"
~~~~
