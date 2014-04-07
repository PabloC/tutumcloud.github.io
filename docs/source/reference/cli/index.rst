:title: Command-line Interface

Command-line Interface
======================

Overview
--------

Tutum also offers a command-line interface tool to interact with the service.


Installing the CLI
^^^^^^^^^^^^^^^^^^

In order to install the Tutum CLI, you can use ``pip install``:

.. sourcecode:: bash

    pip install tutum

Now you can start using it:

.. sourcecode:: none

    $ tutum -h
    usage: tutum [-h] [-v] {login,apps,run,inspect,start,stop,terminate,logs,scale,alias,ps,inspect-container,start-container,stop-container,terminate-container,logs-container}
                           ...

    Tutum's CLI

    optional arguments:
      -h, --help            show this help message and exit
      -v, --version         show program's version number and exit

    Tutum's CLI commands:
     {login,apps,run,inspect,start,stop,terminate,logs,scale,alias,ps,inspect-container,start-container,stop-container,terminate-container,logs-container}
       login               Login into Tutum
       apps                List all applications
       run                 Create and run an application
       inspect             Inspect an application
       start               Start an application
       stop                Stop an application
       terminate           Terminate an application
       logs                Get logs from an application
       scale               Scale an application
       alias               Change application's dns
       ps                  List all containers
       inspect-container   Inspect a container
       start-container     Start a container
       stop-container      Stop a container
       terminate-container
                           Terminate a container
       logs-container      Get logs from a container


Authentication
^^^^^^^^^^^^^^

In other to manage your apps and containers running on Tutum, you need to log into Tutum in any of the following ways
(will be used in this order):

* Login using Tutum CLI or storing it directly in a configuration file in ``~/.tutum``:

.. sourcecode:: bash

    $ tutum login
    Username: admin
    Password:
    Login succeeded!

Your login credentials will be stored in ``~/.tutum``:

.. sourcecode:: ini

    [auth]
    user = "username"
    apikey = "apikey"

* Set the environment variables ``TUTUM_USER`` and ``TUTUM_APIKEY``:

.. sourcecode:: bash

    export TUTUM_USER=username
    export TUTUM_APIKEY=apikey


Full command reference
----------------------

.. autoprogram:: tutumcli.tutum_cli:parser
    :prog: tutum