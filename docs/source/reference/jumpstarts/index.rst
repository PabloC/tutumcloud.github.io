:title: Jumpstart Images

Jumpstart Images
================


Databases and caches
--------------------

MySQL (tutum/mysql)
^^^^^^^^^^^^^^^^^^^
`Link to the Docker Index page <https://index.docker.io/u/tutum/mysql/>`_

`Link to the source GitHub repository <https://github.com/tutumcloud/tutum-docker-mysql/>`_

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

