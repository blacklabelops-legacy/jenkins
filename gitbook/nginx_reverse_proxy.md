# NGINX Reverse Proxy

## NGINX HTTP Proxy

This is an example on running Jenkins behind NGINX with 2 Docker commands!

First start Jenkins:

~~~~
$ docker run -d --name jenkins \
    blacklabelops/jenkins
~~~~

> Note: Starting Jenkins without any port mapping.

Then start NGINX:

~~~~
$ docker run -d \
    -p 80:80 \
    --name nginx \
    --link jenkins:jenkins \
    -e "SERVER1REVERSE_PROXY_LOCATION1=/" \
    -e "SERVER1REVERSE_PROXY_PASS1=http://jenkins:8080/" \
    blacklabelops/nginx
~~~~

> Jenkins will be available at http://192.168.99.100.

## NGINX HTTPS Proxy

This is an example on running Jenkins behind NGINX-HTTPS with 2 Docker commands!

Note: This is a self-signed certificate! Trusted certificates by letsencrypt are supported. Documentation can be found here: [blacklabelops/nginx](https://github.com/blacklabelops/nginx)

First start Jenkins:

~~~~
$ docker run -d --name jenkins \
    blacklabelops/jenkins
~~~~

Then start NGINX:

~~~~
$ docker run -d \
    -p 443:443 \
    --name nginx \
    --link jenkins:jenkins \
    -e "SERVER1REVERSE_PROXY_LOCATION1=/" \
    -e "SERVER1REVERSE_PROXY_PASS1=hhttp://jenkins:8080/" \
    -e "SERVER1CERTIFICATE_DNAME=/CN=CrustyClown/OU=SpringfieldEntertainment/O=crusty.springfield.com/L=Springfield/C=US" \
    -e "SERVER1HTTPS_ENABLED=true" \
    -e "SERVER1HTTP_ENABLED=false" \
    blacklabelops/nginx
~~~~

> Jenkins will be available at https://192.168.99.100.