:title: HTTP API

HTTP API
========

.. contents:: Table of Contents


Authorization
-------------

In order to be able to make requests to the API, you should first obtain an ApiKey for your account.
For this, log into Tutum, click on the menu on the upper right corner of the screen, and select **Get Api Key**


Endpoint
--------

The Tutum HTTP API is reachable through the following hostname::

    https://app.tutum.co/

All requests should be sent to this endpoint with the appropriate Authorization header:

.. sourcecode:: bash

    curl -H "Authorization: ApiKey username:apikey" https://app.tutum.co/api/v1/application/



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

    .. sourcecode:: json

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
                            "container_cluster": "/api/v1/application/c2b6448c-6a77-465f-b2e1-7b8c2af5125f/",
                            "inner_port": 3306,
                            "outer_port": null,
                            "protocol": "tcp"
                        }
                    ],
                    "container_size": "XS",
                    "current_num_containers": 1,
                    "deployed_datetime": "Sun, 23 Mar 2014 18:12:11 +0000",
                    "destroyed_datetime": null,
                    "entrypoint": "",
                    "image_tag": "/api/v1/image/tutum/mysql/tag/latest/",
                    "name": "mysql",
                    "resource_uri": "/api/v1/application/b2b6498c-6a77-465f-b6e1-7b8c2af5125f/",
                    "run_command": "/run.sh",
                    "running_num_containers": 1,
                    "started_datetime": "Sun, 23 Mar 2014 18:12:11 +0000",
                    "state": "Running",
                    "stopped_datetime": null,
                    "stopped_num_containers": 0,
                    "target_num_containers": 1,
                    "unique_name": "mysql",
                    "uuid": "b2b6498c-6a77-465f-b6e1-7b8c2af5125f"
                }
            ]
        }

    :reqheader Authorization: required ApiKey authentication header in the format ``ApiKey username:apikey``
    :reqheader Accept: required, only ``application/json`` is supported
    :statuscode 200: no error
    :statuscode 401: unauthorized (wrong credentials)


Get application details
^^^^^^^^^^^^^^^^^^^^^^^

.. http:get:: /api/v1/application/(uuid)/

    Get all the details of an specific application

    **Example request**:

    .. sourcecode:: http

        GET /api/v1/application/b2b6498c-6a77-465f-b6e1-7b8c2af5125f/ HTTP/1.1
        Host: app.tutum.co
        Accept: application/json
        Authorization: ApiKey username:apikey

    **Example response**:

    .. sourcecode:: http

        HTTP/1.1 200 OK
        Cache-Control: must-revalidate, max-age=0
        Content-Type: application/json
        Vary: Accept, Authorization, Cookie

    .. sourcecode:: json

        {
            "autodestroy": "OFF",
            "autoreplace": "OFF",
            "autorestart": "OFF",
            "container_envvars": [],
            "container_ports": [
                {
                    "container_cluster": "/api/v1/application/b2b6498c-6a77-465f-b6e1-7b8c2af5125f/",
                    "inner_port": 3306,
                    "outer_port": null,
                    "protocol": "tcp"
                }
            ],
            "container_size": "XS",
            "containers": [
                "/api/v1/container/3f421179-cc61-4bb7-900a-2454e659ec78/"
            ],
            "current_num_containers": 1,
            "deployed_datetime": "Sun, 23 Mar 2014 18:12:11 +0000",
            "destroyed_datetime": null,
            "entrypoint": "",
            "image_tag": "/api/v1/image/tutum/mysql/tag/latest/",
            "link_variables": {
                "MYSQL-1_PORT": "tcp://mysql-1-admin.beta.tutum.io:49230",
                "MYSQL-1_PORT_3306_TCP": "tcp://mysql-1-admin.beta.tutum.io:49230",
                "MYSQL-1_PORT_3306_TCP_ADDR": "mysql-1-admin.beta.tutum.io",
                "MYSQL-1_PORT_3306_TCP_PORT": "49230",
                "MYSQL-1_PORT_3306_TCP_PROTO": "tcp",
                "MYSQL_TUTUM_API_URL": "https://app.tutum.co/api/v1/application/b2b6498c-6a77-465f-b6e1-7b8c2af5125f/"
            },
            "linked_from_application": [],
            "linked_to_application": [],
            "name": "mysql",
            "resource_uri": "/api/v1/application/b2b6498c-6a77-465f-b6e1-7b8c2af5125f/",
            "roles": [],
            "run_command": "/run.sh",
            "running_num_containers": 1,
            "started_datetime": "Sun, 23 Mar 2014 18:12:11 +0000",
            "state": "Running",
            "stopped_datetime": null,
            "stopped_num_containers": 0,
            "target_num_containers": 1,
            "unique_name": "mysql",
            "uuid": "b2b6498c-6a77-465f-b6e1-7b8c2af5125f"
        }

    :query uuid: the UUID of the application
    :reqheader Authorization: required ApiKey authentication header in the format ``ApiKey username:apikey``
    :reqheader Accept: required, only ``application/json`` is supported
    :statuscode 200: no error
    :statuscode 404: application not found
    :statuscode 401: unauthorized (wrong credentials)


Create a new application
^^^^^^^^^^^^^^^^^^^^^^^^

.. http:post:: /api/v1/application/

    Creates and deploys a new application

    :jsonparam string image_tag: required, the image used to deploy this application, i.e. ``tutum/hello-world``
    :jsonparam string name: optional, a human-readable name for the application, i.e. ``my-hello-world-app`` (default: image_tag without namespace)
    :jsonparam string container_size: optional, the size of the application containers, i.e. ``M`` (default: ``XS``)
    :jsonparam string run_command: optional, the command used to start the application containers, i.e. ``/run.sh`` (default: as defined in the image)
    :jsonparam string entrypoiny: optional, the command prefix used to start the application containers, i.e. ``/usr/sbin/sshd`` (default: as defined in the image)
    :jsonparam int target_num_containers: the number of containers to run for this application (default: 1)
    :reqheader Authorization: required ApiKey authentication header in the format ``ApiKey username:apikey``
    :reqheader Accept: required, only ``application/json`` is supported
    :statuscode 202: operation accepted
    :statuscode 400: cannot perform the operation (probably the application is not in a suitable state)
    :statuscode 401: unauthorized (wrong credentials)


Update an application
^^^^^^^^^^^^^^^^^^^^^

.. http:patch:: /api/v1/application/(uuid)/

    Updates the application details and scales the application up or down accordingly

    :query uuid: the UUID of the application
    :jsonparam int target_num_containers: optional, the target number of containers to scale this application to
    :reqheader Authorization: required ApiKey authentication header in the format ``ApiKey username:apikey``
    :reqheader Accept: required, only ``application/json`` is supported
    :statuscode 202: operation accepted
    :statuscode 400: cannot perform the operation (probably the application is not in a suitable state)
    :statuscode 401: unauthorized (wrong credentials)


Start an application
^^^^^^^^^^^^^^^^^^^^

.. http:post:: /api/v1/application/(uuid)/start/

    Starts all the containers in a stopped application

    :query uuid: the UUID of the application
    :reqheader Authorization: required ApiKey authentication header in the format ``ApiKey username:apikey``
    :reqheader Accept: required, only ``application/json`` is supported
    :statuscode 202: operation accepted
    :statuscode 400: cannot perform the operation (probably the application is not in a suitable state)
    :statuscode 401: unauthorized (wrong credentials)


Stop an application
^^^^^^^^^^^^^^^^^^^

.. http:post:: /api/v1/application/(uuid)/stop/

    Stops all the containers in a running application

    :query uuid: the UUID of the application
    :reqheader Authorization: required ApiKey authentication header in the format ``ApiKey username:apikey``
    :reqheader Accept: required, only ``application/json`` is supported
    :statuscode 202: operation accepted
    :statuscode 400: cannot perform the operation (probably the application is not in a suitable state)
    :statuscode 401: unauthorized (wrong credentials)


Terminate an application
^^^^^^^^^^^^^^^^^^^^^^^^

.. http:delete:: /api/v1/application/(uuid)/

    Destroy all the containers in an application. This is not reversible. All the data stored in all the application containers will be permanently deleted.

    :query uuid: the UUID of the application
    :reqheader Authorization: required ApiKey authentication header in the format ``ApiKey username:apikey``
    :reqheader Accept: required, only ``application/json`` is supported
    :statuscode 202: operation accepted
    :statuscode 400: cannot perform the operation (probably the application is not in a suitable state)
    :statuscode 401: unauthorized (wrong credentials)


Containers
----------

List all containers
^^^^^^^^^^^^^^^^^^^

.. http:get:: /api/v1/container/

    Returns a paginated list of all containers for all applications for the authenticated user

    :reqheader Authorization: required ApiKey authentication header in the format ``ApiKey username:apikey``
    :reqheader Accept: required, only ``application/json`` is supported
    :statuscode 200: no error
    :statuscode 401: unauthorized (wrong credentials)


Get container details
^^^^^^^^^^^^^^^^^^^^^

.. http:get:: /api/v1/container/(uuid)/

    Get all the details of an specific container

    :reqheader Authorization: required ApiKey authentication header in the format ``ApiKey username:apikey``
    :reqheader Accept: required, only ``application/json`` is supported
    :statuscode 200: no error
    :statuscode 404: container not found
    :statuscode 401: unauthorized (wrong credentials)


Start a container
^^^^^^^^^^^^^^^^^

.. http:post:: /api/v1/container/(uuid)/start/

    Starts a container that was previously stopped

    :query uuid: the UUID of the container
    :reqheader Authorization: required ApiKey authentication header in the format ``ApiKey username:apikey``
    :reqheader Accept: required, only ``application/json`` is supported
    :statuscode 202: operation accepted
    :statuscode 400: cannot perform the operation (probably the container is not in a suitable state)
    :statuscode 401: unauthorized (wrong credentials)
    :statuscode 404: container not found


Stop a container
^^^^^^^^^^^^^^^^

.. http:post:: /api/v1/container/(uuid)/stop/

    Stops a running container

    :query uuid: the UUID of the container
    :reqheader Authorization: required ApiKey authentication header in the format ``ApiKey username:apikey``
    :reqheader Accept: required, only ``application/json`` is supported
    :statuscode 202: operation accepted
    :statuscode 400: cannot perform the operation (probably the container is not in a suitable state)
    :statuscode 401: unauthorized (wrong credentials)
    :statuscode 404: container not found


Get logs for a container
^^^^^^^^^^^^^^^^^^^^^^^^

.. http:get:: /api/v1/container/(uuid)/logs/

    Returns the logs of the specified container

    :query uuid: the UUID of the container
    :reqheader Authorization: required ApiKey authentication header in the format ``ApiKey username:apikey``
    :reqheader Accept: required, only ``application/json`` is supported
    :statuscode 202: operation accepted
    :statuscode 400: cannot perform the operation (probably the container is not in a suitable state)
    :statuscode 401: unauthorized (wrong credentials)
    :statuscode 404: container not found


Terminate a container
^^^^^^^^^^^^^^^^^^^^^

.. http:delete:: /api/v1/container/(uuid)/

    Destroy the specified container and update the target number of containers of the related application. This is not reversible.
    All the data stored in the container will be permanently deleted.

    :query uuid: the UUID of the container
    :reqheader Authorization: required ApiKey authentication header in the format ``ApiKey username:apikey``
    :reqheader Accept: required, only ``application/json`` is supported
    :statuscode 202: operation accepted
    :statuscode 400: cannot perform the operation (probably the container is not in a suitable state)
    :statuscode 401: unauthorized (wrong credentials)
    :statuscode 404: container not found


