:title: Jumpstart Images

Jumpstart Images
================

.. contents::
    :local:


SSH-enabled Linux images
------------------------

These images are based on Docker base images, but have a SSH server installed and configure to run on startup. By default,
all SSH-based images generate a random ``root`` password on launch unless the environment variable ``ROOT_PASS`` is set.

Ubuntu Saucy (tutum/ubuntu-saucy)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Links: `Docker Index <https://index.docker.io/u/tutum/ubuntu-saucy/>`__ - `GitHub repo <https://github.com/tutumcloud/tutum-ubuntu/>`__

**Source Dockerfile**

.. sourcecode:: none

    FROM ubuntu:saucy
    MAINTAINER Fernando Mayo <fernando@tutum.co>

    # Install packages
    RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get -y install openssh-server pwgen
    RUN mkdir -p /var/run/sshd && sed -i "s/UsePrivilegeSeparation.*/UsePrivilegeSeparation no/g" /etc/ssh/sshd_config && sed -i "s/UsePAM.*/UsePAM no/g" /etc/ssh/sshd_config
    ADD set_root_pw.sh /set_root_pw.sh
    ADD run.sh /run.sh
    RUN chmod +x /*.sh

    EXPOSE 22
    CMD ["/run.sh"]

**Environment variables**

ROOT_PASS
    If set, the container will set the ``root`` account password to the specified value on launch

**Other versions available**

* Ubuntu Raring: `Link to Docker Index <https://index.docker.io/u/tutum/ubuntu-raring/>`__
* Ubuntu Precise: `Link to Docker Index <https://index.docker.io/u/tutum/ubuntu-precise/>`__
* Ubuntu Quantal: `Link to Docker Index <https://index.docker.io/u/tutum/ubuntu-quantal/>`__
* Ubuntu Lucid: `Link to Docker Index <https://index.docker.io/u/tutum/ubuntu-lucid/>`__


Centos 6.4 (tutum/centos-6.4)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Links: `Docker Index <https://index.docker.io/u/tutum/ubuntu-centos-6.4/>`__ - `GitHub repo <https://github.com/tutumcloud/tutum-centos/>`__

**Source Dockerfile**

.. sourcecode:: none

    FROM centos:6.4
    MAINTAINER Fernando Mayo <fernando@tutum.co>

    # Install packages and set up sshd
    RUN yum -y install openssh-server
    RUN ssh-keygen -q -N "" -t dsa -f /etc/ssh/ssh_host_dsa_key && ssh-keygen -q -N "" -t rsa -f /etc/ssh/ssh_host_rsa_key && sed -i "s/#UsePrivilegeSeparation.*/UsePrivilegeSeparation no/g" /etc/ssh/sshd_config && sed -i "s/UsePAM.*/UsePAM no/g" /etc/ssh/sshd_config

    # Add scripts
    RUN rpm -i http://dl.fedoraproject.org/pub/epel/6/x86_64/pwgen-2.06-5.el6.x86_64.rpm
    ADD set_root_pw.sh /set_root_pw.sh
    ADD run.sh /run.sh
    RUN chmod +x /*.sh

    EXPOSE 22
    CMD ["/run.sh"]

**Environment variables**

ROOT_PASS
    If set, the container will set the ``root`` account password to the specified value on launch


Debian Wheezy (tutum/debian-wheezy)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Links: `Docker Index <https://index.docker.io/u/tutum/debian-wheezy/>`__ - `GitHub repo <https://github.com/tutumcloud/tutum-debian/>`__

**Source Dockerfile**

.. sourcecode:: none

    FROM debian:wheezy
    MAINTAINER Fernando Mayo <fernando@tutum.co>

    # Install packages
    RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get -y install openssh-server pwgen
    RUN mkdir -p /var/run/sshd && sed -i "s/UsePrivilegeSeparation.*/UsePrivilegeSeparation no/g" /etc/ssh/sshd_config
    ADD set_root_pw.sh /set_root_pw.sh
    ADD run.sh /run.sh
    RUN chmod +x /*.sh

    EXPOSE 22
    CMD ["/run.sh"]

**Environment variables**

ROOT_PASS
    If set, the container will set the ``root`` account password to the specified value on launch

**Other versions available**

* Debian Squeeze: `Link to Docker Index <https://index.docker.io/u/tutum/debian-squeeze/>`__


Fedora 20 (tutum/fedora-20)
^^^^^^^^^^^^^^^^^^^^^^^^^^^

Links: `Docker Index <https://index.docker.io/u/tutum/fedora-20/>`__ - `GitHub repo <https://github.com/tutumcloud/tutum-fedora/>`__

**Source Dockerfile**

.. sourcecode:: none

    FROM fedora:20
    MAINTAINER Fernando Mayo <fernando@tutum.co>

    # Install packages and set up sshd
    RUN yum -y install openssh-server pwgen
    RUN ssh-keygen -q -N "" -t dsa -f /etc/ssh/ssh_host_dsa_key && ssh-keygen -q -N "" -t rsa -f /etc/ssh/ssh_host_rsa_key && sed -i "s/#UsePrivilegeSeparation.*/UsePrivilegeSeparation no/g" /etc/ssh/sshd_config && ssh-keygen -q -N "" -t ecdsa -f /etc/ssh/ssh_host_ecdsa_key && sed -i "s/UsePAM.*/UsePAM no/g" /etc/ssh/sshd_config

    # Add scripts
    ADD set_root_pw.sh /set_root_pw.sh
    ADD run.sh /run.sh
    RUN chmod +x /*.sh

    EXPOSE 22
    CMD ["/run.sh"]

**Environment variables**

ROOT_PASS
    If set, the container will set the ``root`` account password to the specified value on launch


Databases and caches
--------------------

MySQL (tutum/mysql)
^^^^^^^^^^^^^^^^^^^
MySQL Server image - listens in port 3306. For the admin account password, either set ``MYSQL_PASS`` environment variable,
or check the logs for a randomly generated one.

Links: `Docker Index <https://index.docker.io/u/tutum/mysql/>`__ - `GitHub repo <https://github.com/tutumcloud/tutum-docker-mysql/>`__

**Source Dockerfile**

.. sourcecode:: none

    FROM ubuntu:saucy
    MAINTAINER Fernando Mayo <fernando@tutum.co>

    # Install packages
    RUN apt-get update
    RUN DEBIAN_FRONTEND=noninteractive apt-get -y install supervisor mysql-server pwgen

    # Add image configuration and scripts
    ADD start.sh /start.sh
    ADD run.sh /run.sh
    ADD supervisord-mysqld.conf /etc/supervisor/conf.d/supervisord-mysqld.conf
    ADD my.cnf /etc/mysql/conf.d/my.cnf
    ADD create_mysql_admin_user.sh /create_mysql_admin_user.sh
    ADD import_sql.sh /import_sql.sh
    RUN chmod 755 /*.sh

    EXPOSE 3306
    CMD ["/run.sh"]

**Environment variables**

MYSQL_PASS
    If set, the container will set the ``admin`` account password to the specified value on launch


Redis (tutum/redis)
^^^^^^^^^^^^^^^^^^^
Redis Docker image image – listens in port 6379. For the server password, either set ``REDIS_PASS`` environment variable or
read the logs for a randomly generated one

Links: `Docker Index <https://index.docker.io/u/tutum/redis/>`__ - `GitHub repo <https://github.com/tutumcloud/tutum-docker-redis/>`__

**Source Dockerfile**

.. sourcecode:: none

    FROM ubuntu:quantal
    MAINTAINER Fernando Mayo <fernando@tutum.co>

    RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv C7917B12
    RUN echo "deb http://ppa.launchpad.net/chris-lea/redis-server/ubuntu quantal main" >> /etc/apt/sources.list
    RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get -y upgrade && DEBIAN_FRONTEND=noninteractive apt-get install -y redis-server pwgen

    # Add scripts
    ADD run.sh /run.sh
    ADD set_redis_password.sh /set_redis_password.sh
    RUN chmod 755 /*.sh

    EXPOSE 6379
    CMD ["/run.sh"]

**Environment variables**

REDIS_PASS
    If set, the container will set the ``admin`` account password to the specified value on launch


MongoDB (tutum/mongodb)
^^^^^^^^^^^^^^^^^^^^^^^
MongoDB Docker image – listens in port 27017. For the admin password, either set ``MONGODB_PASS`` environment variable or
check the logs for a randomly generated one

Links: `Docker Index <https://index.docker.io/u/tutum/mongodb/>`__ - `GitHub repo <https://github.com/tutumcloud/tutum-docker-mongodb/>`__

**Source Dockerfile**

.. sourcecode:: none

    FROM ubuntu:quantal
    MAINTAINER Fernando Mayo <fernando@tutum.co>

    # Install MongoDB server from official repo
    RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 7F0CEB10
    RUN echo 'deb http://downloads-distro.mongodb.org/repo/ubuntu-upstart dist 10gen' | tee /etc/apt/sources.list.d/mongodb.list
    RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get -y upgrade && DEBIAN_FRONTEND=noninteractive apt-get install -y mongodb-10gen pwgen
    RUN mkdir -p /data/db

    # Add run scripts
    ADD run.sh /run.sh
    ADD set_mongodb_password.sh /set_mongodb_password.sh
    RUN chmod 755 ./*.sh

    EXPOSE 27017
    CMD ["/run.sh"]

**Environment variables**

MONGODB_PASS
    If set, the container will set the ``admin`` account password to the specified value on launch


CouchDB (tutum/couchdb)
^^^^^^^^^^^^^^^^^^^^^^^
CouchDB image - listens in port 5984. For the admin account password, either set COUCHDB_PASS environment variable, or
check the logs for a randomly generated one.

Links: `Docker Index <https://index.docker.io/u/tutum/couchdb/>`__ - `GitHub repo <https://github.com/tutumcloud/tutum-docker-couchdb/>`__

**Source Dockerfile**

.. sourcecode:: none

    FROM ubuntu:saucy
    MAINTAINER FENG, HONGLIN <hfeng@tutum.co>

    #install CouchDB
    RUN apt-get update
    RUN DEBIAN_FRONTEND=noninteractive apt-get install -y couchdb
    RUN DEBIAN_FRONTEND=noninteractive apt-get install -y curl pwgen
    RUN mkdir /var/run/couchdb
    RUN sed -i -r 's/;bind_address = 127.0.0.1/bind_address = 0.0.0.0/' /etc/couchdb/local.ini

    ADD create_couchdb_admin_user.sh /create_couchdb_admin_user.sh
    ADD run.sh /run.sh
    RUN chmod 755 /*.sh

    EXPOSE 5984
    CMD ["/run.sh"]

**Environment variables**

COUCHDB_PASS
    If set, the container will set the ``admin`` account password to the specified value on launch


Message queues
--------------

RabbitMQ (tutum/rabbitmq)
^^^^^^^^^^^^^^^^^^^^^^^^^
RabbitMQ Docker image – listens in ports 5672/55672 (admin). For the admin password, either set ``RABBITMQ_PASS``
environment variable or read the logs for a randomly generated one

Links: `Docker Index <https://index.docker.io/u/tutum/rabbitmq/>`__ - `GitHub repo <https://github.com/tutumcloud/tutum-docker-rabbitmq/>`__

**Source Dockerfile**

.. sourcecode:: none

    FROM ubuntu:quantal
    MAINTAINER Fernando Mayo <fernando@tutum.co>

    # Install RabbitMQ
    RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get -y upgrade && DEBIAN_FRONTEND=noninteractive apt-get install -y rabbitmq-server pwgen
    RUN rabbitmq-plugins enable rabbitmq_management

    # Add scripts
    ADD run.sh /run.sh
    ADD set_rabbitmq_password.sh /set_rabbitmq_password.sh
    RUN chmod 755 ./*.sh

    EXPOSE 5672 55672
    CMD ["/run.sh"]

**Environment variables**

RABBITMQ_PASS
    If set, the container will set the ``admin`` account password to the specified value on launch