:title: Python library

Python library
==============

Overview
--------

Tutum provides an open source Python library that wraps its HTTP REST API, making it easier to perform operations from
Python applications.


Installing the Python library
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

In order to install the Tutum Python library, you can use ``pip install``:

.. sourcecode:: bash

    pip install python-tutum

It will install a Python module called ``tutum`` which you can use to interface with the API.


Authentication
^^^^^^^^^^^^^^

You can use your ApiKey with the Python library in any of the following ways (will be used in this order):

* Manually set it in your Python initialization code:

.. sourcecode:: python

    import tutum
    tutum.user = "username"
    tutum.apikey = "apikey"


* Store it in a configuration file in ``~/.tutum``:

.. sourcecode:: ini

    [auth]
    user = "username"
    apikey = "apikey"


* Set the environment variables ``TUTUM_USER`` and ``TUTUM_APIKEY``:

.. sourcecode:: bash

    export TUTUM_USER=username
    export TUTUM_APIKEY=apikey


Errors
^^^^^^

The Python library will detect the API HTTP error status codes and raise the following exceptions with the error message,
which should be handled by the calling application accordingly:

.. automodule:: tutum.api.exceptions
    :members:


Applications
------------

.. autoclass:: tutum.Application
    :members: list, fetch, create, start, stop, logs, delete


Example
^^^^^^^

.. sourcecode:: python

    >>> import tutum
    >>> app = tutum.Application.create(image="tutum/hello-world", name="my-new-app", target_num_containers=2)
    >>> app.save()
    True
    >>> app.state
    "Starting"
    >>> app.refresh()
    >>> app.state
    "Running"
    >>> tutum.Application.list()
    [<tutum.api.application.Application object at 0x10701ca90>]
    >>> tutum.Application.list(name="my-new-app")[0].uuid
    "fee900c6-97da-46b3-a21c-e2b50ed07015"
    >>> app = tutum.Application.fetch("fee900c6-97da-46b3-a21c-e2b50ed07015")
    >>> app.name
    "my-new-app"
    >>> app.target_num_containers = 3
    >>> app.save()
    True
    >>> app.state
    "Scaling"
    >>> app.refresh()
    >>> app.state
    "Running"
    >>> app.stop()
    True
    >>> app.start()
    True
    >>> app.delete()
    True
    >>> app.state
    "Terminating"
    >>> app.refresh()
    >>> app.state
    "Terminated"


Containers
----------

.. autoclass:: tutum.Container
    :members: list, fetch, start, stop, logs, delete


Example
^^^^^^^

.. sourcecode:: python

    >>> import tutum
    >>> tutum.Container.list(application__name="my-new-app")
    [<tutum.api.container.Container object at 0x10701ca90>]
    >>> tutum.Container.list(application__name="my-new-app")[0].uuid
    "fee900c6-97da-46b3-a21c-e2b50ed07015"
    >>> container = tutum.Container.fetch("fee900c6-97da-46b3-a21c-e2b50ed07015")
    >>> container.name
    "my-new-app-1"
    >>> container.stop()
    True
    >>> container.state
    "Stopping"
    >>> container.refresh()
    >>> container.state
    "Stopped"
    >>> container.start()
    True
    >>> container.delete()
    True
    >>> container.state
    "Terminating"
    >>> container.refresh()
    >>> container.state
    "Terminated"


Authentication utilities
------------------------

.. automodule:: tutum.api.auth
    :members: