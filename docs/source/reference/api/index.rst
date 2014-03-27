:title: HTTP API

.. _api-ref:

Tutum API
=========

.. contents::
    :local:

.. _api-auth-ref:


Introduction
------------

Tutum currently offers an HTTP REST API and a Python library that wraps this API. In this document you will find
all the operations currently supported in the platform and examples on how to execute them as raw HTTP requests
and by using the Python library.


Installing the Python library
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

In order to install the Tutum Python library, you can use ``pip install``:

.. sourcecode:: bash

    pip install python-tutum

It will install a Python module called ``tutum`` which you can use to interface with the API.


Authorization
-------------

In order to be able to make requests to the API, you should first obtain an ApiKey for your account.
For this, log into Tutum, click on the menu on the upper right corner of the screen, and select **Get Api Key**


HTTP API
^^^^^^^^

The Tutum HTTP API is reachable through the following hostname::

    https://app.tutum.co/

All requests should be sent to this endpoint with the following ``Authorization`` header:

.. sourcecode:: bash

    curl -H "Authorization: ApiKey username:apikey" https://app.tutum.co/api/v1/application/


Python library
^^^^^^^^^^^^^^

You can use your ApiKey with the Python library in any of the following ways (will be used in this order):

* Store it in a configuration file in ``~/.tutum``:

.. sourcecode:: ini

    [auth]
    user = "username"
    apikey = "apikey"

* Set the environment variables ``TUTUM_USER`` and ``TUTUM_APIKEY``:

.. sourcecode:: bash

    export TUTUM_USER=username
    export TUTUM_APIKEY=apikey

* Manually set it in your Python initialization code:

.. sourcecode:: python

    import tutum
    tutum.user = "username"
    tutum.apikey = "apikey"


Errors
------

Errors in the HTTP API will be returned with status codes in the 4xx and 5xx ranges.

The Python library will detect this status codes and raise ``TutumServerError`` exceptions with the error message,
which should be handled by the calling application accordingly.


Applications
------------

List all applications
^^^^^^^^^^^^^^^^^^^^^

.. http:get:: /api/v1/application/

    This operation returns a list of all active and recently terminated (less than 5 minutes ago) applications.

    **Example request**:

    .. sourcecode:: http

        GET /api/v1/application/ HTTP/1.1
        Host: app.tutum.co
        Accept: application/json
        Authorization: ApiKey username:apikey

    **Example response**:

    .. sourcecode:: http

        HTTP/1.1 200 OK
        Cache-Control: must-revalidate, max-age=0
        Content-Type: application/json
        Vary: Accept, Authorization, Cookie

        {
            "meta": {
                "limit": 25,
                "next": null,
                "offset": 0,
                "previous": null,
                "total_count": 1
            },
            "objects": [
                {
                    "autodestroy": "OFF",
                    "autoreplace": "OFF",
                    "autorestart": "OFF",
                    "container_ports": [
                        {
                            "application": "/api/v1/application/6fe5029e-c125-4088-9b9a-4e74da20ac58/",
                            "inner_port": 80,
                            "outer_port": null,
                            "protocol": "tcp"
                        }
                    ],
                    "container_size": "XS",
                    "current_num_containers": 2,
                    "deployed_datetime": "Mon, 24 Mar 2014 23:58:15 +0000",
                    "destroyed_datetime": null,
                    "entrypoint": "",
                    "image_tag": "/api/v1/image/tutum/hello-world/tag/latest/",
                    "name": "my-web-app",
                    "public_dns": "my-web-app.alpha.tutum.io",
                    "resource_uri": "/api/v1/application/6fe5029e-c125-4088-9b9a-4e74da20ac58/",
                    "run_command": "/run.sh",
                    "running_num_containers": 2,
                    "started_datetime": "Mon, 24 Mar 2014 23:58:15 +0000",
                    "state": "Running",
                    "stopped_datetime": null,
                    "stopped_num_containers": 0,
                    "target_num_containers": 2,
                    "unique_name": "my-web-app",
                    "uuid": "6fe5029e-c125-4088-9b9a-4e74da20ac58",
                    "web_public_dns": "my-web-app.alpha.tutum.io"
                }
            ]
        }

    :reqheader Authorization: required ApiKey authentication header in the format ``ApiKey username:apikey``
    :reqheader Accept: required, only ``application/json`` is supported
    :queryparam int offset: optional, start the list skipping the first ``offset`` records (default: 0)
    :queryparam int limit: optional, only return at most ``limit`` records (default: 25, max: 100)
    :statuscode 200: no error
    :statuscode 401: unauthorized (wrong credentials)

**Python library example**

.. sourcecode:: python

    >>> import tutum
    >>> tutum.Application.list()
    [<tutum.api.application.Application object at 0x10701ca90>, <tutum.api.application.Application object at 0x10701ca91>]


``tutum.Application`` objects have all the attributes of the returned JSON as properties

.. _api-application-ref:

Get application details
^^^^^^^^^^^^^^^^^^^^^^^

.. http:get:: /api/v1/application/(uuid)/

    Get all the details of an specific application

    **Example request**:

    .. sourcecode:: http

        GET /api/v1/application/6fe5029e-c125-4088-9b9a-4e74da20ac58/ HTTP/1.1
        Host: app.tutum.co
        Accept: application/json
        Authorization: ApiKey username:apikey

    **Example response**:

    .. sourcecode:: http

        HTTP/1.1 200 OK
        Cache-Control: must-revalidate, max-age=0
        Content-Type: application/json
        Vary: Accept, Authorization, Cookie

        {
            "autodestroy": "OFF",
            "autoreplace": "OFF",
            "autorestart": "OFF",
            "container_envvars": [],
            "container_ports": [
                {
                    "application": "/api/v1/application/6fe5029e-c125-4088-9b9a-4e74da20ac58/",
                    "inner_port": 80,
                    "outer_port": null,
                    "protocol": "tcp"
                }
            ],
            "container_size": "XS",
            "containers": [
                "/api/v1/container/7d6696b7-fbaf-471d-8e6b-ce7052586c24/",
                "/api/v1/container/83499f74-85b1-4f69-9ab3-658a67535f70/"
            ],
            "current_num_containers": 2,
            "deployed_datetime": "Mon, 24 Mar 2014 23:58:15 +0000",
            "destroyed_datetime": null,
            "entrypoint": "",
            "image_tag": "/api/v1/image/tutum/hello-world/tag/latest/",
            "link_variables": {
                "MY_WEB_APP_2_PORT": "tcp://my-web-app-2-admin.alpha.tutum.io:49282",
                "MY_WEB_APP_2_PORT_80_TCP": "tcp://my-web-app-2-admin.alpha.tutum.io:49282",
                "MY_WEB_APP_2_PORT_80_TCP_ADDR": "my-web-app-2-admin.alpha.tutum.io",
                "MY_WEB_APP_2_PORT_80_TCP_PORT": "49282",
                "MY_WEB_APP_2_PORT_80_TCP_PROTO": "tcp",
                "MY_WEB_APP_3_PORT": "tcp://my-web-app-3-admin.alpha.tutum.io:49283",
                "MY_WEB_APP_3_PORT_80_TCP": "tcp://my-web-app-3-admin.alpha.tutum.io:49283",
                "MY_WEB_APP_3_PORT_80_TCP_ADDR": "my-web-app-3-admin.alpha.tutum.io",
                "MY_WEB_APP_3_PORT_80_TCP_PORT": "49283",
                "MY_WEB_APP_3_PORT_80_TCP_PROTO": "tcp",
                "MY_WEB_APP_TUTUM_API_URL": "https://app.tutum.co/api/v1/application/6fe5029e-c125-4088-9b9a-4e74da20ac58/"
            },
            "linked_from_application": [],
            "linked_to_application": [],
            "name": "my-web-app",
            "public_dns": "my-web-app.alpha.tutum.io",
            "resource_uri": "/api/v1/application/6fe5029e-c125-4088-9b9a-4e74da20ac58/",
            "roles": [],
            "run_command": "/run.sh",
            "running_num_containers": 2,
            "started_datetime": "Mon, 24 Mar 2014 23:58:15 +0000",
            "state": "Running",
            "stopped_datetime": null,
            "stopped_num_containers": 0,
            "target_num_containers": 2,
            "unique_name": "my-web-app",
            "uuid": "6fe5029e-c125-4088-9b9a-4e74da20ac58",
            "web_public_dns": "my-web-app.alpha.tutum.io"
        }

    :query uuid: the UUID of the application
    :reqheader Authorization: required ApiKey authentication header in the format ``ApiKey username:apikey``
    :reqheader Accept: required, only ``application/json`` is supported
    :statuscode 200: no error
    :statuscode 404: application not found
    :statuscode 401: unauthorized (wrong credentials)

**Python library example**

.. sourcecode:: python

    >>> import tutum
    >>> tutum.Application.fetch("fee900c6-97da-46b3-a21c-e2b50ed07015")
    <tutum.api.application.Application object at 0x106c45c10>


``tutum.Application`` objects have all the attributes of the returned JSON as properties

Create and launch a new application
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. http:post:: /api/v1/application/

    Creates and deploys a new application

    **Example request**:

    .. sourcecode:: http

        POST /api/v1/application/ HTTP/1.1
        Host: app.tutum.co
        Accept: application/json
        Authorization: ApiKey username:apikey
        Content-Type: application/json

        {
            "image_tag": "tutum/hello-world",
            "name": "my-new-app",
            "target_num_containers": 2,
            "container_size": "XS"
        }

    **Example response**:

    .. sourcecode:: http

        HTTP/1.1 202 Accepted
        Cache-Control: must-revalidate, max-age=0
        Content-Type: application/json
        Vary: Accept, Authorization, Cookie

        {
            "autodestroy": "OFF",
            "autoreplace": "OFF",
            "autorestart": "OFF",
            "container_envvars": [],
            "container_ports": [
                {
                    "application": "/api/v1/application/80ff1635-2d56-478d-a97f-9b59c720e513/",
                    "inner_port": 80,
                    "outer_port": null,
                    "protocol": "tcp"
                }
            ],
            "container_size": "XS",
            "containers": [
                "/api/v1/container/7dfee1e7-77ea-4ce1-9a88-b23015a74ca3/",
                "/api/v1/container/965c951d-6edc-40f8-9ffe-40113ba81836/"
            ],
            "current_num_containers": 2,
            "deployed_datetime": null,
            "destroyed_datetime": null,
            "entrypoint": "",
            "image_tag": "/api/v1/image/tutum/hello-world/tag/latest/",
            "link_variables": {
                "MY_NEW_APP_TUTUM_API_URL": "https://app.tutum.co/api/v1/application/80ff1635-2d56-478d-a97f-9b59c720e513/"
            },
            "linked_from_application": [],
            "linked_to_application": [],
            "name": "my-new-app",
            "public_dns": "my-new-app.alpha.tutum.io",
            "resource_uri": "/api/v1/application/80ff1635-2d56-478d-a97f-9b59c720e513/",
            "roles": [],
            "run_command": "/run.sh",
            "running_num_containers": 0,
            "started_datetime": null,
            "state": "Starting",
            "stopped_datetime": null,
            "stopped_num_containers": 0,
            "target_num_containers": 2,
            "unique_name": "my-new-app",
            "uuid": "80ff1635-2d56-478d-a97f-9b59c720e513",
            "web_public_dns": "my-new-app.alpha.tutum.io"
        }


    :jsonparam string image_tag: required, the image used to deploy this application, i.e. ``tutum/hello-world``
    :jsonparam string name: optional, a human-readable name for the application, i.e. ``my-hello-world-app`` (default: ``image_tag`` without namespace)
    :jsonparam string container_size: optional, the size of the application containers, i.e. ``M`` (default: ``XS``, possible values: ``XS``, ``S``, ``M``, ``L``, ``XL``)
    :jsonparam int target_num_containers: the number of containers to run for this application (default: 1)
    :jsonparam string run_command: optional, the command used to start the application containers, i.e. ``/run.sh`` (default: as defined in the image)
    :jsonparam string entrypoint: optional, the command prefix used to start the application containers, i.e. ``/usr/sbin/sshd`` (default: as defined in the image)
    :jsonparam array(object) container_ports: optional, an array of objects with port information to be exposed in the application containers, i.e. ``[{"protocol": "tcp", "inner_port": 80}]`` (default: as defined in the image)
    :jsonparam array(object) container_envvars: optional, an array of objects with environment variables to be set in the application containers on launch, i.e. ``[{"key": "DB_PASSWORD", "value": "mypass"}]`` (default: as defined in the image, plus any link- or role-generated variables)
    :jsonparam array(object) linked_to_application: optional, an array of application resource URIs to link this application to, i.e. ``["/api/v1/application/80ff1635-2d56-478d-a97f-9b59c720e513/"]`` (default: empty array)
    :jsonparam string autorestart: optional, whether the containers should be restarted if they stop, i.e. ``ALWAYS`` (default: ``OFF``, possible values: ``OFF``, ``ON_FAILURE``, ``ALWAYS``)
    :jsonparam string autoreplace: optional, whether the containers should be replaced with a new one if they stop, i.e. ``ALWAYS`` (default: ``OFF``, possible values: ``OFF``, ``ON_FAILURE``, ``ALWAYS``)
    :jsonparam string autodestroy: optional, whether the containers should be terminated if they stop, i.e. ``OFF`` (default: ``OFF``, possible values: ``OFF``, ``ON_FAILURE``, ``ALWAYS``)
    :jsonparam string roles: optional, a list of Tutum API role resource URIs to grant the application, i.e. ``["/api/v1/role/global/"]`` (default: empty array, options: see :ref:`api-roles`)
    :reqheader Content-Type: required, only ``application/json`` is supported
    :reqheader Authorization: required ApiKey authentication header in the format ``ApiKey username:apikey``
    :reqheader Accept: required, only ``application/json`` is supported
    :statuscode 202: operation accepted
    :statuscode 400: cannot perform the operation (probably the application is not in a suitable state)
    :statuscode 401: unauthorized (wrong credentials)

**Python library example**

.. sourcecode:: python

    >>> import tutum
    >>> app = tutum.Application(image_tag="tutum/hello-world")
    >>> app.save()
    True


Update an application
^^^^^^^^^^^^^^^^^^^^^

.. http:patch:: /api/v1/application/(uuid)/

    Updates the application details and scales the application up or down accordingly

    **Example request**:

    .. sourcecode:: http

        PATCH /api/v1/application/80ff1635-2d56-478d-a97f-9b59c720e513/ HTTP/1.1
        Host: app.tutum.co
        Accept: application/json
        Authorization: ApiKey username:apikey
        Content-Type: application/json

        {
            "target_num_containers": 3
        }

    **Example response**:

    .. sourcecode:: http

        HTTP/1.1 202 Accepted
        Cache-Control: must-revalidate, max-age=0
        Content-Type: application/json
        Vary: Accept, Authorization, Cookie

        {
            "deployed_datetime": "Tue, 25 Mar 2014 20:40:13 +0000",
            "container_ports": [
                {
                    "outer_port": null,
                    "inner_port": 80,
                    "protocol": "tcp",
                    "application": "/api/v1/application/80ff1635-2d56-478d-a97f-9b59c720e513/"
                }
            ],
            "current_num_containers": 3,
            "run_command": "/run.sh",
            "autodestroy": "OFF",
            "linked_to_application": [],
            "container_size": "XS",
            "started_datetime": "Tue, 25 Mar 2014 20:40:13 +0000",
            "stopped_num_containers": 0,
            "uuid": "80ff1635-2d56-478d-a97f-9b59c720e513",
            "name": "my-new-app",
            "public_dns": "my-new-app.alpha.tutum.io"
            "autorestart": "OFF",
            "destroyed_datetime": null,
            "state": "Scaling",
            "roles": [],
            "containers": [
                "/api/v1/container/7dfee1e7-77ea-4ce1-9a88-b23015a74ca3/",
                "/api/v1/container/965c951d-6edc-40f8-9ffe-40113ba81836/",
                "/api/v1/container/0ee97d28-3d86-43fd-ac72-750cfc183791/"
            ],
            "image_tag": "/api/v1/image/tutum/hello-world/tag/latest/",
            "running_num_containers": 2,
            "resource_uri": "/api/v1/application/80ff1635-2d56-478d-a97f-9b59c720e513/",
            "stopped_datetime": null,
            "unique_name": "my-new-app",
            "linked_from_application": [],
            "entrypoint": "",
            "autoreplace": "OFF",
            "container_envvars": [],
            "link_variables": {
                "MY_NEW_APP_2_PORT_80_TCP_PORT": "49154",
                "MY_NEW_APP_2_PORT_80_TCP_PROTO": "tcp",
                "MY_NEW_APP_TUTUM_API_URL": "https://app.tutum.co/api/v1/application/80ff1635-2d56-478d-a97f-9b59c720e513/",
                "MY_NEW_APP_2_PORT": "tcp://my-new-app-2-admin.alpha.tutum.io:49154",
                "MY_NEW_APP_1_PORT_80_TCP": "tcp://my-new-app-1-admin.alpha.tutum.io:49153",
                "MY_NEW_APP_1_PORT_80_TCP_PORT": "49153",
                "MY_NEW_APP_1_PORT_80_TCP_PROTO": "tcp",
                "MY_NEW_APP_1_PORT": "tcp://my-new-app-1-admin.alpha.tutum.io:49153",
                "MY_NEW_APP_1_PORT_80_TCP_ADDR": "my-new-app-1-admin.alpha.tutum.io",
                "MY_NEW_APP_2_PORT_80_TCP": "tcp://my-new-app-2-admin.alpha.tutum.io:49154",
                "MY_NEW_APP_2_PORT_80_TCP_ADDR": "my-new-app-2-admin.alpha.tutum.io"
            },
            "target_num_containers": 3,
            "web_public_dns": "my-new-app.alpha.tutum.io"
        }

    :query uuid: the UUID of the application
    :jsonparam int target_num_containers: optional, the target number of containers to scale this application to
    :jsonparam string web_public_dns: optional, the custom domain to use for this web application
    :reqheader Content-Type: required, only ``application/json`` is supported
    :reqheader Authorization: required ApiKey authentication header in the format ``ApiKey username:apikey``
    :reqheader Accept: required, only ``application/json`` is supported
    :statuscode 202: operation accepted
    :statuscode 400: cannot perform the operation (probably the application is not in a suitable state)
    :statuscode 401: unauthorized (wrong credentials)


**Python library example**

.. sourcecode:: python

    >>> import tutum
    >>> app = tutum.Application.fetch("fee900c6-97da-46b3-a21c-e2b50ed07015")
    >>> app.target_num_containers = 3
    >>> app.save()
    True


Start an application
^^^^^^^^^^^^^^^^^^^^

.. http:post:: /api/v1/application/(uuid)/start/

    Starts all the containers in a stopped application

    **Example request**:

    .. sourcecode:: http

        POST /api/v1/application/80ff1635-2d56-478d-a97f-9b59c720e513/start/ HTTP/1.1
        Host: app.tutum.co
        Accept: application/json
        Authorization: ApiKey username:apikey

    **Example response**:

    .. sourcecode:: http

        HTTP/1.1 202 Accepted
        Cache-Control: must-revalidate, max-age=0
        Content-Type: application/json
        Vary: Accept, Authorization, Cookie

        {
            "deployed_datetime": "Tue, 25 Mar 2014 20:40:13 +0000",
            "container_ports": [
                {
                    "outer_port": null,
                    "inner_port": 80,
                    "protocol": "tcp",
                    "application": "/api/v1/application/80ff1635-2d56-478d-a97f-9b59c720e513/"
                }
            ],
            "current_num_containers": 3,
            "run_command": "/run.sh",
            "autodestroy": "OFF",
            "linked_to_application": [],
            "container_size": "XS",
            "started_datetime": "Tue, 25 Mar 2014 20:40:13 +0000",
            "stopped_num_containers": 0,
            "uuid": "80ff1635-2d56-478d-a97f-9b59c720e513",
            "name": "my-new-app",
            "public_dns": "my-new-app.alpha.tutum.io"
            "autorestart": "OFF",
            "destroyed_datetime": null,
            "state": "Starting",
            "roles": [],
            "containers": [
                "/api/v1/container/7dfee1e7-77ea-4ce1-9a88-b23015a74ca3/",
                "/api/v1/container/965c951d-6edc-40f8-9ffe-40113ba81836/",
                "/api/v1/container/0ee97d28-3d86-43fd-ac72-750cfc183791/"
            ],
            "image_tag": "/api/v1/image/tutum/hello-world/tag/latest/",
            "running_num_containers": 0,
            "resource_uri": "/api/v1/application/80ff1635-2d56-478d-a97f-9b59c720e513/",
            "stopped_datetime": "Tue, 25 Mar 2014 21:00:54 +0000",
            "unique_name": "my-new-app",
            "linked_from_application": [],
            "entrypoint": "",
            "autoreplace": "OFF",
            "container_envvars": [],
            "link_variables": {
                "MY_NEW_APP_TUTUM_API_URL": "https://app.tutum.co/api/v1/application/80ff1635-2d56-478d-a97f-9b59c720e513/"
            },
            "target_num_containers": 3,
            "web_public_dns": "my-new-app.alpha.tutum.io"
        }

    :query uuid: the UUID of the application
    :reqheader Authorization: required ApiKey authentication header in the format ``ApiKey username:apikey``
    :reqheader Accept: required, only ``application/json`` is supported
    :statuscode 202: operation accepted
    :statuscode 400: cannot perform the operation (probably the application is not in a suitable state)
    :statuscode 401: unauthorized (wrong credentials)


**Python library example**

.. sourcecode:: python

    >>> import tutum
    >>> app = tutum.Application.fetch("fee900c6-97da-46b3-a21c-e2b50ed07015")
    >>> app.start()
    True


Stop an application
^^^^^^^^^^^^^^^^^^^

.. http:post:: /api/v1/application/(uuid)/stop/

    Stops all the containers in a running application

    **Example request**:

    .. sourcecode:: http

        POST /api/v1/application/80ff1635-2d56-478d-a97f-9b59c720e513/stop/ HTTP/1.1
        Host: app.tutum.co
        Accept: application/json
        Authorization: ApiKey username:apikey

    **Example response**:

    .. sourcecode:: http

        HTTP/1.1 202 Accepted
        Cache-Control: must-revalidate, max-age=0
        Content-Type: application/json
        Vary: Accept, Authorization, Cookie

        {
            "deployed_datetime": "Tue, 25 Mar 2014 20:40:13 +0000",
            "container_ports": [
                {
                    "outer_port": null,
                    "inner_port": 80,
                    "protocol": "tcp",
                    "application": "/api/v1/application/80ff1635-2d56-478d-a97f-9b59c720e513/"
                }
            ],
            "current_num_containers": 3,
            "run_command": "/run.sh",
            "autodestroy": "OFF",
            "linked_to_application": [],
            "container_size": "XS",
            "started_datetime": "Tue, 25 Mar 2014 20:40:13 +0000",
            "stopped_num_containers": 0,
            "uuid": "80ff1635-2d56-478d-a97f-9b59c720e513",
            "name": "my-new-app",
            "public_dns": "my-new-app.alpha.tutum.io",
            "autorestart": "OFF",
            "destroyed_datetime": null,
            "state": "Stopping",
            "roles": [],
            "containers": [
                "/api/v1/container/7dfee1e7-77ea-4ce1-9a88-b23015a74ca3/",
                "/api/v1/container/965c951d-6edc-40f8-9ffe-40113ba81836/",
                "/api/v1/container/0ee97d28-3d86-43fd-ac72-750cfc183791/"
            ],
            "image_tag": "/api/v1/image/tutum/hello-world/tag/latest/",
            "running_num_containers": 0,
            "resource_uri": "/api/v1/application/80ff1635-2d56-478d-a97f-9b59c720e513/",
            "stopped_datetime": null,
            "unique_name": "my-new-app",
            "linked_from_application": [],
            "entrypoint": "",
            "autoreplace": "OFF",
            "container_envvars": [],
            "link_variables": {
                "MY_NEW_APP_TUTUM_API_URL": "https://app.tutum.co/api/v1/application/80ff1635-2d56-478d-a97f-9b59c720e513/"
            },
            "target_num_containers": 3,
            "web_public_dns": "my-new-app.alpha.tutum.io"
        }

    :query uuid: the UUID of the application
    :reqheader Authorization: required ApiKey authentication header in the format ``ApiKey username:apikey``
    :reqheader Accept: required, only ``application/json`` is supported
    :statuscode 202: operation accepted
    :statuscode 400: cannot perform the operation (probably the application is not in a suitable state)
    :statuscode 401: unauthorized (wrong credentials)


**Python library example**

.. sourcecode:: python

    >>> import tutum
    >>> app = tutum.Application.fetch("fee900c6-97da-46b3-a21c-e2b50ed07015")
    >>> app.stop()
    True


Terminate an application
^^^^^^^^^^^^^^^^^^^^^^^^

.. http:delete:: /api/v1/application/(uuid)/

    Destroy all the containers in an application. This is not reversible. All the data stored in all the application containers will be permanently deleted.

    **Example request**:

    .. sourcecode:: http

        DELETE /api/v1/application/80ff1635-2d56-478d-a97f-9b59c720e513/ HTTP/1.1
        Host: app.tutum.co
        Accept: application/json
        Authorization: ApiKey username:apikey

    **Example response**:

    .. sourcecode:: http

        HTTP/1.1 202 Accepted
        Cache-Control: must-revalidate, max-age=0
        Content-Type: application/json
        Vary: Accept, Authorization, Cookie

        {
            "deployed_datetime": "Tue, 25 Mar 2014 20:40:13 +0000",
            "container_ports": [
                {
                    "outer_port": null,
                    "inner_port": 80,
                    "protocol": "tcp",
                    "application": "/api/v1/application/80ff1635-2d56-478d-a97f-9b59c720e513/"
                }
            ],
            "current_num_containers": 3,
            "run_command": "/run.sh",
            "autodestroy": "OFF",
            "linked_to_application": [],
            "container_size": "XS",
            "started_datetime": "Tue, 25 Mar 2014 21:01:48 +0000",
            "stopped_num_containers": 0,
            "uuid": "80ff1635-2d56-478d-a97f-9b59c720e513",
            "name": "my-new-app",
            "public_dns": "my-new-app.alpha.tutum.io",
            "autorestart": "OFF",
            "destroyed_datetime": null,
            "state": "Stopping",
            "roles": [],
            "containers": [
                "/api/v1/container/7dfee1e7-77ea-4ce1-9a88-b23015a74ca3/",
                "/api/v1/container/965c951d-6edc-40f8-9ffe-40113ba81836/",
                "/api/v1/container/0ee97d28-3d86-43fd-ac72-750cfc183791/"
            ],
            "image_tag": "/api/v1/image/tutum/hello-world/tag/latest/",
            "running_num_containers": 0,
            "resource_uri": "/api/v1/application/80ff1635-2d56-478d-a97f-9b59c720e513/",
            "stopped_datetime": "Tue, 25 Mar 2014 21:00:54 +0000",
            "unique_name": "my-new-app",
            "linked_from_application": [],
            "entrypoint": "",
            "autoreplace": "OFF",
            "container_envvars": [],
            "link_variables": {
                "MY_NEW_APP_TUTUM_API_URL": "https://app.tutum.co/api/v1/application/80ff1635-2d56-478d-a97f-9b59c720e513/"
            },
            "target_num_containers": 3,
            "web_public_dns": "my-new-app.alpha.tutum.io"
        }

    :query uuid: the UUID of the application
    :reqheader Authorization: required ApiKey authentication header in the format ``ApiKey username:apikey``
    :reqheader Accept: required, only ``application/json`` is supported
    :statuscode 202: operation accepted
    :statuscode 400: cannot perform the operation (probably the application is not in a suitable state)
    :statuscode 401: unauthorized (wrong credentials)


**Python library example**

.. sourcecode:: python

    >>> import tutum
    >>> app = tutum.Application.fetch("fee900c6-97da-46b3-a21c-e2b50ed07015")
    >>> app.delete()
    True


Containers
----------

List all containers
^^^^^^^^^^^^^^^^^^^

.. http:get:: /api/v1/container/

    Returns a paginated list of all containers for all applications for the authenticated user

    **Example request**:

    .. sourcecode:: http

        GET /api/v1/container/ HTTP/1.1
        Host: app.tutum.co
        Accept: application/json
        Authorization: ApiKey username:apikey

    **Example response**:

    .. sourcecode:: http

        HTTP/1.1 200 OK
        Cache-Control: must-revalidate, max-age=0
        Content-Type: application/json
        Vary: Accept, Authorization, Cookie

        {
            "meta": {
                "offset": 0,
                "next": null,
                "limit": 25,
                "previous": null,
                "total_count": 2
            },
            "objects": [
                {
                    "exit_code": null,
                    "deployed_datetime": "Mon, 24 Mar 2014 23:58:08 +0000",
                    "application": "/api/v1/application/6fe5029e-c125-4088-9b9a-4e74da20ac58/",
                    "container_ports": [
                        {
                            "outer_port": 49282,
                            "inner_port": 80,
                            "protocol": "tcp",
                            "container": "/api/v1/container/7d6696b7-fbaf-471d-8e6b-ce7052586c24/"
                        }
                    ],
                    "run_command": "/run.sh",
                    "autodestroy": "OFF",
                    "container_size": "XS",
                    "started_datetime": "Mon, 24 Mar 2014 23:58:08 +0000",
                    "uuid": "7d6696b7-fbaf-471d-8e6b-ce7052586c24",
                    "name": "my-web-app",
                    "state": "Running",
                    "autorestart": "OFF",
                    "destroyed_datetime": null,
                    "image_tag": "/api/v1/image/tutum/hello-world/tag/latest/",
                    "stopped_datetime": null,
                    "resource_uri": "/api/v1/container/7d6696b7-fbaf-471d-8e6b-ce7052586c24/",
                    "unique_name": "my-web-app-2",
                    "exit_code_msg": null,
                    "entrypoint": "",
                    "public_dns": "my-web-app-2-admin.alpha.tutum.io",
                    "autoreplace": "OFF",
                    "web_public_dns": "my-web-app-2-admin.alpha.tutum.io"
                },
                {
                    "exit_code": null,
                    "deployed_datetime": "Mon, 24 Mar 2014 23:58:12 +0000",
                    "application": "/api/v1/application/6fe5029e-c125-4088-9b9a-4e74da20ac58/",
                    "container_ports": [
                        {
                            "outer_port": 49283,
                            "inner_port": 80,
                            "protocol": "tcp",
                            "container": "/api/v1/container/83499f74-85b1-4f69-9ab3-658a67535f70/"
                        }
                    ],
                    "run_command": "/run.sh",
                    "autodestroy": "OFF",
                    "container_size": "XS",
                    "started_datetime": "Mon, 24 Mar 2014 23:58:12 +0000",
                    "uuid": "83499f74-85b1-4f69-9ab3-658a67535f70",
                    "name": "my-web-app",
                    "state": "Running",
                    "autorestart": "OFF",
                    "destroyed_datetime": null,
                    "image_tag": "/api/v1/image/tutum/hello-world/tag/latest/",
                    "stopped_datetime": null,
                    "resource_uri": "/api/v1/container/83499f74-85b1-4f69-9ab3-658a67535f70/",
                    "unique_name": "my-web-app-3",
                    "exit_code_msg": null,
                    "entrypoint": "",
                    "public_dns": "my-web-app-3-admin.alpha.tutum.io",
                    "autoreplace": "OFF",
                    "web_public_dns": "my-web-app-2-admin.alpha.tutum.io"
                }
            ]
        }

    :reqheader Authorization: required ApiKey authentication header in the format ``ApiKey username:apikey``
    :reqheader Accept: required, only ``application/json`` is supported
    :queryparam int offset: optional, start the list skipping the first ``offset`` records (default: 0)
    :queryparam int limit: optional, only return at most ``limit`` records (default: 25, max: 100)
    :statuscode 200: no error
    :statuscode 401: unauthorized (wrong credentials)


**Python library example**

.. sourcecode:: python

    >>> import tutum
    >>> tutum.Container.list()
    [<tutum.api.container.Container object at 0x10701ca90>, <tutum.api.container.Container object at 0x10701ca91>]


``tutum.Container`` objects have all the attributes of the returned JSON as properties


Get container details
^^^^^^^^^^^^^^^^^^^^^

.. http:get:: /api/v1/container/(uuid)/

    Get all the details of an specific container

    **Example request**:

    .. sourcecode:: http

        GET /api/v1/container/7d6696b7-fbaf-471d-8e6b-ce7052586c24/ HTTP/1.1
        Host: app.tutum.co
        Accept: application/json
        Authorization: ApiKey username:apikey

    **Example response**:

    .. sourcecode:: http

        HTTP/1.1 200 OK
        Cache-Control: must-revalidate, max-age=0
        Content-Type: application/json
        Vary: Accept, Authorization, Cookie

        {
            "exit_code": null,
            "deployed_datetime": "Mon, 24 Mar 2014 23:58:08 +0000",
            "application": "/api/v1/application/6fe5029e-c125-4088-9b9a-4e74da20ac58/",
            "container_ports": [
                {
                    "outer_port": 49282,
                    "inner_port": 80,
                    "protocol": "tcp",
                    "container": "/api/v1/container/7d6696b7-fbaf-471d-8e6b-ce7052586c24/"
                }
            ],
            "run_command": "/run.sh",
            "autodestroy": "OFF",
            "linked_to_application": [],
            "container_size": "XS",
            "started_datetime": "Mon, 24 Mar 2014 23:58:08 +0000",
            "uuid": "7d6696b7-fbaf-471d-8e6b-ce7052586c24",
            "name": "my-web-app",
            "autorestart": "OFF",
            "destroyed_datetime": null,
            "state": "Running",
            "roles": [],
            "image_tag": "/api/v1/image/tutum/hello-world/tag/latest/",
            "stopped_datetime": null,
            "resource_uri": "/api/v1/container/7d6696b7-fbaf-471d-8e6b-ce7052586c24/",
            "unique_name": "my-web-app-2",
            "linked_from_application": [],
            "exit_code_msg": null,
            "entrypoint": "",
            "public_dns": "my-web-app-2-admin.alpha.tutum.io",
            "container_envvars": [
                {
                    "container": "/api/v1/container/7d6696b7-fbaf-471d-8e6b-ce7052586c24/",
                    "key": "MY_WEB_APP_1_PORT",
                    "value": "tcp://my-web-app-1-admin.alpha.tutum.io:49281"
                },
                {
                    "container": "/api/v1/container/7d6696b7-fbaf-471d-8e6b-ce7052586c24/",
                    "key": "MY_WEB_APP_1_PORT_80_TCP",
                    "value": "tcp://my-web-app-1-admin.alpha.tutum.io:49281"
                },
                {
                    "container": "/api/v1/container/7d6696b7-fbaf-471d-8e6b-ce7052586c24/",
                    "key": "MY_WEB_APP_1_PORT_80_TCP_ADDR",
                    "value": "my-web-app-1-admin.alpha.tutum.io"
                },
                {
                    "container": "/api/v1/container/7d6696b7-fbaf-471d-8e6b-ce7052586c24/",
                    "key": "MY_WEB_APP_1_PORT_80_TCP_PORT",
                    "value": "49281"
                },
                {
                    "container": "/api/v1/container/7d6696b7-fbaf-471d-8e6b-ce7052586c24/",
                    "key": "MY_WEB_APP_1_PORT_80_TCP_PROTO",
                    "value": "tcp"
                }
            ],
            "autoreplace": "OFF",
            "link_variables": {
                "MY_WEB_APP_2_PORT_80_TCP_PROTO": "tcp",
                "MY_WEB_APP_2_PORT_80_TCP_PORT": "49282",
                "MY_WEB_APP_2_PORT": "tcp://my-web-app-2-admin.alpha.tutum.io:49282",
                "MY_WEB_APP_2_PORT_80_TCP": "tcp://my-web-app-2-admin.alpha.tutum.io:49282",
                "MY_WEB_APP_2_PORT_80_TCP_ADDR": "my-web-app-2-admin.alpha.tutum.io"
            },
            "web_public_dns": "my-web-app-2-admin.alpha.tutum.io"
        }

    :query uuid: the UUID of the container
    :reqheader Authorization: required ApiKey authentication header in the format ``ApiKey username:apikey``
    :reqheader Accept: required, only ``application/json`` is supported
    :statuscode 200: no error
    :statuscode 404: container not found
    :statuscode 401: unauthorized (wrong credentials)

**Python library example**

.. sourcecode:: python

    >>> import tutum
    >>> tutum.Container.fetch("7d6696b7-fbaf-471d-8e6b-ce7052586c24")
    <tutum.api.container.Container object at 0x10701ca90>

``tutum.Container`` objects have all the attributes of the returned JSON as properties


Update a container
^^^^^^^^^^^^^^^^^^

.. http:patch:: /api/v1/container/(uuid)/

    Updates the specified container with the given data

    **Example request**:

    .. sourcecode:: http

        PATCH /api/v1/container/7d6696b7-fbaf-471d-8e6b-ce7052586c24/ HTTP/1.1
        Host: app.tutum.co
        Accept: application/json
        Authorization: ApiKey username:apikey

        {
            "web_public_dns": "my-web-app.example.com"
        }

    **Example response**:

    .. sourcecode:: http

        HTTP/1.1 202 Accepted
        Cache-Control: must-revalidate, max-age=0
        Content-Type: application/json
        Vary: Accept, Authorization, Cookie

        {
            "exit_code": null,
            "deployed_datetime": "Mon, 24 Mar 2014 23:58:08 +0000",
            "application": "/api/v1/application/6fe5029e-c125-4088-9b9a-4e74da20ac58/",
            "container_ports": [
                {
                    "outer_port": 49282,
                    "inner_port": 80,
                    "protocol": "tcp",
                    "container": "/api/v1/container/7d6696b7-fbaf-471d-8e6b-ce7052586c24/"
                }
            ],
            "run_command": "/run.sh",
            "autodestroy": "OFF",
            "linked_to_application": [],
            "container_size": "XS",
            "started_datetime": "Mon, 24 Mar 2014 23:58:08 +0000",
            "uuid": "7d6696b7-fbaf-471d-8e6b-ce7052586c24",
            "name": "my-web-app",
            "autorestart": "OFF",
            "destroyed_datetime": null,
            "state": "Running",
            "roles": [],
            "image_tag": "/api/v1/image/tutum/hello-world/tag/latest/",
            "stopped_datetime": null,
            "resource_uri": "/api/v1/container/7d6696b7-fbaf-471d-8e6b-ce7052586c24/",
            "unique_name": "my-web-app-2",
            "linked_from_application": [],
            "exit_code_msg": null,
            "entrypoint": "",
            "public_dns": "my-web-app-2-admin.alpha.tutum.io",
            "container_envvars": [
                {
                    "container": "/api/v1/container/7d6696b7-fbaf-471d-8e6b-ce7052586c24/",
                    "key": "MY_WEB_APP_1_PORT",
                    "value": "tcp://my-web-app-1-admin.alpha.tutum.io:49281"
                },
                {
                    "container": "/api/v1/container/7d6696b7-fbaf-471d-8e6b-ce7052586c24/",
                    "key": "MY_WEB_APP_1_PORT_80_TCP",
                    "value": "tcp://my-web-app-1-admin.alpha.tutum.io:49281"
                },
                {
                    "container": "/api/v1/container/7d6696b7-fbaf-471d-8e6b-ce7052586c24/",
                    "key": "MY_WEB_APP_1_PORT_80_TCP_ADDR",
                    "value": "my-web-app-1-admin.alpha.tutum.io"
                },
                {
                    "container": "/api/v1/container/7d6696b7-fbaf-471d-8e6b-ce7052586c24/",
                    "key": "MY_WEB_APP_1_PORT_80_TCP_PORT",
                    "value": "49281"
                },
                {
                    "container": "/api/v1/container/7d6696b7-fbaf-471d-8e6b-ce7052586c24/",
                    "key": "MY_WEB_APP_1_PORT_80_TCP_PROTO",
                    "value": "tcp"
                }
            ],
            "autoreplace": "OFF",
            "link_variables": {
                "MY_WEB_APP_2_PORT_80_TCP_PROTO": "tcp",
                "MY_WEB_APP_2_PORT_80_TCP_PORT": "49282",
                "MY_WEB_APP_2_PORT": "tcp://my-web-app-2-admin.alpha.tutum.io:49282",
                "MY_WEB_APP_2_PORT_80_TCP": "tcp://my-web-app-2-admin.alpha.tutum.io:49282",
                "MY_WEB_APP_2_PORT_80_TCP_ADDR": "my-web-app-2-admin.alpha.tutum.io"
            },
            "web_public_dns": "my-web-app.example.com"
        }

    :query uuid: the UUID of the container
    :jsonparam string web_public_dns: optional, the custom domain to use for this web application
    :reqheader Content-Type: required, only ``application/json`` is supported
    :reqheader Authorization: required ApiKey authentication header in the format ``ApiKey username:apikey``
    :reqheader Accept: required, only ``application/json`` is supported
    :statuscode 202: operation accepted
    :statuscode 404: container not found
    :statuscode 401: unauthorized (wrong credentials)

**Python library example**

.. sourcecode:: python

    >>> import tutum
    >>> container = tutum.Container.fetch("7d6696b7-fbaf-471d-8e6b-ce7052586c24")
    >>> container.web_public_dns = "my-web-app.example.com"
    >>> container.save()
    True


Start a container
^^^^^^^^^^^^^^^^^

.. http:post:: /api/v1/container/(uuid)/start/

    Starts a container that was previously stopped

    **Example request**:

    .. sourcecode:: http

        POST /api/v1/container/7d6696b7-fbaf-471d-8e6b-ce7052586c24/start/ HTTP/1.1
        Host: app.tutum.co
        Accept: application/json
        Authorization: ApiKey username:apikey

    **Example response**:

    .. sourcecode:: http

        HTTP/1.1 202 Accepted
        Cache-Control: must-revalidate, max-age=0
        Content-Type: application/json
        Vary: Accept, Authorization, Cookie

        {
            "exit_code": null,
            "deployed_datetime": "Mon, 24 Mar 2014 23:58:08 +0000",
            "application": "/api/v1/application/6fe5029e-c125-4088-9b9a-4e74da20ac58/",
            "container_ports": [
                {
                    "outer_port": 49282,
                    "inner_port": 80,
                    "protocol": "tcp",
                    "container": "/api/v1/container/7d6696b7-fbaf-471d-8e6b-ce7052586c24/"
                }
            ],
            "run_command": "/run.sh",
            "autodestroy": "OFF",
            "linked_to_application": [],
            "container_size": "XS",
            "started_datetime": "Mon, 24 Mar 2014 23:58:08 +0000",
            "uuid": "7d6696b7-fbaf-471d-8e6b-ce7052586c24",
            "name": "my-web-app",
            "autorestart": "OFF",
            "destroyed_datetime": null,
            "state": "Starting",
            "roles": [],
            "image_tag": "/api/v1/image/tutum/hello-world/tag/latest/",
            "stopped_datetime": "Mon, 24 Mar 2014 23:59:08 +0000",
            "resource_uri": "/api/v1/container/7d6696b7-fbaf-471d-8e6b-ce7052586c24/",
            "unique_name": "my-web-app-2",
            "linked_from_application": [],
            "exit_code_msg": null,
            "entrypoint": "",
            "public_dns": "my-web-app-2-admin.alpha.tutum.io",
            "container_envvars": [
                {
                    "container": "/api/v1/container/7d6696b7-fbaf-471d-8e6b-ce7052586c24/",
                    "key": "MY_WEB_APP_1_PORT",
                    "value": "tcp://my-web-app-1-admin.alpha.tutum.io:49281"
                },
                {
                    "container": "/api/v1/container/7d6696b7-fbaf-471d-8e6b-ce7052586c24/",
                    "key": "MY_WEB_APP_1_PORT_80_TCP",
                    "value": "tcp://my-web-app-1-admin.alpha.tutum.io:49281"
                },
                {
                    "container": "/api/v1/container/7d6696b7-fbaf-471d-8e6b-ce7052586c24/",
                    "key": "MY_WEB_APP_1_PORT_80_TCP_ADDR",
                    "value": "my-web-app-1-admin.alpha.tutum.io"
                },
                {
                    "container": "/api/v1/container/7d6696b7-fbaf-471d-8e6b-ce7052586c24/",
                    "key": "MY_WEB_APP_1_PORT_80_TCP_PORT",
                    "value": "49281"
                },
                {
                    "container": "/api/v1/container/7d6696b7-fbaf-471d-8e6b-ce7052586c24/",
                    "key": "MY_WEB_APP_1_PORT_80_TCP_PROTO",
                    "value": "tcp"
                }
            ],
            "autoreplace": "OFF",
            "link_variables": {
                "MY_WEB_APP_2_PORT_80_TCP_PROTO": "tcp",
                "MY_WEB_APP_2_PORT_80_TCP_PORT": "49282",
                "MY_WEB_APP_2_PORT": "tcp://my-web-app-2-admin.alpha.tutum.io:49282",
                "MY_WEB_APP_2_PORT_80_TCP": "tcp://my-web-app-2-admin.alpha.tutum.io:49282",
                "MY_WEB_APP_2_PORT_80_TCP_ADDR": "my-web-app-2-admin.alpha.tutum.io"
            },
            "web_public_dns": "my-web-app-2-admin.alpha.tutum.io"
        }

    :query uuid: the UUID of the container
    :reqheader Authorization: required ApiKey authentication header in the format ``ApiKey username:apikey``
    :reqheader Accept: required, only ``application/json`` is supported
    :statuscode 202: operation accepted
    :statuscode 400: cannot perform the operation (probably the container is not in a suitable state)
    :statuscode 401: unauthorized (wrong credentials)
    :statuscode 404: container not found

**Python library example**

.. sourcecode:: python

    >>> import tutum
    >>> container = tutum.Container.fetch("7d6696b7-fbaf-471d-8e6b-ce7052586c24")
    >>> container.start()
    True


Stop a container
^^^^^^^^^^^^^^^^

.. http:post:: /api/v1/container/(uuid)/stop/

    Stops a running container

    **Example request**:

    .. sourcecode:: http

        POST /api/v1/container/7d6696b7-fbaf-471d-8e6b-ce7052586c24/stop/ HTTP/1.1
        Host: app.tutum.co
        Accept: application/json
        Authorization: ApiKey username:apikey

    **Example response**:

    .. sourcecode:: http

        HTTP/1.1 202 Accepted
        Cache-Control: must-revalidate, max-age=0
        Content-Type: application/json
        Vary: Accept, Authorization, Cookie

        {
            "exit_code": null,
            "deployed_datetime": "Mon, 24 Mar 2014 23:58:08 +0000",
            "application": "/api/v1/application/6fe5029e-c125-4088-9b9a-4e74da20ac58/",
            "container_ports": [
                {
                    "outer_port": 49282,
                    "inner_port": 80,
                    "protocol": "tcp",
                    "container": "/api/v1/container/7d6696b7-fbaf-471d-8e6b-ce7052586c24/"
                }
            ],
            "run_command": "/run.sh",
            "autodestroy": "OFF",
            "linked_to_application": [],
            "container_size": "XS",
            "started_datetime": "Mon, 24 Mar 2014 23:58:08 +0000",
            "uuid": "7d6696b7-fbaf-471d-8e6b-ce7052586c24",
            "name": "my-web-app",
            "autorestart": "OFF",
            "destroyed_datetime": null,
            "state": "Stopping",
            "roles": [],
            "image_tag": "/api/v1/image/tutum/hello-world/tag/latest/",
            "stopped_datetime": null,
            "resource_uri": "/api/v1/container/7d6696b7-fbaf-471d-8e6b-ce7052586c24/",
            "unique_name": "my-web-app-2",
            "linked_from_application": [],
            "exit_code_msg": null,
            "entrypoint": "",
            "public_dns": "my-web-app-2-admin.alpha.tutum.io",
            "container_envvars": [
                {
                    "container": "/api/v1/container/7d6696b7-fbaf-471d-8e6b-ce7052586c24/",
                    "key": "MY_WEB_APP_1_PORT",
                    "value": "tcp://my-web-app-1-admin.alpha.tutum.io:49281"
                },
                {
                    "container": "/api/v1/container/7d6696b7-fbaf-471d-8e6b-ce7052586c24/",
                    "key": "MY_WEB_APP_1_PORT_80_TCP",
                    "value": "tcp://my-web-app-1-admin.alpha.tutum.io:49281"
                },
                {
                    "container": "/api/v1/container/7d6696b7-fbaf-471d-8e6b-ce7052586c24/",
                    "key": "MY_WEB_APP_1_PORT_80_TCP_ADDR",
                    "value": "my-web-app-1-admin.alpha.tutum.io"
                },
                {
                    "container": "/api/v1/container/7d6696b7-fbaf-471d-8e6b-ce7052586c24/",
                    "key": "MY_WEB_APP_1_PORT_80_TCP_PORT",
                    "value": "49281"
                },
                {
                    "container": "/api/v1/container/7d6696b7-fbaf-471d-8e6b-ce7052586c24/",
                    "key": "MY_WEB_APP_1_PORT_80_TCP_PROTO",
                    "value": "tcp"
                }
            ],
            "autoreplace": "OFF",
            "link_variables": {
                "MY_WEB_APP_2_PORT_80_TCP_PROTO": "tcp",
                "MY_WEB_APP_2_PORT_80_TCP_PORT": "49282",
                "MY_WEB_APP_2_PORT": "tcp://my-web-app-2-admin.alpha.tutum.io:49282",
                "MY_WEB_APP_2_PORT_80_TCP": "tcp://my-web-app-2-admin.alpha.tutum.io:49282",
                "MY_WEB_APP_2_PORT_80_TCP_ADDR": "my-web-app-2-admin.alpha.tutum.io"
            },
            "web_public_dns": "my-web-app-2-admin.alpha.tutum.io"
        }

    :query uuid: the UUID of the container
    :reqheader Authorization: required ApiKey authentication header in the format ``ApiKey username:apikey``
    :reqheader Accept: required, only ``application/json`` is supported
    :statuscode 202: operation accepted
    :statuscode 400: cannot perform the operation (probably the container is not in a suitable state)
    :statuscode 401: unauthorized (wrong credentials)
    :statuscode 404: container not found

**Python library example**

.. sourcecode:: python

    >>> import tutum
    >>> container = tutum.Container.fetch("7d6696b7-fbaf-471d-8e6b-ce7052586c24")
    >>> container.stop()
    True


Get logs for a container
^^^^^^^^^^^^^^^^^^^^^^^^

.. http:get:: /api/v1/container/(uuid)/logs/

    Returns the logs of the specified container

    **Example request**:

    .. sourcecode:: http

        POST /api/v1/container/7d6696b7-fbaf-471d-8e6b-ce7052586c24/stop/ HTTP/1.1
        Host: app.tutum.co
        Accept: application/json
        Authorization: ApiKey username:apikey

    **Example response**:

    .. sourcecode:: http

        HTTP/1.1 200 OK
        Cache-Control: must-revalidate, max-age=0
        Content-Type: application/json
        Vary: Accept, Authorization, Cookie

        {
            "logs" : "2014-03-24 23:58:08,973 CRIT Supervisor running as root (no user in config file)\n2014-03-24 23:58:08,973 WARN Included extra file \"/etc/supervisor/conf.d/supervisord-apache2.conf\" during parsing"
        }

    :query uuid: the UUID of the container
    :reqheader Authorization: required ApiKey authentication header in the format ``ApiKey username:apikey``
    :reqheader Accept: required, only ``application/json`` is supported
    :statuscode 200: no error
    :statuscode 401: unauthorized (wrong credentials)
    :statuscode 404: container not found

**Python library example**

.. sourcecode:: python

    >>> import tutum
    >>> container = tutum.Container.fetch("7d6696b7-fbaf-471d-8e6b-ce7052586c24")
    >>> container.logs()
    {"logs": "2014-03-24 23:58:08,973 CRIT Supervisor running as root (no user in config file)\n2014-03-24 23:58:08,973 WARN Included extra file \"/etc/supervisor/conf.d/supervisord-apache2.conf\" during parsing"}


Terminate a container
^^^^^^^^^^^^^^^^^^^^^

.. http:delete:: /api/v1/container/(uuid)/

    Destroy the specified container and update the target number of containers of the related application. This is not reversible.
    All the data stored in the container will be permanently deleted.

    **Example request**:

    .. sourcecode:: http

        DELETE /api/v1/container/7d6696b7-fbaf-471d-8e6b-ce7052586c24/ HTTP/1.1
        Host: app.tutum.co
        Accept: application/json
        Authorization: ApiKey username:apikey

    **Example response**:

    .. sourcecode:: http

        HTTP/1.1 202 Accepted
        Cache-Control: must-revalidate, max-age=0
        Content-Type: application/json
        Vary: Accept, Authorization, Cookie

        {
            "exit_code": null,
            "deployed_datetime": "Mon, 24 Mar 2014 23:58:08 +0000",
            "application": "/api/v1/application/6fe5029e-c125-4088-9b9a-4e74da20ac58/",
            "container_ports": [
                {
                    "outer_port": 49282,
                    "inner_port": 80,
                    "protocol": "tcp",
                    "container": "/api/v1/container/7d6696b7-fbaf-471d-8e6b-ce7052586c24/"
                }
            ],
            "run_command": "/run.sh",
            "autodestroy": "OFF",
            "linked_to_application": [],
            "container_size": "XS",
            "started_datetime": "Mon, 24 Mar 2014 23:58:08 +0000",
            "uuid": "7d6696b7-fbaf-471d-8e6b-ce7052586c24",
            "name": "my-web-app",
            "autorestart": "OFF",
            "destroyed_datetime": null,
            "state": "Stopping",
            "roles": [],
            "image_tag": "/api/v1/image/tutum/hello-world/tag/latest/",
            "stopped_datetime": null,
            "resource_uri": "/api/v1/container/7d6696b7-fbaf-471d-8e6b-ce7052586c24/",
            "unique_name": "my-web-app-2",
            "linked_from_application": [],
            "exit_code_msg": null,
            "entrypoint": "",
            "public_dns": "my-web-app-2-admin.alpha.tutum.io",
            "container_envvars": [
                {
                    "container": "/api/v1/container/7d6696b7-fbaf-471d-8e6b-ce7052586c24/",
                    "key": "MY_WEB_APP_1_PORT",
                    "value": "tcp://my-web-app-1-admin.alpha.tutum.io:49281"
                },
                {
                    "container": "/api/v1/container/7d6696b7-fbaf-471d-8e6b-ce7052586c24/",
                    "key": "MY_WEB_APP_1_PORT_80_TCP",
                    "value": "tcp://my-web-app-1-admin.alpha.tutum.io:49281"
                },
                {
                    "container": "/api/v1/container/7d6696b7-fbaf-471d-8e6b-ce7052586c24/",
                    "key": "MY_WEB_APP_1_PORT_80_TCP_ADDR",
                    "value": "my-web-app-1-admin.alpha.tutum.io"
                },
                {
                    "container": "/api/v1/container/7d6696b7-fbaf-471d-8e6b-ce7052586c24/",
                    "key": "MY_WEB_APP_1_PORT_80_TCP_PORT",
                    "value": "49281"
                },
                {
                    "container": "/api/v1/container/7d6696b7-fbaf-471d-8e6b-ce7052586c24/",
                    "key": "MY_WEB_APP_1_PORT_80_TCP_PROTO",
                    "value": "tcp"
                }
            ],
            "autoreplace": "OFF",
            "link_variables": {
                "MY_WEB_APP_2_PORT_80_TCP_PROTO": "tcp",
                "MY_WEB_APP_2_PORT_80_TCP_PORT": "49282",
                "MY_WEB_APP_2_PORT": "tcp://my-web-app-2-admin.alpha.tutum.io:49282",
                "MY_WEB_APP_2_PORT_80_TCP": "tcp://my-web-app-2-admin.alpha.tutum.io:49282",
                "MY_WEB_APP_2_PORT_80_TCP_ADDR": "my-web-app-2-admin.alpha.tutum.io"
            },
            "web_public_dns": "my-web-app-2-admin.alpha.tutum.io"
        }

    :query uuid: the UUID of the container
    :reqheader Authorization: required ApiKey authentication header in the format ``ApiKey username:apikey``
    :reqheader Accept: required, only ``application/json`` is supported
    :statuscode 202: operation accepted
    :statuscode 400: cannot perform the operation (probably the container is not in a suitable state)
    :statuscode 401: unauthorized (wrong credentials)
    :statuscode 404: container not found

**Python library example**

.. sourcecode:: python

    >>> import tutum
    >>> container = tutum.Container.fetch("7d6696b7-fbaf-471d-8e6b-ce7052586c24")
    >>> container.delete()
    True


.. _api-roles:

Roles
-----

List all available roles
^^^^^^^^^^^^^^^^^^^^^^^^

.. http:get:: /api/v1/role/

    This operation returns a list of all available roles to be used when launching an application.

    **Example request**:

    .. sourcecode:: http

        GET /api/v1/role/ HTTP/1.1
        Host: app.tutum.co
        Accept: application/json
        Authorization: ApiKey username:apikey

    **Example response**:

    .. sourcecode:: http

        HTTP/1.1 200 OK
        Cache-Control: must-revalidate, max-age=0
        Content-Type: application/json
        Vary: Accept, Authorization, Cookie

        {
            "meta": {
                "limit": 25,
                "next": null,
                "offset": 0,
                "previous": null,
                "total_count": 1
            },
            "objects": [
                {
                    "label": "Full access",
                    "resource_uri": "/api/v1/role/global/",
                    "scope": "global"
                }
            ]
        }

    :reqheader Authorization: required ApiKey authentication header in the format ``ApiKey username:apikey``
    :reqheader Accept: required, only ``application/json`` is supported
    :queryparam int offset: optional, start the list skipping the first ``offset`` records (default: 0)
    :queryparam int limit: optional, only return at most ``limit`` records (default: 25, max: 100)
    :statuscode 200: no error
    :statuscode 401: unauthorized (wrong credentials)

**Python library example**

.. sourcecode:: python

    >>> import tutum
    >>> tutum.Role.list()
    [<tutum.api.role.Role object at 0x10701ca90>]

``tutum.Role`` objects have all the attributes of the returned JSON as properties


Get role details
^^^^^^^^^^^^^^^^

.. http:get:: /api/v1/role/(scope)/

    Returns the details of the specified role

    **Example request**:

    .. sourcecode:: http

        GET /api/v1/role/global/ HTTP/1.1
        Host: app.tutum.co
        Accept: application/json
        Authorization: ApiKey username:apikey

    **Example response**:

    .. sourcecode:: http

        HTTP/1.1 200 OK
        Cache-Control: must-revalidate, max-age=0
        Content-Type: application/json
        Vary: Accept, Authorization, Cookie

        {
            "label": "Full access",
            "resource_uri": "/api/v1/role/global/",
            "scope": "global"
        }

    :query scope: the scope of the role
    :reqheader Authorization: required ApiKey authentication header in the format ``ApiKey username:apikey``
    :reqheader Accept: required, only ``application/json`` is supported
    :statuscode 200: no error
    :statuscode 404: role not found
    :statuscode 401: unauthorized (wrong credentials)

**Python library example**

.. sourcecode:: python

    >>> import tutum
    >>> tutum.Role.fetch("global")
    <tutum.api.role.Role object at 0x10701ca90>

``tutum.Role`` objects have all the attributes of the returned JSON as properties