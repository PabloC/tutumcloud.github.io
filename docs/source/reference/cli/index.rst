:title: Command-line Interface

.. _cli-ref:

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

    $ tutum

    usage: tutum [-h] [-v] {apps,build,containers,images,login} ...

    Tutum's CLI

    optional arguments:
      -h, --help            show this help message and exit
      -v, --version         show program's version number and exit

    Tutum's CLI commands:
      {apps,build,containers,images,login}
        apps                Applications related operations
        build               Build an image
        containers          Containers related operations
        images              Image related operations
        login               Login into Tutum


Via Docker image
################

You can also install the CLI via Docker:

.. sourcecode:: bash

    docker run tutum/cli -h

You will have to pass your username and API key as environment variables, as the credentials stored via ``tutum login``
will not persist by default:

.. sourcecode:: bash

    docker run -e TUTUM_USER=username -e TUTUM_APIKEY=apikey tutum/cli apps

To make things easier, you might want to use an ``alias`` for it:

.. sourcecode:: bash

    alias tutum="docker run -e TUTUM_USER=username -e TUTUM_APIKEY=apikey tutum/cli"
    tutum apps


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