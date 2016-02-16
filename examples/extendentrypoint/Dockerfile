FROM blacklabelops/jenkins
MAINTAINER Your Name <your@email.com>

USER root
RUN echo "Install Your Tools"
USER jenkins

COPY custom-entrypoint.sh /home/jenkins/custom-entrypoint.sh
ENTRYPOINT ["/home/jenkins/custom-entrypoint.sh"]
CMD ["jenkins"]
