# Vagrant

Vagrant is fabulous tool for pulling and spinning up virtual machines like docker with containers. I can configure my development and test environment and simply pull it online. And so can you! 

First install:

* [Vagrant](https://www.vagrantup.com/)
* [Virtualbox](https://www.virtualbox.org/)

Change into the project folder and build the project on the spot!

~~~~
$ vagrant up
$ vagrant ssh
[vagrant@localhost ~]$ cd /vagrant
[vagrant@localhost ~]$ docker-compose up
~~~~

> Jenkins will be available on localhost:9200 on the host machine.

Vagrant does not leave any docker artifacts on your beloved desktop and the vagrant image can simply be destroyed and repulled if anything goes wrong. Test my project to your heart's content!