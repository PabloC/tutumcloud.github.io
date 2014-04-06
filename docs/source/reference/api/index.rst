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
------

Errors in the HTTP API will be returned with status codes in the 4xx and 5xx ranges.

The Python library will detect this status codes and raise ``TutumApiError`` exceptions with the error message,
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
                    "autoreplace": "ALWAYS",
                    "autorestart": "ALWAYS",
                    "container_ports": [
                        {
                            "application": "/api/v1/application/7eaf7fff-882c-4f3d-9a8f-a22317ac00ce/",
                            "inner_port": 80,
                            "outer_port": null,
                            "protocol": "tcp"
                        }
                    ],
                    "container_size": "XS",
                    "current_num_containers": 2,
                    "deployed_datetime": "Sun, 6 Apr 2014 17:59:42 +0000",
                    "destroyed_datetime": null,
                    "entrypoint": "",
                    "image_tag": "/api/v1/image/tutum/hello-world/tag/latest/",
                    "name": "my-web-app",
                    "public_dns": "my-web-app-admin.dev.tutum.io",
                    "resource_uri": "/api/v1/application/7eaf7fff-882c-4f3d-9a8f-a22317ac00ce/",
                    "run_command": "/run.sh",
                    "running_num_containers": 2,
                    "started_datetime": "Sun, 6 Apr 2014 17:59:42 +0000",
                    "state": "Running",
                    "stopped_datetime": null,
                    "stopped_num_containers": 0,
                    "target_num_containers": 2,
                    "unique_name": "my-web-app",
                    "uuid": "7eaf7fff-882c-4f3d-9a8f-a22317ac00ce",
                    "web_public_dns": "myapp.example.com"
                }
            ]
        }

    :reqheader Authorization: required ApiKey authentication header in the format ``ApiKey username:apikey``
    :reqheader Accept: required, only ``application/json`` is supported
    :queryparam int offset: optional, start the list skipping the first ``offset`` records (default: 0)
    :queryparam int limit: optional, only return at most ``limit`` records (default: 25, max: 100)
    :queryparam string name: optional, filter applications by name
    :queryparam string uuid: optional, filter applications by UUID
    :queryparam string uuid__startswith: optional, filter applications by UUIDs that start with the given string
    :queryparam string state: optional, filter applications by state
    :statuscode 200: no error
    :statuscode 401: unauthorized (wrong credentials)

**Python library example**

.. sourcecode:: python

    >>> import tutum
    >>> tutum.Application.list()
    [<tutum.api.application.Application object at 0x10701ca90>, <tutum.api.application.Application object at 0x10701ca91>]
    >>> tutum.Application.list(name="my-web-app")
    [<tutum.api.application.Application object at 0x10701ca90>]
    >>> tutum.Application.list(uuid__startswith="7eaf7fff")
    [<tutum.api.application.Application object at 0x10701ca90>]


``Application`` objects have all the attributes of the returned JSON as properties

.. _api-application-ref:

Get application details
^^^^^^^^^^^^^^^^^^^^^^^

.. http:get:: /api/v1/application/(uuid)/

    Get all the details of an specific application

    **Example request**:

    .. sourcecode:: http

        GET /api/v1/application/7eaf7fff-882c-4f3d-9a8f-a22317ac00ce/ HTTP/1.1
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
            "autoreplace": "ALWAYS",
            "autorestart": "ALWAYS",
            "container_envvars": [
                {
                    "application": "/api/v1/application/7eaf7fff-882c-4f3d-9a8f-a22317ac00ce/",
                    "key": "ENVIRONMENT",
                    "value": "dev"
                }
            ],
            "container_ports": [
                {
                    "application": "/api/v1/application/7eaf7fff-882c-4f3d-9a8f-a22317ac00ce/",
                    "inner_port": 80,
                    "outer_port": null,
                    "protocol": "tcp"
                }
            ],
            "container_size": "XS",
            "containers": [
                "/api/v1/container/285b1f78-acda-4360-a1c4-1282c5e2a287/",
                "/api/v1/container/fbb94d30-9b38-46d2-b7b2-03d8dc05e9ee/"
            ],
            "current_num_containers": 2,
            "deployed_datetime": "Sun, 6 Apr 2014 17:59:42 +0000",
            "destroyed_datetime": null,
            "entrypoint": "",
            "image_tag": "/api/v1/image/tutum/hello-world/tag/latest/",
            "link_variables": {
                "MY_WEB_APP_1_PORT": "tcp://my-web-app-1-admin.alpha-dev.tutum.io:49219",
                "MY_WEB_APP_1_PORT_80_TCP": "tcp://my-web-app-1-admin.alpha-dev.tutum.io:49219",
                "MY_WEB_APP_1_PORT_80_TCP_ADDR": "my-web-app-1-admin.alpha-dev.tutum.io",
                "MY_WEB_APP_1_PORT_80_TCP_PORT": "49219",
                "MY_WEB_APP_1_PORT_80_TCP_PROTO": "tcp",
                "MY_WEB_APP_2_PORT": "tcp://my-web-app-2-admin.alpha-dev.tutum.io:49220",
                "MY_WEB_APP_2_PORT_80_TCP": "tcp://my-web-app-2-admin.alpha-dev.tutum.io:49220",
                "MY_WEB_APP_2_PORT_80_TCP_ADDR": "my-web-app-2-admin.alpha-dev.tutum.io",
                "MY_WEB_APP_2_PORT_80_TCP_PORT": "49220",
                "MY_WEB_APP_2_PORT_80_TCP_PROTO": "tcp",
                "MY_WEB_APP_TUTUM_API_URL": "https://app.tutum.co/api/v1/application/7eaf7fff-882c-4f3d-9a8f-a22317ac00ce/"
            },
            "linked_from_application": [],
            "linked_to_application": [],
            "name": "my-web-app",
            "public_dns": "my-web-app-admin.dev.tutum.io",
            "resource_uri": "/api/v1/application/7eaf7fff-882c-4f3d-9a8f-a22317ac00ce/",
            "roles": [],
            "run_command": "/run.sh",
            "running_num_containers": 2,
            "started_datetime": "Sun, 6 Apr 2014 17:59:42 +0000",
            "state": "Running",
            "stopped_datetime": null,
            "stopped_num_containers": 0,
            "target_num_containers": 2,
            "unique_name": "my-web-app",
            "uuid": "7eaf7fff-882c-4f3d-9a8f-a22317ac00ce",
            "web_public_dns": "myapp.example.com"
        }

    :query uuid: the UUID of the application
    :reqheader Authorization: required ApiKey authentication header in the format ``ApiKey username:apikey``
    :reqheader Accept: required, only ``application/json`` is supported
    :statuscode 200: no error
    :statuscode 401: unauthorized (wrong credentials)
    :statuscode 404: application not found

**Python library example**

.. sourcecode:: python

    >>> import tutum
    >>> tutum.Application.fetch("7eaf7fff-882c-4f3d-9a8f-a22317ac00ce")
    <tutum.api.application.Application object at 0x106c45c10>
    >>> tutum.Application.fetch("7eaf7fff-882c-4f3d-9a8f-a22317ac00ce").name
    "my-web-app"


``Application`` objects have all the attributes of the returned JSON as properties

.. _api-launch-app:

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
            "image": "tutum/hello-world",
            "name": "my-awesome-app",
            "target_num_containers": 2,
            "container_size": "XS",
            "web_public_dns": "awesome-app.example.com"
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
                    "application": "/api/v1/application/1f234d1d-dae5-46c1-9ee5-770575fe3e6f/",
                    "inner_port": 80,
                    "outer_port": null,
                    "protocol": "tcp"
                }
            ],
            "container_size": "XS",
            "containers": [
                "/api/v1/container/4a7c672c-4f55-4417-9300-c932eabe7f7e/",
                "/api/v1/container/f5d64083-7698-4aec-b5dc-86a48be0f565/"
            ],
            "current_num_containers": 2,
            "deployed_datetime": null,
            "destroyed_datetime": null,
            "entrypoint": "",
            "image_tag": "/api/v1/image/tutum/hello-world/tag/latest/",
            "link_variables": {
                "MY_AWESOME_APP_TUTUM_API_URL": "https://app.tutum.co/api/v1/application/1f234d1d-dae5-46c1-9ee5-770575fe3e6f/"
            },
            "linked_from_application": [],
            "linked_to_application": [],
            "name": "my-awesome-app",
            "public_dns": "my-awesome-app-admin.dev.tutum.io",
            "resource_uri": "/api/v1/application/1f234d1d-dae5-46c1-9ee5-770575fe3e6f/",
            "roles": [],
            "run_command": "/run.sh",
            "running_num_containers": 0,
            "started_datetime": null,
            "state": "Starting",
            "stopped_datetime": null,
            "stopped_num_containers": 0,
            "target_num_containers": 2,
            "unique_name": "my-awesome-app",
            "uuid": "1f234d1d-dae5-46c1-9ee5-770575fe3e6f",
            "web_public_dns": "awesome-app.example.com"
        }

    :jsonparam string image: required, the image used to deploy this application in docker format, i.e. ``tutum/hello-world``.
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
    :jsonparam array(string) roles: optional, a list of Tutum API roles to grant the application, i.e. ``["global"]`` (default: empty array, possible values: ``global``)
    :jsonparam string web_public_dns: optional, a custom domain name to be used as CNAME for the application web endpoint, only available if the application listens in port 80, i.e. ``my-app.example.com`` (default: none)
    :reqheader Content-Type: required, only ``application/json`` is supported
    :reqheader Authorization: required ApiKey authentication header in the format ``ApiKey username:apikey``
    :reqheader Accept: required, only ``application/json`` is supported
    :statuscode 202: operation accepted
    :statuscode 400: cannot perform the operation (probably there was a validation error on the given parameters)
    :statuscode 401: unauthorized (wrong credentials)

**Python library example**

.. sourcecode:: python

    >>> import tutum
    >>> app = tutum.Application.create(image="tutum/hello-world", name="my-new-app", target_num_containers=2, container_size="XS")
    >>> app.save()
    True
    >>> app.state
    "Starting"
    >>> app.refresh()
    True
    >>> app.state
    "Running"


Update an application
^^^^^^^^^^^^^^^^^^^^^

.. http:patch:: /api/v1/application/(uuid)/

    Updates the application details and scales the application up or down accordingly

    **Example request**:

    .. sourcecode:: http

        PATCH /api/v1/application/7eaf7fff-882c-4f3d-9a8f-a22317ac00ce/ HTTP/1.1
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
          "target_num_containers" : 3,
          "deployed_datetime" : "Sun, 6 Apr 2014 17:59:42 +0000",
          "container_ports" : [
            {
              "outer_port" : null,
              "inner_port" : 80,
              "protocol" : "tcp",
              "application" : "/api/v1/application/7eaf7fff-882c-4f3d-9a8f-a22317ac00ce/"
            }
          ],
          "current_num_containers" : 3,
          "run_command" : "/run.sh",
          "autodestroy" : "OFF",
          "linked_to_application" : [],
          "container_size" : "XS",
          "started_datetime" : "Sun, 6 Apr 2014 17:59:42 +0000",
          "stopped_num_containers" : 0,
          "uuid" : "7eaf7fff-882c-4f3d-9a8f-a22317ac00ce",
          "name" : "my-web-app",
          "autorestart" : "ALWAYS",
          "destroyed_datetime" : null,
          "state" : "Scaling",
          "roles" : [],
          "containers" : [
            "/api/v1/container/285b1f78-acda-4360-a1c4-1282c5e2a287/",
            "/api/v1/container/fbb94d30-9b38-46d2-b7b2-03d8dc05e9ee/",
            "/api/v1/container/47a0411a-9f9d-4824-bbcd-f0761ac51c89/"
          ],
          "image_tag" : "/api/v1/image/tutum/hello-world/tag/latest/",
          "running_num_containers" : 2,
          "resource_uri" : "/api/v1/application/7eaf7fff-882c-4f3d-9a8f-a22317ac00ce/",
          "stopped_datetime" : null,
          "unique_name" : "my-web-app",
          "linked_from_application" : [],
          "web_public_dns" : "myapp.example.com",
          "entrypoint" : "",
          "public_dns" : "my-web-app-admin.dev.tutum.io",
          "container_envvars" : [
            {
              "key" : "ENVIRONMENT",
              "application" : "/api/v1/application/7eaf7fff-882c-4f3d-9a8f-a22317ac00ce/",
              "value" : "dev"
            }
          ],
          "autoreplace" : "ALWAYS",
          "link_variables" : {
            "MY_WEB_APP_2_PORT_80_TCP" : "tcp://my-web-app-2-admin.alpha-dev.tutum.io:49220",
            "MY_WEB_APP_TUTUM_API_URL" : "https://app.tutum.co/api/v1/application/7eaf7fff-882c-4f3d-9a8f-a22317ac00ce/",
            "MY_WEB_APP_2_PORT" : "tcp://my-web-app-2-admin.alpha-dev.tutum.io:49220",
            "MY_WEB_APP_1_PORT_80_TCP_PROTO" : "tcp",
            "MY_WEB_APP_1_PORT" : "tcp://my-web-app-1-admin.alpha-dev.tutum.io:49219",
            "MY_WEB_APP_1_PORT_80_TCP_PORT" : "49219",
            "MY_WEB_APP_2_PORT_80_TCP_PORT" : "49220",
            "MY_WEB_APP_2_PORT_80_TCP_PROTO" : "tcp",
            "MY_WEB_APP_1_PORT_80_TCP" : "tcp://my-web-app-1-admin.alpha-dev.tutum.io:49219",
            "MY_WEB_APP_1_PORT_80_TCP_ADDR" : "my-web-app-1-admin.alpha-dev.tutum.io",
            "MY_WEB_APP_2_PORT_80_TCP_ADDR" : "my-web-app-2-admin.alpha-dev.tutum.io"
          }
        }

    :query uuid: the UUID of the application
    :jsonparam int target_num_containers: optional, the target number of containers to scale this application to
    :jsonparam string web_public_dns: optional, the custom domain name to use for this web application
    :reqheader Content-Type: required, only ``application/json`` is supported
    :reqheader Authorization: required ApiKey authentication header in the format ``ApiKey username:apikey``
    :reqheader Accept: required, only ``application/json`` is supported
    :statuscode 202: operation accepted
    :statuscode 400: cannot perform the operation (probably the application is not in a suitable state)
    :statuscode 401: unauthorized (wrong credentials)


**Python library example**

.. sourcecode:: python

    >>> import tutum
    >>> app = tutum.Application.fetch("7eaf7fff-882c-4f3d-9a8f-a22317ac00ce")
    >>> app.target_num_containers = 3
    >>> app.save()
    True
    >>> app.state
    "Scaling"
    >>> app.refresh()
    True
    >>> app.state
    "Running"


Start an application
^^^^^^^^^^^^^^^^^^^^

.. http:post:: /api/v1/application/(uuid)/start/

    Starts all the containers in a stopped application

    **Example request**:

    .. sourcecode:: http

        POST /api/v1/application/7eaf7fff-882c-4f3d-9a8f-a22317ac00ce/start/ HTTP/1.1
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
            "autodestroy": "OFF",
            "autoreplace": "ALWAYS",
            "autorestart": "ALWAYS",
            "container_envvars": [
                {
                    "application": "/api/v1/application/7eaf7fff-882c-4f3d-9a8f-a22317ac00ce/",
                    "key": "ENVIRONMENT",
                    "value": "dev"
                }
            ],
            "container_ports": [
                {
                    "application": "/api/v1/application/7eaf7fff-882c-4f3d-9a8f-a22317ac00ce/",
                    "inner_port": 80,
                    "outer_port": null,
                    "protocol": "tcp"
                }
            ],
            "container_size": "XS",
            "containers": [
                "/api/v1/container/285b1f78-acda-4360-a1c4-1282c5e2a287/",
                "/api/v1/container/fbb94d30-9b38-46d2-b7b2-03d8dc05e9ee/",
                "/api/v1/container/47a0411a-9f9d-4824-bbcd-f0761ac51c89/"
            ],
            "current_num_containers": 3,
            "deployed_datetime": "Sun, 6 Apr 2014 17:59:42 +0000",
            "destroyed_datetime": null,
            "entrypoint": "",
            "image_tag": "/api/v1/image/tutum/hello-world/tag/latest/",
            "link_variables": {
                "MY_WEB_APP_TUTUM_API_URL": "https://app.tutum.co/api/v1/application/7eaf7fff-882c-4f3d-9a8f-a22317ac00ce/"
            },
            "linked_from_application": [],
            "linked_to_application": [],
            "name": "my-web-app",
            "public_dns": "my-web-app-admin.dev.tutum.io",
            "resource_uri": "/api/v1/application/7eaf7fff-882c-4f3d-9a8f-a22317ac00ce/",
            "roles": [],
            "run_command": "/run.sh",
            "running_num_containers": 0,
            "started_datetime": "Sun, 6 Apr 2014 17:59:42 +0000",
            "state": "Starting",
            "stopped_datetime": "Sun, 6 Apr 2014 18:21:22 +0000",
            "stopped_num_containers": 0,
            "target_num_containers": 3,
            "unique_name": "my-web-app",
            "uuid": "7eaf7fff-882c-4f3d-9a8f-a22317ac00ce",
            "web_public_dns": "myapp.example.com"
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
    >>> app.state
    "Starting"
    >>> app.refresh()
    True
    >>> app.state
    "Running"


Stop an application
^^^^^^^^^^^^^^^^^^^

.. http:post:: /api/v1/application/(uuid)/stop/

    Stops all the containers in a running application

    **Example request**:

    .. sourcecode:: http

        POST /api/v1/application/7eaf7fff-882c-4f3d-9a8f-a22317ac00ce/stop/ HTTP/1.1
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
            "autodestroy": "OFF",
            "autoreplace": "ALWAYS",
            "autorestart": "ALWAYS",
            "container_envvars": [
                {
                    "application": "/api/v1/application/7eaf7fff-882c-4f3d-9a8f-a22317ac00ce/",
                    "key": "ENVIRONMENT",
                    "value": "dev"
                }
            ],
            "container_ports": [
                {
                    "application": "/api/v1/application/7eaf7fff-882c-4f3d-9a8f-a22317ac00ce/",
                    "inner_port": 80,
                    "outer_port": null,
                    "protocol": "tcp"
                }
            ],
            "container_size": "XS",
            "containers": [
                "/api/v1/container/285b1f78-acda-4360-a1c4-1282c5e2a287/",
                "/api/v1/container/fbb94d30-9b38-46d2-b7b2-03d8dc05e9ee/",
                "/api/v1/container/47a0411a-9f9d-4824-bbcd-f0761ac51c89/"
            ],
            "current_num_containers": 3,
            "deployed_datetime": "Sun, 6 Apr 2014 17:59:42 +0000",
            "destroyed_datetime": null,
            "entrypoint": "",
            "image_tag": "/api/v1/image/tutum/hello-world/tag/latest/",
            "link_variables": {
                "MY_WEB_APP_TUTUM_API_URL": "https://app.tutum.co/api/v1/application/7eaf7fff-882c-4f3d-9a8f-a22317ac00ce/"
            },
            "linked_from_application": [],
            "linked_to_application": [],
            "name": "my-web-app",
            "public_dns": "my-web-app-admin.dev.tutum.io",
            "resource_uri": "/api/v1/application/7eaf7fff-882c-4f3d-9a8f-a22317ac00ce/",
            "roles": [],
            "run_command": "/run.sh",
            "running_num_containers": 0,
            "started_datetime": "Sun, 6 Apr 2014 17:59:42 +0000",
            "state": "Stopping",
            "stopped_datetime": null,
            "stopped_num_containers": 0,
            "target_num_containers": 3,
            "unique_name": "my-web-app",
            "uuid": "7eaf7fff-882c-4f3d-9a8f-a22317ac00ce",
            "web_public_dns": "myapp.example.com"
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
    >>> app = tutum.Application.fetch("7eaf7fff-882c-4f3d-9a8f-a22317ac00ce")
    >>> app.stop()
    True
    >>> app.state
    "Stopping"
    >>> app.refresh()
    True
    >>> app.state
    "Stopped"


Terminate an application
^^^^^^^^^^^^^^^^^^^^^^^^

.. http:delete:: /api/v1/application/(uuid)/

    Destroy all the containers in an application. This is not reversible. All the data stored in all the application containers will be permanently deleted.

    **Example request**:

    .. sourcecode:: http

        DELETE /api/v1/application/7eaf7fff-882c-4f3d-9a8f-a22317ac00ce/ HTTP/1.1
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
            "autodestroy": "OFF",
            "autoreplace": "ALWAYS",
            "autorestart": "ALWAYS",
            "container_envvars": [
                {
                    "application": "/api/v1/application/7eaf7fff-882c-4f3d-9a8f-a22317ac00ce/",
                    "key": "ENVIRONMENT",
                    "value": "dev"
                }
            ],
            "container_ports": [
                {
                    "application": "/api/v1/application/7eaf7fff-882c-4f3d-9a8f-a22317ac00ce/",
                    "inner_port": 80,
                    "outer_port": null,
                    "protocol": "tcp"
                }
            ],
            "container_size": "XS",
            "containers": [
                "/api/v1/container/285b1f78-acda-4360-a1c4-1282c5e2a287/",
                "/api/v1/container/fbb94d30-9b38-46d2-b7b2-03d8dc05e9ee/",
                "/api/v1/container/47a0411a-9f9d-4824-bbcd-f0761ac51c89/"
            ],
            "current_num_containers": 3,
            "deployed_datetime": "Sun, 6 Apr 2014 17:59:42 +0000",
            "destroyed_datetime": null,
            "entrypoint": "",
            "image_tag": "/api/v1/image/tutum/hello-world/tag/latest/",
            "link_variables": {
                "MY_WEB_APP_TUTUM_API_URL": "https://app.tutum.co/api/v1/application/7eaf7fff-882c-4f3d-9a8f-a22317ac00ce/"
            },
            "linked_from_application": [],
            "linked_to_application": [],
            "name": "my-web-app",
            "public_dns": "my-web-app-admin.dev.tutum.io",
            "resource_uri": "/api/v1/application/7eaf7fff-882c-4f3d-9a8f-a22317ac00ce/",
            "roles": [],
            "run_command": "/run.sh",
            "running_num_containers": 0,
            "started_datetime": "Sun, 6 Apr 2014 18:23:56 +0000",
            "state": "Terminating",
            "stopped_datetime": "Sun, 6 Apr 2014 18:21:22 +0000",
            "stopped_num_containers": 0,
            "target_num_containers": 3,
            "unique_name": "my-web-app",
            "uuid": "7eaf7fff-882c-4f3d-9a8f-a22317ac00ce",
            "web_public_dns": "myapp.example.com"
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
    >>> app.state
    "Terminating"
    >>> app.refresh()
    True
    >>> app.state
    "Terminated"


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
                "limit": 25,
                "next": null,
                "offset": 0,
                "previous": null,
                "total_count": 2
            },
            "objects": [
                {
                    "application": "/api/v1/application/1f234d1d-dae5-46c1-9ee5-770575fe3e6f/",
                    "autodestroy": "OFF",
                    "autoreplace": "OFF",
                    "autorestart": "OFF",
                    "container_ports": [
                        {
                            "container": "/api/v1/container/4a7c672c-4f55-4417-9300-c932eabe7f7e/",
                            "inner_port": 80,
                            "outer_port": 49221,
                            "protocol": "tcp"
                        }
                    ],
                    "container_size": "XS",
                    "deployed_datetime": "Sun, 6 Apr 2014 18:11:17 +0000",
                    "destroyed_datetime": null,
                    "entrypoint": "",
                    "exit_code": null,
                    "exit_code_msg": null,
                    "image_tag": "/api/v1/image/tutum/hello-world/tag/latest/",
                    "name": "my-awesome-app",
                    "public_dns": "my-awesome-app-1-admin.alpha-dev.tutum.io",
                    "resource_uri": "/api/v1/container/4a7c672c-4f55-4417-9300-c932eabe7f7e/",
                    "run_command": "/run.sh",
                    "started_datetime": "Sun, 6 Apr 2014 18:11:17 +0000",
                    "state": "Running",
                    "stopped_datetime": null,
                    "unique_name": "my-awesome-app-1",
                    "uuid": "4a7c672c-4f55-4417-9300-c932eabe7f7e"
                },
                {
                    "application": "/api/v1/application/1f234d1d-dae5-46c1-9ee5-770575fe3e6f/",
                    "autodestroy": "OFF",
                    "autoreplace": "OFF",
                    "autorestart": "OFF",
                    "container_ports": [
                        {
                            "container": "/api/v1/container/f5d64083-7698-4aec-b5dc-86a48be0f565/",
                            "inner_port": 80,
                            "outer_port": 49222,
                            "protocol": "tcp"
                        }
                    ],
                    "container_size": "XS",
                    "deployed_datetime": "Sun, 6 Apr 2014 18:11:22 +0000",
                    "destroyed_datetime": null,
                    "entrypoint": "",
                    "exit_code": null,
                    "exit_code_msg": null,
                    "image_tag": "/api/v1/image/tutum/hello-world/tag/latest/",
                    "name": "my-awesome-app",
                    "public_dns": "my-awesome-app-2-admin.alpha-dev.tutum.io",
                    "resource_uri": "/api/v1/container/f5d64083-7698-4aec-b5dc-86a48be0f565/",
                    "run_command": "/run.sh",
                    "started_datetime": "Sun, 6 Apr 2014 18:11:22 +0000",
                    "state": "Running",
                    "stopped_datetime": null,
                    "unique_name": "my-awesome-app-2",
                    "uuid": "f5d64083-7698-4aec-b5dc-86a48be0f565"
                }
            ]
        }

    :reqheader Authorization: required ApiKey authentication header in the format ``ApiKey username:apikey``
    :reqheader Accept: required, only ``application/json`` is supported
    :queryparam int offset: optional, start the list skipping the first ``offset`` records (default: 0)
    :queryparam int limit: optional, only return at most ``limit`` records (default: 25, max: 100)
    :queryparam string name: optional, filter containers by name
    :queryparam string uuid: optional, filter containers by UUID
    :queryparam string uuid__startswith: optional, filter containers by UUIDs that start with the given string
    :queryparam string state: optional, filter containers by state
    :queryparam string application__name: optional, filter containers by application name
    :queryparam string application__uuid: optional, filter containers by application UUID
    :queryparam string application__state: optional, filter containers by application state
    :statuscode 200: no error
    :statuscode 401: unauthorized (wrong credentials)


**Python library example**

.. sourcecode:: python

    >>> import tutum
    >>> tutum.Container.list()
    [<tutum.api.container.Container object at 0x10701ca90>, <tutum.api.container.Container object at 0x10701ca91>]
    >>> tutum.Container.list(name="my-web-app-1")
    [<tutum.api.container.Container object at 0x10701ca90>]


``Container`` objects have all the attributes of the returned JSON as properties


Get container details
^^^^^^^^^^^^^^^^^^^^^

.. http:get:: /api/v1/container/(uuid)/

    Get all the details of an specific container

    **Example request**:

    .. sourcecode:: http

        GET /api/v1/container/f5d64083-7698-4aec-b5dc-86a48be0f565/ HTTP/1.1
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
            "application": "/api/v1/application/1f234d1d-dae5-46c1-9ee5-770575fe3e6f/",
            "autodestroy": "OFF",
            "autoreplace": "OFF",
            "autorestart": "OFF",
            "container_envvars": [
                {
                    "container": "/api/v1/container/f5d64083-7698-4aec-b5dc-86a48be0f565/",
                    "key": "MY_AWESOME_APP_1_PORT",
                    "value": "tcp://my-awesome-app-1-admin.alpha-dev.tutum.io:49221"
                },
                {
                    "container": "/api/v1/container/f5d64083-7698-4aec-b5dc-86a48be0f565/",
                    "key": "MY_AWESOME_APP_1_PORT_80_TCP",
                    "value": "tcp://my-awesome-app-1-admin.alpha-dev.tutum.io:49221"
                },
                {
                    "container": "/api/v1/container/f5d64083-7698-4aec-b5dc-86a48be0f565/",
                    "key": "MY_AWESOME_APP_1_PORT_80_TCP_ADDR",
                    "value": "my-awesome-app-1-admin.alpha-dev.tutum.io"
                },
                {
                    "container": "/api/v1/container/f5d64083-7698-4aec-b5dc-86a48be0f565/",
                    "key": "MY_AWESOME_APP_1_PORT_80_TCP_PORT",
                    "value": "49221"
                },
                {
                    "container": "/api/v1/container/f5d64083-7698-4aec-b5dc-86a48be0f565/",
                    "key": "MY_AWESOME_APP_1_PORT_80_TCP_PROTO",
                    "value": "tcp"
                }
            ],
            "container_ports": [
                {
                    "container": "/api/v1/container/f5d64083-7698-4aec-b5dc-86a48be0f565/",
                    "inner_port": 80,
                    "outer_port": 49222,
                    "protocol": "tcp"
                }
            ],
            "container_size": "XS",
            "deployed_datetime": "Sun, 6 Apr 2014 18:11:22 +0000",
            "destroyed_datetime": null,
            "entrypoint": "",
            "exit_code": null,
            "exit_code_msg": null,
            "image_tag": "/api/v1/image/tutum/hello-world/tag/latest/",
            "link_variables": {
                "MY_AWESOME_APP_2_PORT": "tcp://my-awesome-app-2-admin.alpha-dev.tutum.io:49222",
                "MY_AWESOME_APP_2_PORT_80_TCP": "tcp://my-awesome-app-2-admin.alpha-dev.tutum.io:49222",
                "MY_AWESOME_APP_2_PORT_80_TCP_ADDR": "my-awesome-app-2-admin.alpha-dev.tutum.io",
                "MY_AWESOME_APP_2_PORT_80_TCP_PORT": "49222",
                "MY_AWESOME_APP_2_PORT_80_TCP_PROTO": "tcp"
            },
            "linked_from_application": [],
            "linked_to_application": [],
            "name": "my-awesome-app",
            "public_dns": "my-awesome-app-2-admin.alpha-dev.tutum.io",
            "resource_uri": "/api/v1/container/f5d64083-7698-4aec-b5dc-86a48be0f565/",
            "roles": [],
            "run_command": "/run.sh",
            "started_datetime": "Sun, 6 Apr 2014 18:11:22 +0000",
            "state": "Running",
            "stopped_datetime": null,
            "unique_name": "my-awesome-app-2",
            "uuid": "f5d64083-7698-4aec-b5dc-86a48be0f565"
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
    >>> tutum.Container.fetch("f5d64083-7698-4aec-b5dc-86a48be0f565")
    <tutum.api.container.Container object at 0x10701ca90>
    >>> tutum.Container.fetch("f5d64083-7698-4aec-b5dc-86a48be0f565").name
    "my-awesome-app"


``Container`` objects have all the attributes of the returned JSON as properties


Start a container
^^^^^^^^^^^^^^^^^

.. http:post:: /api/v1/container/(uuid)/start/

    Starts a container that was previously stopped

    **Example request**:

    .. sourcecode:: http

        POST /api/v1/container/f5d64083-7698-4aec-b5dc-86a48be0f565/start/ HTTP/1.1
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
            "application": "/api/v1/application/1f234d1d-dae5-46c1-9ee5-770575fe3e6f/",
            "autodestroy": "OFF",
            "autoreplace": "OFF",
            "autorestart": "OFF",
            "container_envvars": [
                {
                    "container": "/api/v1/container/f5d64083-7698-4aec-b5dc-86a48be0f565/",
                    "key": "MY_AWESOME_APP_1_PORT",
                    "value": "tcp://my-awesome-app-1-admin.alpha-dev.tutum.io:49221"
                },
                {
                    "container": "/api/v1/container/f5d64083-7698-4aec-b5dc-86a48be0f565/",
                    "key": "MY_AWESOME_APP_1_PORT_80_TCP",
                    "value": "tcp://my-awesome-app-1-admin.alpha-dev.tutum.io:49221"
                },
                {
                    "container": "/api/v1/container/f5d64083-7698-4aec-b5dc-86a48be0f565/",
                    "key": "MY_AWESOME_APP_1_PORT_80_TCP_ADDR",
                    "value": "my-awesome-app-1-admin.alpha-dev.tutum.io"
                },
                {
                    "container": "/api/v1/container/f5d64083-7698-4aec-b5dc-86a48be0f565/",
                    "key": "MY_AWESOME_APP_1_PORT_80_TCP_PORT",
                    "value": "49221"
                },
                {
                    "container": "/api/v1/container/f5d64083-7698-4aec-b5dc-86a48be0f565/",
                    "key": "MY_AWESOME_APP_1_PORT_80_TCP_PROTO",
                    "value": "tcp"
                }
            ],
            "container_ports": [
                {
                    "container": "/api/v1/container/f5d64083-7698-4aec-b5dc-86a48be0f565/",
                    "inner_port": 80,
                    "outer_port": 49222,
                    "protocol": "tcp"
                }
            ],
            "container_size": "XS",
            "deployed_datetime": "Sun, 6 Apr 2014 18:11:22 +0000",
            "destroyed_datetime": null,
            "entrypoint": "",
            "exit_code": 0,
            "exit_code_msg": "Exit code 0 (Success)",
            "image_tag": "/api/v1/image/tutum/hello-world/tag/latest/",
            "link_variables": {
                "MY_AWESOME_APP_2_PORT": "tcp://my-awesome-app-2-admin.alpha-dev.tutum.io:49222",
                "MY_AWESOME_APP_2_PORT_80_TCP": "tcp://my-awesome-app-2-admin.alpha-dev.tutum.io:49222",
                "MY_AWESOME_APP_2_PORT_80_TCP_ADDR": "my-awesome-app-2-admin.alpha-dev.tutum.io",
                "MY_AWESOME_APP_2_PORT_80_TCP_PORT": "49222",
                "MY_AWESOME_APP_2_PORT_80_TCP_PROTO": "tcp"
            },
            "linked_from_application": [],
            "linked_to_application": [],
            "name": "my-awesome-app",
            "public_dns": "my-awesome-app-2-admin.alpha-dev.tutum.io",
            "resource_uri": "/api/v1/container/f5d64083-7698-4aec-b5dc-86a48be0f565/",
            "roles": [],
            "run_command": "/run.sh",
            "started_datetime": "Sun, 6 Apr 2014 18:11:22 +0000",
            "state": "Starting",
            "stopped_datetime": "Sun, 6 Apr 2014 18:33:53 +0000",
            "unique_name": "my-awesome-app-2",
            "uuid": "f5d64083-7698-4aec-b5dc-86a48be0f565"
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
    >>> container.state
    "Starting"
    >>> container.refresh()
    True
    >>> container.state
    "Running"


Stop a container
^^^^^^^^^^^^^^^^

.. http:post:: /api/v1/container/(uuid)/stop/

    Stops a running container

    **Example request**:

    .. sourcecode:: http

        POST /api/v1/container/f5d64083-7698-4aec-b5dc-86a48be0f565/stop/ HTTP/1.1
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
            "application": "/api/v1/application/1f234d1d-dae5-46c1-9ee5-770575fe3e6f/",
            "autodestroy": "OFF",
            "autoreplace": "OFF",
            "autorestart": "OFF",
            "container_envvars": [
                {
                    "container": "/api/v1/container/f5d64083-7698-4aec-b5dc-86a48be0f565/",
                    "key": "MY_AWESOME_APP_1_PORT",
                    "value": "tcp://my-awesome-app-1-admin.alpha-dev.tutum.io:49221"
                },
                {
                    "container": "/api/v1/container/f5d64083-7698-4aec-b5dc-86a48be0f565/",
                    "key": "MY_AWESOME_APP_1_PORT_80_TCP",
                    "value": "tcp://my-awesome-app-1-admin.alpha-dev.tutum.io:49221"
                },
                {
                    "container": "/api/v1/container/f5d64083-7698-4aec-b5dc-86a48be0f565/",
                    "key": "MY_AWESOME_APP_1_PORT_80_TCP_ADDR",
                    "value": "my-awesome-app-1-admin.alpha-dev.tutum.io"
                },
                {
                    "container": "/api/v1/container/f5d64083-7698-4aec-b5dc-86a48be0f565/",
                    "key": "MY_AWESOME_APP_1_PORT_80_TCP_PORT",
                    "value": "49221"
                },
                {
                    "container": "/api/v1/container/f5d64083-7698-4aec-b5dc-86a48be0f565/",
                    "key": "MY_AWESOME_APP_1_PORT_80_TCP_PROTO",
                    "value": "tcp"
                }
            ],
            "container_ports": [
                {
                    "container": "/api/v1/container/f5d64083-7698-4aec-b5dc-86a48be0f565/",
                    "inner_port": 80,
                    "outer_port": 49222,
                    "protocol": "tcp"
                }
            ],
            "container_size": "XS",
            "deployed_datetime": "Sun, 6 Apr 2014 18:11:22 +0000",
            "destroyed_datetime": null,
            "entrypoint": "",
            "exit_code": null,
            "exit_code_msg": null,
            "image_tag": "/api/v1/image/tutum/hello-world/tag/latest/",
            "link_variables": {
                "MY_AWESOME_APP_2_PORT": "tcp://my-awesome-app-2-admin.alpha-dev.tutum.io:49222",
                "MY_AWESOME_APP_2_PORT_80_TCP": "tcp://my-awesome-app-2-admin.alpha-dev.tutum.io:49222",
                "MY_AWESOME_APP_2_PORT_80_TCP_ADDR": "my-awesome-app-2-admin.alpha-dev.tutum.io",
                "MY_AWESOME_APP_2_PORT_80_TCP_PORT": "49222",
                "MY_AWESOME_APP_2_PORT_80_TCP_PROTO": "tcp"
            },
            "linked_from_application": [],
            "linked_to_application": [],
            "name": "my-awesome-app",
            "public_dns": "my-awesome-app-2-admin.alpha-dev.tutum.io",
            "resource_uri": "/api/v1/container/f5d64083-7698-4aec-b5dc-86a48be0f565/",
            "roles": [],
            "run_command": "/run.sh",
            "started_datetime": "Sun, 6 Apr 2014 18:11:22 +0000",
            "state": "Stopping",
            "stopped_datetime": null,
            "unique_name": "my-awesome-app-2",
            "uuid": "f5d64083-7698-4aec-b5dc-86a48be0f565"
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
    >>> container.state
    "Stopping"
    >>> container.refresh()
    True
    >>> container.state
    "Stopped"


Get logs for a container
^^^^^^^^^^^^^^^^^^^^^^^^

.. http:get:: /api/v1/container/(uuid)/logs/

    Returns the logs of the specified container

    **Example request**:

    .. sourcecode:: http

        GET /api/v1/container/f5d64083-7698-4aec-b5dc-86a48be0f565/logs/ HTTP/1.1
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
    >>> container.logs
    "2014-03-24 23:58:08,973 CRIT Supervisor running as root (no user in config file)\n2014-03-24 23:58:08,973 WARN Included extra file \"/etc/supervisor/conf.d/supervisord-apache2.conf\" during parsing"


Terminate a container
^^^^^^^^^^^^^^^^^^^^^

.. http:delete:: /api/v1/container/(uuid)/

    Destroy the specified container and update the target number of containers of the related application. This is not reversible.
    All the data stored in the container will be permanently deleted. The parent application will scale down (will not try to replace it).

    **Example request**:

    .. sourcecode:: http

        DELETE /api/v1/container/f5d64083-7698-4aec-b5dc-86a48be0f565/ HTTP/1.1
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
            "application": "/api/v1/application/1f234d1d-dae5-46c1-9ee5-770575fe3e6f/",
            "autodestroy": "OFF",
            "autoreplace": "OFF",
            "autorestart": "OFF",
            "container_envvars": [
                {
                    "container": "/api/v1/container/f5d64083-7698-4aec-b5dc-86a48be0f565/",
                    "key": "MY_AWESOME_APP_1_PORT",
                    "value": "tcp://my-awesome-app-1-admin.alpha-dev.tutum.io:49221"
                },
                {
                    "container": "/api/v1/container/f5d64083-7698-4aec-b5dc-86a48be0f565/",
                    "key": "MY_AWESOME_APP_1_PORT_80_TCP",
                    "value": "tcp://my-awesome-app-1-admin.alpha-dev.tutum.io:49221"
                },
                {
                    "container": "/api/v1/container/f5d64083-7698-4aec-b5dc-86a48be0f565/",
                    "key": "MY_AWESOME_APP_1_PORT_80_TCP_ADDR",
                    "value": "my-awesome-app-1-admin.alpha-dev.tutum.io"
                },
                {
                    "container": "/api/v1/container/f5d64083-7698-4aec-b5dc-86a48be0f565/",
                    "key": "MY_AWESOME_APP_1_PORT_80_TCP_PORT",
                    "value": "49221"
                },
                {
                    "container": "/api/v1/container/f5d64083-7698-4aec-b5dc-86a48be0f565/",
                    "key": "MY_AWESOME_APP_1_PORT_80_TCP_PROTO",
                    "value": "tcp"
                }
            ],
            "container_ports": [
                {
                    "container": "/api/v1/container/f5d64083-7698-4aec-b5dc-86a48be0f565/",
                    "inner_port": 80,
                    "outer_port": 49222,
                    "protocol": "tcp"
                }
            ],
            "container_size": "XS",
            "deployed_datetime": "Sun, 6 Apr 2014 18:11:22 +0000",
            "destroyed_datetime": null,
            "entrypoint": "",
            "exit_code": 0,
            "exit_code_msg": "Exit code 0 (Success)",
            "image_tag": "/api/v1/image/tutum/hello-world/tag/latest/",
            "link_variables": {
                "MY_AWESOME_APP_2_PORT": "tcp://my-awesome-app-2-admin.alpha-dev.tutum.io:49222",
                "MY_AWESOME_APP_2_PORT_80_TCP": "tcp://my-awesome-app-2-admin.alpha-dev.tutum.io:49222",
                "MY_AWESOME_APP_2_PORT_80_TCP_ADDR": "my-awesome-app-2-admin.alpha-dev.tutum.io",
                "MY_AWESOME_APP_2_PORT_80_TCP_PORT": "49222",
                "MY_AWESOME_APP_2_PORT_80_TCP_PROTO": "tcp"
            },
            "linked_from_application": [],
            "linked_to_application": [],
            "name": "my-awesome-app",
            "public_dns": "my-awesome-app-2-admin.alpha-dev.tutum.io",
            "resource_uri": "/api/v1/container/f5d64083-7698-4aec-b5dc-86a48be0f565/",
            "roles": [],
            "run_command": "/run.sh",
            "started_datetime": "Sun, 6 Apr 2014 18:35:03 +0000",
            "state": "Stopping",
            "stopped_datetime": "Sun, 6 Apr 2014 18:33:53 +0000",
            "unique_name": "my-awesome-app-2",
            "uuid": "f5d64083-7698-4aec-b5dc-86a48be0f565"
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
    >>> container.state
    "Terminating"
    >>> container.refresh()
    True
    >>> container.state
    "Terminated"
